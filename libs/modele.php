<?php
include_once("maLibSQL.pdo.php"); 
// définit les fonctions SQLSelect, SQLUpdate...


// Users ///////////////////////////////////////////////////

function validerUser($pseudo, $pass){
	$SQL = "SELECT id FROM exos_users WHERE pseudo='$pseudo' AND pass='$pass'";
	if ($id=SQLGetChamp($SQL))
		return getHash($id);
	else return false;
}

function hash2id($hash) {
	$SQL = "SELECT id FROM exos_users WHERE hash='$hash'";
	return SQLGetChamp($SQL); 
}

function hash2pseudo($hash) {
	$SQL = "SELECT pseudo FROM exos_users WHERE hash='$hash'";
	return SQLGetChamp($SQL); 
}

function getUsers(){
	$SQL = "SELECT id,pseudo FROM exos_users";
	return parcoursRs(SQLSelect($SQL));
}

function getUser($idUser){
	$SQL = "SELECT id,pseudo FROM exos_users WHERE id='$idUser'";
	$rs = parcoursRs(SQLSelect($SQL));
	if (count($rs)) return $rs[0]; 
	else return array();
}

function getHash($idUser){
	$SQL = "SELECT hash FROM exos_users WHERE id='$idUser'";
	return SQLGetChamp($SQL);
}

function mkHash($idUser) {
	// génère un (nouveau) hash pour cet user
	// il faudrait ajouter une date d'expiration
	$dataUser = getUser($idUser);
	if (count($dataUser) == 0) return false;
 
	$payload = $dataUser["pseudo"] . date("H:i:s");
	$hash = md5($payload); 
	$SQL = "UPDATE exos_users SET hash='$hash' WHERE id='$idUser'"; 
	SQLUpdate($SQL); 
	return $hash; 
}

function mkUser($pseudo, $pass){
	$SQL = "INSERT INTO exos_users(pseudo,pass) VALUES('$pseudo', '$pass')";
	$idUser = SQLInsert($SQL);
	mkHash($idUser); 
	return $idUser; 
}


function rmUser($idUser) {
	$SQL = "DELETE FROM exos_users WHERE id='$idUser'";
	return SQLDelete($SQL);
}

function chgPassword($idUser,$pass) {
	$SQL = "UPDATE exos_users SET pass='$pass' WHERE id='$idUser'";
	SQLUpdate($SQL);
	return 1; 
}

// Ingredients ///////////////////////////////////////////////////

function getExercices(){
	$SQL = "SELECT id, nom, unite FROM exos_exercices"; 
	return parcoursRs(SQLSelect($SQL));
}

function searchExercicesByNom($nom){
	$SQL = "SELECT id, nom, unite FROM exos_exercices WHERE nom LIKE '%$nom%'";
	return parcoursRs(SQLSelect($SQL));
}


function getExercice($id){
	$SQL = "SELECT id, nom, unite FROM exos_exercices WHERE id='$id'"; 
	$rs = parcoursRs(SQLSelect($SQL));
	if (count($rs)) return $rs[0]; 
	else return array();
}

function mkExercice($nom, $unite=""){
	$SQL = "INSERT INTO exos_exercices(nom, unite) VALUES('$nom','$unite')";
	return SQLInsert($SQL);
}

function rmExercice($id) {
	$SQL = "DELETE FROM exos_exercices WHERE id='$id'"; 
	return SQLDelete($SQL);
}

function chgNomExercice($id,$nom) {
	$SQL = "UPDATE exos_exercices SET nom='$nom' WHERE id='$id'";
	SQLUpdate($SQL);
	return 1; 
	// return SQLUpdate() pose souci si il n'y a pas modif de nom
	// SQLUpdate renvoie alors 0 ! 
}


function chgUniteExercice($id,$unite) {
	$SQL = "UPDATE exos_exercices SET unite='$unite' WHERE id='$id'";
	SQLUpdate($SQL);
	return 1; 
	// return SQLUpdate() pose souci si il n'y a pas modif de nom
	// SQLUpdate renvoie alors 0 ! 
}


