From: Peng Tao <bergwolf@gmail.com>
Subject: Re: [PATCH 5/5] Makefile.in: allow make install e4defrag
Date: Mon, 20 Jul 2009 02:02:14 +0800
Message-ID: <6149e97b0907191102j4c555715gc15fbbb51458814d@mail.gmail.com>
References: <1248025714-25954-1-git-send-email-bergwolf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-px0-f193.google.com ([209.85.216.193]:63516 "EHLO
	mail-px0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597AbZGSSCP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 19 Jul 2009 14:02:15 -0400
Received: by pxi31 with SMTP id 31so57805pxi.33
        for <linux-ext4@vger.kernel.org>; Sun, 19 Jul 2009 11:02:14 -0700 (PDT)
In-Reply-To: <1248025714-25954-1-git-send-email-bergwolf@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Sorry, please ignore the patch series number. It was miss-typed.

On Mon, Jul 20, 2009 at 1:48 AM, Peng Tao<bergwolf@gmail.com> wrote:
> Current Makefile does not install e4defrag nor e4defrag.8.
> Change misc/Makefile.in to make the e4defrag available for use.
>
> Signed-off-by: Peng Tao <bergwolf@gmail.com>
> ---
> =C2=A0misc/Makefile.in | =C2=A0 =C2=A07 ++++---
> =C2=A01 files changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/misc/Makefile.in b/misc/Makefile.in
> index 5f5dab5..4cfeb69 100644
> --- a/misc/Makefile.in
> +++ b/misc/Makefile.in
> @@ -28,10 +28,11 @@ SPROGS=3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 mke2fs badblocks tune2fs dumpe2fs $(BLKID_PROG) logsave \
> =C2=A0USPROGS=3D =C2=A0 =C2=A0 =C2=A0 mklost+found filefrag $(UUIDD_P=
ROG)
> =C2=A0SMANPAGES=3D =C2=A0 =C2=A0 tune2fs.8 mklost+found.8 mke2fs.8 du=
mpe2fs.8 badblocks.8 \
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0e2label.8 $(FINDFS_MAN) $(BLKID_MAN) $(E2IMAGE_MAN) \
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 logsave.8 filefrag.8 e2undo.8 $(UUIDD_MAN) @FSCK_MAN@
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 logsave.8 filefrag.8 e2undo.8 $(UUIDD_MAN) @FSCK_MAN@ \
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 e4defrag.8
> =C2=A0FMANPAGES=3D =C2=A0 =C2=A0 mke2fs.conf.5
>
> -UPROGS=3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cha=
ttr lsattr @UUID_CMT@ uuidgen
> +UPROGS=3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cha=
ttr lsattr @UUID_CMT@ uuidgen e4defrag
> =C2=A0UMANPAGES=3D =C2=A0 =C2=A0 chattr.1 lsattr.1 @UUID_CMT@ uuidgen=
=2E1
>
> =C2=A0LPROGS=3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
@E2INITRD_PROG@
> @@ -99,7 +100,7 @@ COMPILE_ET=3D$(top_builddir)/lib/et/compile_et --b=
uild-tree
> =C2=A0@PROFILE_CMT@ =C2=A0$(Q) $(CC) $(ALL_CFLAGS) -g -pg -o profiled=
/$*.o -c $<
>
> =C2=A0all:: profiled $(SPROGS) $(UPROGS) $(USPROGS) $(SMANPAGES) $(UM=
ANPAGES) \
> - =C2=A0 =C2=A0 =C2=A0 $(FMANPAGES) $(LPROGS) e4defrag
> + =C2=A0 =C2=A0 =C2=A0 $(FMANPAGES) $(LPROGS)
>
> =C2=A0@PROFILE_CMT@all:: tune2fs.profiled blkid.profiled e2image.prof=
iled \
> =C2=A0 =C2=A0 =C2=A0 =C2=A0e2undo.profiled mke2fs.profiled dumpe2fs.p=
rofiled fsck.profiled \
> --
> 1.6.2.GIT
>
>



--=20
Cheers,
Peng Tao
State Key Laboratory of Networking and Switching Technology
Beijing Univ. of Posts and Telecoms.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
