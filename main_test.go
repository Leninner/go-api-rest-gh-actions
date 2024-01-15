package main

import (
	"bytes"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/gorilla/mux"
)

func Router() *mux.Router {
	router := mux.NewRouter().StrictSlash(true)

	router.HandleFunc("/", indexRoute).Methods("GET")
	router.HandleFunc("/tasks", getTasks).Methods("GET")
	router.HandleFunc("/tasks", createTask).Methods("POST")
	router.HandleFunc("/tasks/{id}", getTask).Methods("GET")
	router.HandleFunc("/tasks/{id}", deleteTask).Methods("DELETE")
	router.HandleFunc("/tasks/{id}", updateTask).Methods("PUT")

	return router
}

func TestIndexRoute(t *testing.T) {
	request, _ := http.NewRequest("GET", "/", nil)
	response := httptest.NewRecorder()
	Router().ServeHTTP(response, request)
	if response.Code != 200 {
		t.Errorf("Expected response code 200. Got %v", response.Code)
	}
}

func TestGetTasks(t *testing.T) {
	request, _ := http.NewRequest("GET", "/tasks", nil)
	response := httptest.NewRecorder()
	Router().ServeHTTP(response, request)
	if response.Code != 200 {
		t.Errorf("Expected response code 200. Got %v", response.Code)
	}
}

func TestCreateTask(t *testing.T) {
	task := &task{
		Name:    "Test Task",
		Content: "Test Content",
	}
	jsonTask, _ := json.Marshal(task)
	request, _ := http.NewRequest("POST", "/tasks", bytes.NewBuffer(jsonTask))
	response := httptest.NewRecorder()
	Router().ServeHTTP(response, request)
	if response.Code != 200 {
		t.Errorf("Expected response code 200. Got %v", response.Code)
	}
}

func TestGetTask(t *testing.T) {
	request, _ := http.NewRequest("GET", "/tasks/1", nil)
	response := httptest.NewRecorder()
	Router().ServeHTTP(response, request)
	if response.Code != 200 {
		t.Errorf("Expected response code 200. Got %v", response.Code)
	}
}

func TestDeleteTask(t *testing.T) {
	request, _ := http.NewRequest("DELETE", "/tasks/1", nil)
	response := httptest.NewRecorder()
	Router().ServeHTTP(response, request)
	if response.Code != 200 {
		t.Errorf("Expected response code 200. Got %v", response.Code)
	}
}

func TestUpdateTask(t *testing.T) {
	task := &task{
		Name:    "Updated Task",
		Content: "Updated Content",
	}
	jsonTask, _ := json.Marshal(task)
	request, _ := http.NewRequest("PUT", "/tasks/1", bytes.NewBuffer(jsonTask))
	response := httptest.NewRecorder()
	Router().ServeHTTP(response, request)
	if response.Code != 200 {
		t.Errorf("Expected response code 200. Got %v", response.Code)
	}
}
