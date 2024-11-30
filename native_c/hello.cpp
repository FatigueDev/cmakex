#include <iostream>
#include <raylib.h>
#include <erl_nif.h>

int main() {
    std::cout << "Hello, world!" << std::endl;
    
    return 0;
}

static ERL_NIF_TERM check(ErlNifEnv *env, int argc, const ERL_NIF_TERM *argv) {
    if(IsWindowReady()) {
        CloseWindow();
    }
    else {
        InitWindow(300, 500, "Test!");
    }

    return enif_make_atom(env, "ok");
}

static ErlNifFunc nif_funcs[] = {
    {"check", 0, check, 0}
    // {"do_log", 0, &do_log, 0}
};

ERL_NIF_INIT(Elixir.Example.Nif, nif_funcs, NULL, NULL, NULL, NULL)