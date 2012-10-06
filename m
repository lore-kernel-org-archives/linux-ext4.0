From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 3/3] Fix makefiles to compile e2freefrag with profiling
Date: Sat, 06 Oct 2012 10:54:48 -0500
Message-ID: <50705448.8050907@redhat.com>
References: <1349408695-11661-2-git-send-email-tytso@mit.edu> <1349489052-18657-1-git-send-email-tytso@mit.edu> <1349489052-18657-3-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46167 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754199Ab2JFPyv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 6 Oct 2012 11:54:51 -0400
In-Reply-To: <1349489052-18657-3-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/5/12 9:04 PM, Theodore Ts'o wrote:
> Also fix a bug caused by a stray continuation backslash which caused
> the e2fsck/Makefile to fail when profiling is enabled.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  e2fsck/Makefile.in | 2 +-
>  misc/Makefile.in   | 8 +++++++-
>  2 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/e2fsck/Makefile.in b/e2fsck/Makefile.in
> index a52bbe1..87b71bd 100644
> --- a/e2fsck/Makefile.in
> +++ b/e2fsck/Makefile.in
> @@ -28,7 +28,7 @@ STATIC_DEPLIBS= $(DEPSTATIC_LIBQUOTA) $(STATIC_LIBEXT2FS) \
>  
>  PROFILED_LIBS= $(PROFILED_LIBQUOTA) $(PROFILED_LIBEXT2FS) \
>  	       $(PROFILED_LIBCOM_ERR) $(PROFILED_LIBBLKID) $(PROFILED_LIBUUID) \
> -	       $(PROFILED_LIBE2P) $(LIBINTL) \
> +	       $(PROFILED_LIBE2P) $(LIBINTL)
>  PROFILED_DEPLIBS= $(DEPPROFILED_LIBQUOTA) $(PROFILED_LIBEXT2FS) \
>  		  $(DEPPROFILED_LIBCOM_ERR) $(DEPPROFILED_LIBBLKID) \
>  		  $(DEPPROFILED_LIBUUID) $(DEPPROFILED_LIBE2P)
> diff --git a/misc/Makefile.in b/misc/Makefile.in
> index 0692126..575a6d5 100644
> --- a/misc/Makefile.in
> +++ b/misc/Makefile.in
> @@ -72,6 +72,7 @@ PROFILED_FSCK_OBJS=	profiled/fsck.o profiled/base_device.o \
>  			profiled/ismounted.o
>  PROFILED_BLKID_OBJS=	profiled/blkid.o
>  PROFILED_FILEFRAG_OBJS=	profiled/filefrag.o
> +PROFILED_E2FREEFRAG_OBJS= profiled/e2freefrag.o
>  PROFILED_E2UNDO_OBJS=	profiled/e2undo.o
>  PROFILED_E4DEFRAG_OBJS=	profiled/e4defrag.o
>  
> @@ -107,7 +108,7 @@ all:: profiled $(SPROGS) $(UPROGS) $(USPROGS) $(SMANPAGES) $(UMANPAGES) \
>  @PROFILE_CMT@all:: tune2fs.profiled blkid.profiled e2image.profiled \
>  	e2undo.profiled mke2fs.profiled dumpe2fs.profiled fsck.profiled \
>  	logsave.profiled filefrag.profiled uuidgen.profiled uuidd.profiled \
> -	e2image.profiled e4defrag.profiled
> +	e2image.profiled e4defrag.profiled e2freefrag.profiled
>  
>  profiled:
>  @PROFILE_CMT@	$(E) "	MKDIR $@"
> @@ -319,6 +320,11 @@ e2freefrag: $(E2FREEFRAG_OBJS)
>  	$(E) "	LD $@"
>  	$(Q) $(CC) $(ALL_LDFLAGS) -o e2freefrag $(E2FREEFRAG_OBJS) $(LIBS)
>  
> +e2freefrag.profiled: $(PROFILED_E2FREEFRAG_OBJS) $(PROFILED_DEPLIBS)
> +	$(E) "	LD $@"
> +	$(Q) $(CC) $(ALL_LDFLAGS) -g -pg -o e2freefrag.profiled \
> +		$(PROFILED_E2FREEFRAG_OBJS) $(PROFILED_LIBS)
> +
>  filefrag: $(FILEFRAG_OBJS)
>  	$(E) "	LD $@"
>  	$(Q) $(CC) $(ALL_LDFLAGS) -o filefrag $(FILEFRAG_OBJS) 
> 

