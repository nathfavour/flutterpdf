#ifndef NATIVEPDF_H
#define NATIVEPDF_H

#ifdef __cplusplus
extern "C" {
#endif

void* open_pdf(const char* path);
int get_page_count(void* handle);
int render_page(void* handle, int page, void* buffer, int width, int height);
void close_pdf(void* handle);

#ifdef __cplusplus
}
#endif

#endif // NATIVEPDF_H