// Cocktails ///////////////////////////////////////////////////
function getCycles(){
	$SQL = "SELECT c.id, c.nom, c.commentaires, u.pseudo FROM exos_cycles c INNER JOIN exos_users u ON c.idUser = a.id"; 
	return parcoursRs(SQLSelect($SQL));
}

function getCycle($id,$idUser=false){
	$SQL = "SELECT id,nom,commentaires FROM exos_cycles WHERE id='$id'"; 
	if ($idUser)
		$SQL .= " AND idUser='$idUser'"; 
	$rs = parcoursRs(SQLSelect($SQL));
	if (count($rs)) return $rs[0]; 
	else return array();
}

function isUserOwnerOfCycle($idUser,$idCycle) {
	$SQL = "SELECT id FROM exos_cycles WHERE id='$idCycle'"; 
	$SQL .= " AND idUser='$idUser'"; 
	return SQLGetChamp($SQL); 
}

function getCyclesUser($idUser){
	$SQL = "SELECT id,nom,commentaires FROM exos_cycles WHERE idUser='$idUser'"; 
	return parcoursRs(SQLSelect($SQL));
}


function mkCycle($idUser, $nom){
	$SQL = "INSERT INTO exos_cycles(idUser,nom) VALUES('$idUser', '$nom')";
	return SQLInsert($SQL);
}

function rmCYcle($id, $idUser=false) {
	$SQL = "DELETE FROM exos_cycles WHERE id='$id'";
	if ($idUser) $SQL .= " AND idUser='$idUser'"; 
	return SQLDelete($SQL);
}

function chgNomCycle($id,$nom, $idUser=false) {
	$SQL = "UPDATE exos_cycles SET nom='$nom' WHERE id='$id'";
	if ($idUser) $SQL .= " AND idUser='$idUser'";
	SQLUpdate($SQL);
	return 1; 
	// return SQLUpdate() pose souci si il n'y a pas modif de nom
	// SQLUpdate renvoie alors 0 ! 
}

function chgCommentairesCycle($id,$commentaires, $idUser=false) {
	$SQL = "UPDATE exos_cycles SET commentaires='$commentaires' WHERE id='$id'";
	if ($idUser) $SQL .= " AND idUser='$idUser'";
	SQLUpdate($SQL);
	return 1; 
	// return SQLUpdate() pose souci si il n'y a pas modif de nom
	// SQLUpdate renvoie alors 0 ! 
}

// Composants ///////////////////////////////////////////////////

function getExos($idCycle) {
	$SQL = "SELECT c.id,c.idExo, c.quantite, i.nom, i.unite FROM exos_composants c INNER JOIN exos_exercices i ON i.id = c.idExo WHERE idCycle='$idCycle'"; 
	return parcoursRs(SQLSelect($SQL));
}

function getExo($id, $idCycle) {
	$SQL = "SELECT c.id,c.idExo, c.quantite, i.nom, i.unite FROM exos_composants c INNER JOIN exos_exercices i ON i.id = c.idExo WHERE c.idCycle='$idCycle' AND c.id='$id'";

	$rs = parcoursRs(SQLSelect($SQL));
	if (count($rs)) return $rs[0]; 
	else return array();
}


function rmExo($id,$idCycle) {
	// TODO : laisser idCycle ?	
	$SQL = "DELETE FROM exos_composants WHERE id='$id' AND idCycle='$idCycle'";
	return SQLDelete($SQL);
}

function mkExo($idCycle, $idExercice, $quantite=""){
	$SQL = "INSERT INTO exos_composants(idCycle,idExo, quantite) VALUES('$idCycle', '$idExercice', '$quantite')";
	return SQLInsert($SQL);
}



function chgQuantiteExo($id,$quantite,$idCycle=false) {
	// TODO : laisser idCocktail ?
	$SQL = "UPDATE exos_composants SET quantite='$quantite' WHERE id='$id'";
	if ($idCycle) $SQL .=  " AND idCycle='$idCocktail'"; 
	SQLUpdate($SQL);
	return 1; 
}




?>
