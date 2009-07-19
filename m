From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 5/5] Makefile.in: allow make install e4defrag
Date: Sun, 19 Jul 2009 16:37:44 -0500
Message-ID: <4A639228.9090905@redhat.com>
References: <1248025714-25954-1-git-send-email-bergwolf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Peng Tao <bergwolf@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:36521 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419AbZGSVhn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 19 Jul 2009 17:37:43 -0400
In-Reply-To: <1248025714-25954-1-git-send-email-bergwolf@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Peng Tao wrote:
> Current Makefile does not install e4defrag nor e4defrag.8.
> Change misc/Makefile.in to make the e4defrag available for use.
> 
> Signed-off-by: Peng Tao <bergwolf@gmail.com>

Since this is all still fairly developmental at this point (I think?)
perhaps a special "make install-e4defrag" target might be best.

Otherwise packages which "make install" will start shipping e4defrag,
and I'm not sure we want to do that quite yet.

-Eric

> ---
>  misc/Makefile.in |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/misc/Makefile.in b/misc/Makefile.in
> index 5f5dab5..4cfeb69 100644
> --- a/misc/Makefile.in
> +++ b/misc/Makefile.in
> @@ -28,10 +28,11 @@ SPROGS=		mke2fs badblocks tune2fs dumpe2fs $(BLKID_PROG) logsave \
>  USPROGS=	mklost+found filefrag $(UUIDD_PROG)
>  SMANPAGES=	tune2fs.8 mklost+found.8 mke2fs.8 dumpe2fs.8 badblocks.8 \
>  			e2label.8 $(FINDFS_MAN) $(BLKID_MAN) $(E2IMAGE_MAN) \
> -			logsave.8 filefrag.8 e2undo.8 $(UUIDD_MAN) @FSCK_MAN@
> +			logsave.8 filefrag.8 e2undo.8 $(UUIDD_MAN) @FSCK_MAN@ \
> +			e4defrag.8
>  FMANPAGES=	mke2fs.conf.5
>  
> -UPROGS=		chattr lsattr @UUID_CMT@ uuidgen
> +UPROGS=		chattr lsattr @UUID_CMT@ uuidgen e4defrag
>  UMANPAGES=	chattr.1 lsattr.1 @UUID_CMT@ uuidgen.1
>  
>  LPROGS=		@E2INITRD_PROG@
> @@ -99,7 +100,7 @@ COMPILE_ET=$(top_builddir)/lib/et/compile_et --build-tree
>  @PROFILE_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -g -pg -o profiled/$*.o -c $<
>  
>  all:: profiled $(SPROGS) $(UPROGS) $(USPROGS) $(SMANPAGES) $(UMANPAGES) \
> -	$(FMANPAGES) $(LPROGS) e4defrag
> +	$(FMANPAGES) $(LPROGS)
>  
>  @PROFILE_CMT@all:: tune2fs.profiled blkid.profiled e2image.profiled \
>  	e2undo.profiled mke2fs.profiled dumpe2fs.profiled fsck.profiled \

