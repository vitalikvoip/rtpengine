RTPENGINE_ROOT_DIR=.

include lib/lib.Makefile

.PHONY:	all distclean clean coverity

all:
	$(MAKE) -C daemon

.PHONY: with-kernel

with-kernel: all
	$(MAKE) -C kernel-module

distclean clean:
	$(MAKE) -C daemon clean
	rm -rf project.tgz cov-int

.DEFAULT:
	$(MAKE) -C daemon $@

coverity:
	cov-build --dir cov-int $(MAKE) check
	tar -czf project.tgz cov-int
	curl --form token=$(COVERITY_RTPENGINE_TOKEN) \
	  --form email=$(DEBEMAIL) \
	  --form file=@project.tgz \
	  --form version="$(RTPENGINE_VERSION)" \
	  --form description="automatic upload" \
	  https://scan.coverity.com/builds?project=$(COVERITY_RTPENGINE_PROJECT)
