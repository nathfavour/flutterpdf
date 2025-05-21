#include "nativepdf.h"
#include <poppler/glib/poppler.h>
#include <stdlib.h>
#include <string.h>
#include <glib-2.0/glib/gerror.h>

typedef struct {
    PopplerDocument *doc;
    int page_count;
} PdfHandle;

void* open_pdf(const char* path) {
    GError* error = NULL;
    PopplerDocument* doc = poppler_document_new_from_file(
        g_strdup_printf("file://%s", path), NULL, &error);
    if (error) return NULL;
    PdfHandle* handle = malloc(sizeof(PdfHandle));
    handle->doc = doc;
    return handle;
}


int get_page_count(void* handle) {
    if (!handle) return 0;
    PdfHandle* h = (PdfHandle*)handle;
    return poppler_document_get_n_pages(h->doc);
}


// this is a stub file function for us to implement actual rendering
int render_page(void* handle, int page, void* buffer, int width, int height) {
    // TODO: use poppler to render the page to the buffer
    if (!handle || !buffer) return 0;
    memset(buffer, 0xFF, width * height * 4); //White RGBA
    return 1;
}

void close_pdf(void* handle) {
    if (!handle) return;
    PdfHandle* h = (PdfHandle*)handle;
    g_object_unref(h->doc);
    free(h);
}