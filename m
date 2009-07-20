From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 5/5] Makefile.in: allow make install e4defrag
Date: Mon, 20 Jul 2009 09:52:50 -0500
Message-ID: <4A6484C2.9090802@redhat.com>
References: <1248025714-25954-1-git-send-email-bergwolf@gmail.com> <4A639228.9090905@redhat.com> <4A63F0B1.7090002@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Peng Tao <bergwolf@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:41814 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439AbZGTOw4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Jul 2009 10:52:56 -0400
In-Reply-To: <4A63F0B1.7090002@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Peng Tao wrote:

> From 248322ee72e371dcd1b302400d787f9f2eec15cd Mon Sep 17 00:00:00 2001
> From: Peng Tao <bergwolf@gmail.com>
> Date: Mon, 20 Jul 2009 12:01:55 +0800
> Subject: [PATCH-e2fsprogs] Makefile.in: add install-e4defrag target
> 
> The e4defrag program is still developmental, but we can make it available
> for use if someone wants to test it.
> 
> Signed-off-by: Peng Tao <bergwolf@gmail.com>

I like this better, thanks!  I'll ask on the ext4 call today if others
concur.

-Eric

> ---
>  Makefile.in      |    3 +++
>  misc/Makefile.in |    6 +++++-
>  2 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/Makefile.in b/Makefile.in
> index 45f2972..1c2b44e 100644
> --- a/Makefile.in
> +++ b/Makefile.in
> @@ -57,6 +57,9 @@ clean-doc:
>  distclean-doc:
>  	-test -d doc && cd doc && $(MAKE) distclean
>  
> +install-e4defrag: subs all-libs-recursive
> +	$(MAKE) -C misc install-e4defrag
> +
>  install: subs all-libs-recursive install-progs-recursive \
>    install-shlibs-libs-recursive install-doc-libs
>  	if test ! -d e2fsck && test ! -d debugfs && test ! -d misc && test ! -d ext2ed ; then $(MAKE) install-libs ; fi
> diff --git a/misc/Makefile.in b/misc/Makefile.in
> index 5f5dab5..029a201 100644
> --- a/misc/Makefile.in
> +++ b/misc/Makefile.in
> @@ -399,6 +399,10 @@ installdirs:
>  		$(DESTDIR)$(man1dir) $(DESTDIR)$(man5dir) \
>  		$(DESTDIR)$(libdir) $(DESTDIR)/$(root_sysconfdir)
>  
> +install-e4defrag: e4defrag e4defrag.8 installdirs
> +	$(INSTALL_PROGRAM) e4defrag $(DESTDIR)$(bindir)/e4defrag
> +	$(INSTALL_DATA) e4defrag.8 $(DESTDIR)$(man8dir)/e4defrag.8
> +
>  install: all $(SMANPAGES) $(UMANPAGES) installdirs
>  	$(Q) for i in $(SPROGS); do \
>  		echo "	INSTALL $(root_sbindir)/$$i"; \
> @@ -556,7 +560,7 @@ clean:
>  		blkid.profiled tune2fs.profiled e2image.profiled \
>  		e2undo.profiled mke2fs.profiled dumpe2fs.profiled \
>  		logsave.profiled filefrag.profiled uuidgen.profiled \
> -		uuidd.profiled e2image.profiled \
> +		uuidd.profiled e2image.profiled e4defrag \
>  		profiled/*.o \#* *.s *.o *.a *~ core gmon.out
>  
>  mostlyclean: clean

