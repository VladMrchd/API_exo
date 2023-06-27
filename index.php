<?php
include_once("libs/maLibUtils.php");
include_once("libs/modele.php");

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: *");
header("Access-Control-Allow-Headers: *");


$data = array("version"=>1.1);

// 1.1 : interdiction de modification des users 1 et 2

// Routes : /api/...

$method = $_SERVER["REQUEST_METHOD"];
debug("method",$method);

if ($method == "OPTIONS") die("ok - OPTIONS");

$data["success"] = false;
$data["status"] = 400;
$data["apiname"] = "cycles"; 

// Verif autorisation : il faut un hash
// Il peut être dans le header, ou dans la chaîne de requête

$connected = false; 

if (!($hash = valider("hash"))) 
	$hash = valider("HTTP_HASH","SERVER"); 

if($hash) {
	// Il y a un hash, il doit être correct...
	if ($connectedId = hash2id($hash)) $connected = true; 
	else {
		// non connecté - peut-être est-ce POST vers /autenticate...
		$method = "error";
		$data["status"] = 403;
	}
}

if (valider("request")) {
	$requestParts = explode('/',$_REQUEST["request"]);

	debug("rewrite-request" ,$_REQUEST["request"] ); 
	debug("#parts", count($requestParts) ); 

	$entite1 = false;
	$idEntite1 = false;
	$entite2 = false; 
	$idEntite2 = false; 

	if (count($requestParts) >0) {
		$entite1 = $requestParts[0];
		debug("entite1",$entite1); 
	} 

	if (count($requestParts) >1) {	
		if (is_id($requestParts[1])) {
			$idEntite1 = intval($requestParts[1]);
			debug("idEntite1",$idEntite1); 
		} else {
			// erreur !
			$method = "error";
			$data["status"] = 400; 
		}
	}

	if (count($requestParts) >2) {
		$entite2 = $requestParts[2];
		debug("entite2",$entite2); 
	}

	if (count($requestParts) >3) {
		if (is_id($requestParts[3])) {
			$idEntite2 = intval($requestParts[3]);
			debug("idEntite2",$idEntite2); 
		} else {
			// erreur !
			$method = "error";
			$data["status"] = 400;
		}

	}  

// TODO: en cas d'erreur : changer $method pour préparer un case 'erreur'

	$action = $method; 
	if ($entite1) $action .= "_$entite1";
	if ($entite2) $action .= "_$entite2";
 
	debug("action", $action);

	if ($action == "POST_authenticate") {
		if ($user = valider("user"))
		if ($password = valider("password")) {
			if ($hash = validerUser($user, $password)) {
				$data["hash"] = $hash;
				$data["success"] = true;
				$data["status"] = 202;
			} else {
				// connexion échouée
				$data["status"] = 401;
			}
		}
	}
	elseif ($connected)
	{
		// On connaît $connectedId
		switch ($action) {

			case 'GET_users' :			
				if ($idEntite1) {
					// GET /api/users/<id>
					$data["user"] = getUser($idEntite1);
					$data["success"] = true;
					$data["status"] = 200; 
				} 
				else {
					// GET /api/users
					$data["users"] = getUsers();
					$data["success"] = true;
					$data["status"] = 200;
				}
			break; 
			
			case 'GET_exercices' :			
				if ($idEntite1) {
					// GET /api/exercices/<id>
					$data["exercice"] = getExercice($idEntite1);
					$data["success"] = true;
					$data["status"] = 200; 
				} 
				else {
					if ($nom = valider("nom")) {
						// recherche par nom 
						// et peut-être par type ? 
						
						$data["exercices"] = searchExercicesByNom($nom);
						$data["success"] = true;
						$data["status"] = 200;
						
					}  else {
						// affichage de tout 
						// GET /api/exercices
						$data["exercices"] = getExercices();
						$data["success"] = true;
						$data["status"] = 200;
					}
				}
			break;

			case 'GET_users_cycles' : 
				if ($idEntite1)
				if ($idEntite2) {
					// GET /api/users/<id>/cycles/<id>
					$data["cycle"] = getCycle($idEntite2, $idEntite1);
					$data["success"] = true;
					$data["status"] = 200;
				} else {
					// GET /api/users/<id>/articles
					$data["cycles"] = getCyclesUser($idEntite1);
					$data["success"] = true;
					$data["status"] = 200;
				}
			break;

			case 'GET_cycles' : 
				if ($idEntite1){
					// GET /api/cycles/<id>					
					$data["cycle"] = getCycle($idEntite1,$connectedId);
					$data["exos"] = getExos($idEntite1); // TODO : pas verif user 
					$data["success"] = true;
					$data["status"] = 200;
				} else {
					// GET /api/cycles
					// Les listes de l'utilisateur connecté
					$data["cycles"] = getCyclesUser($connectedId);
					$data["success"] = true;
					$data["status"] = 200; 
				}
			break;

			case 'GET_cycles_exos' : 
				if ($idEntite1)
				if ($idEntite2) {
					// GET /api/cycles/<id>/exos/<id>
					$data["exos"] = getExos($idEntite2, $idEntite1); // TODO : distinguer null de 0 ? 
					$data["success"] = true;
					$data["status"] = 200;
				} else {
					// GET /api/cycles/<id>/exos
					$data["exos"] = getExos($idEntite1);
					$data["success"] = true;
					$data["status"] = 200;		 
				}
			break; 

			case 'POST_users' : 
				// POST /api/users?pseudo=&pass=...
				if ($pseudo = valider("user"))
				if ($pass = valider("password")) {
					$id = mkUser($pseudo, $pass); 
					$data["user"] = getUser($id);
					$data["success"] = true;
					$data["status"] = 201;
				}
			break; 
			
			case 'POST_exercices' : 
				// POST /api/exercices?nom=&unite=&alcoolise=...
				if ($nom = valider("nom"))
				{
					
					$id = mkExercice($nom); 
					$data["exercice"] = getExercice($id);
					$data["success"] = true;
					$data["status"] = 201;
				}
			break; 

/* INUTILE ? on ne doit pas pouvoir créer de cycles pour d'autres
			case 'POST_users_cycles' :
				// POST /api/users/<id>/cycles?nom=...
				if ($idEntite1)
				if (($titre = valider("nom")) !== false) {
					if ($connectedId != $idEntite1) {
						$data["status"] = 403;
					} else {
						$id = mkcycle($idEntite1, $titre); 
						$data["cycle"] = getcycle($id);
						$data["success"] = true;
						$data["status"] = 201;
					}
				}
			break; 
*/

			case 'POST_cycles_exos' :
				// NB : écrire /exo/id renvoie à l'id du exo, 
				// pas à l'id de l'ingrédient
				// POST /api/cycles/<id>/exos?idExercice=...
				if ($idEntite1)
				if (($idExercice = valider("idExercice")) !== false) {
					if (!isUserOwnerOfCycle($connectedId,$idEntite1)) {
						$data["status"] = 403;
					} else {
						$id = mkExo($idEntite1, $idExercice);	
						$data["exo"] = getExo($id,$idEntite1);				
						$data["success"] = true; 
						$data["status"] = 201;
					}
				}
			break; 

			case 'POST_cycles' :
				// POST /api/cycles?nom=...
				if (($nom = valider("nom")) !== false) {
					$id = mkCycle($connectedId, $nom); 
					$data["cycle"] = getCycle($id);
					$data["success"] = true; 
					$data["status"] = 201;
				}
			break;

			case 'PUT_authenticate' : 
				// régénère un hash ? 
				$data["hash"] = mkHash($connectedId); 
				$data["success"] = true; 
				$data["status"] = 200;
			break; 

			case 'PUT_users' :
				// PUT  /api/users/?pass=...
				if ($connectedId)
				if ($pass = valider("password")) {
                  	if (($connectedId == 1) || ($connectedId==2)) {
                          $data["status"] = 403;
                        } else if (chgPassword($connectedId,$pass)) {
						$data["user"] = getUser($connectedId);
						$data["success"] = true; 
						$data["status"] = 200;
					} else {
						// erreur 
					}
				}
			break; 
	
/*	INUTILE ? 
			case 'PUT_users_cycles' : 
				// PUT /api/users/<id>/cycles/<id>?nom=...
				if ($idEntite1)
				if ($idEntite2)
				if (($titre = valider("nom")) !== false) {
					if ($connectedId != $idEntite1) {
						$data["status"] = 403;
					} else {
						if (chgNomCycle($idEntite2,$titre,$idEntite1)) {
							$data["article"] = getCycle($idEntite2);
							$data["success"] = true; 
							$data["status"] = 200;
						} else {
							// erreur
						}
					}
				}
			break; 
*/			

			case 'PUT_exercices' : 
				// PUT /api/exercices/<id>?nom=... // ?unite= // ?alcoolise=...
				if ($idEntite1)
				if (($nom = valider("nom")) !== false) {
					if (chgNomExercice($idEntite1,$nom)) {
							$data["exercice"] = getExercice($idEntite1);
							$data["success"] = true; 
							$data["status"] = 200;
						} else {
							// erreur
					}
				}
				
				
			break; 

			case 'PUT_cycles' : 
				// PUT /api/cycles/<id>?nom=...
				if ($idEntite1)
				if (($nom = valider("nom")) !== false) {
					if (!isUserOwnerOfCycle($connectedId,$idEntite1)) {
						$data["status"] = 403;
					} else {
						if (chgNomCycle($idEntite1,$nom,$connectedId)) {
							$data["cycle"] = getCycle($idEntite1);
							$data["success"] = true; 
							$data["status"] = 200;
						} else {
							// erreur
						}
					}
				}
				
				// NB : on ne peut vider les commentaires 
				// car un champ vide est considéré comme égal à false
				// attention aux failles XSS

			break; 


			case 'DELETE_users' : 
				// DELETE /api/users/<id> 
				if ($idEntite1) {
					if ($connectedId != $idEntite1) {
						$data["status"] = 403;
					} else {
                      	if (($idEntite1 == 1) || ($idEntite1==2)) {
                          $data["status"] = 403;
                        } else if (rmUser($idEntite1)) {
							$data["success"] = true;
							$data["status"] = 200;
						} else {
							// erreur 
						} 
					}
				}
			break; 

			case 'DELETE_users_cycles' : 
				// DELETE /api/users/<id>/cycles/<id>
				if ($idEntite1)
				if ($idEntite2) {
					if ($connectedId != $idEntite1) {
						$data["status"] = 403;
					} else {
						if (rmCycle($idEntite2, $idEntite1)) {				
							$data["success"] = true;
							$data["status"] = 200; 
						} else {
							// erreur 
						}
					}
				}
			break; 

			case 'DELETE_cycles' : 
				// DELETE /api/cycles/<id>
				if ($idEntite1) {
					if (!isUserOwnerOfCycle($connectedId,$idEntite1)) {
						$data["status"] = 403;
					} else {
						if (rmCycle($idEntite1, $connectedId)) {				
							$data["success"] = true;
							$data["status"] = 200; 
						} else {
							// erreur 
						}
					}
				}
			break; 
			
			case 'DELETE_exercices' : 
				// DELETE /api/exercices/<id>
				if ($idEntite1) {
					if (rmExercice($idEntite1)) {				
							$data["success"] = true;
							$data["status"] = 200; 
						} else {
							// erreur 
						}
				}
			break; 

			case 'DELETE_cycles_exos' : 
				// DELETE /api/cycles/<id>/exos/<id>
				if ($idEntite1)
				if ($idEntite2) {
					if (!isUserOwnerOfCycle($connectedId,$idEntite1)) {
						$data["status"] = 403;
					} else {
						if (rmExo($idEntite2, $idEntite1)) {				
							$data["success"] = true;
							$data["status"] = 200;  
						} else {
							// erreur 
						}
					}
				}
			break; 
		} // switch(action)
	} //connected
}

switch($data["status"]) {
	case 200: header("HTTP/1.0 200 OK");	break;
	case 201: header("HTTP/1.0 201 Created");	break; 
	case 202: header("HTTP/1.0 202 Accepted");	break;
	case 204: header("HTTP/1.0 204 No Content");	break;
	case 400: header("HTTP/1.0 400 Bad Request");	break; 
	case 401: header("HTTP/1.0 401 Unauthorized");	break; 
	case 403: header("HTTP/1.0 403 Forbidden");		break; 
	case 404: header("HTTP/1.0 404 Not Found");		break;
	default: header("HTTP/1.0 200 OK");
		
}

echo json_encode($data);

?>
