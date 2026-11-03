Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793727151;
	b=ncsmZE3Y+I0V7AJu1mr3VORSugABkxsMwjm13oMxF/CyMRNMgdH9wYtEliYJSWBoeWx2
	 SIbualSbSztA4PeQb0dnVi2+mNCxPomb0DRgelldF93UkZw+th5m0BA9D5bT7q9ND20pj
	 djIjAGwN9+b0IbEmUHD8QhjkN8uXaubUJS5VRV0NLKFvntuDPNv+s6UiUreelDQJw/jJg
	 aKrsRo+/Q53PWP5KG7sAhHjUhnj0R9vBjd1m93TOdYhNmR+PefGGNAI9YntomAh7x/uBy
	 HjW8DzP/CI/wcHVRH5SQ73krmOg/zUTTzyfY8hGH/6TOLcescp1Hb9PlaoE8kelBz2A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793727151;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=BjAvXl9t7a/JdDo3zmQDUheOgn/OssmLnxGDAWna7Kc=;
	b=xCy2fL4dAn+qdo8V40kcxeEbxEwO9PFLa7pk0KARm87vR8ORzhHubWrf0hP28LBSK1ZP
	 Fdsg2HJi1BiLRbwYFHNZyETeBgnzNvEfsrXQWirmQUyoMNssgQK8Z0FG5bmB+O8CWkDa5
	 Pqs0ESLzOPBsW7R+d5JJneOpxVjv4snSB+07ETt7MsLRuxLlpnkZGNUahGm/NPgMQRmkw
	 ETWtjTzGYQxDWkNhlDIBGKZEURjeTy/zRUhShz5zU1tknahJdO78k1rrkxbCgSKePQqqb
	 T8WQ2IzPn0+ss/SPyNJzZ9Y9aww9L0fIJQw0tcpmdQSYMtwt4cDRQOrLY/iT0/EWaGA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="hKQHkK/a";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.44
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC14B606A329
	for <linux-ext4@vger.kernel.org>; Tue,  3 Nov 2026 17:32:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AC14B606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hKQHkK/a
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-48afcfc4bf5so4572424f8f.1
        for <linux-ext4@vger.kernel.org>; Tue, 03 Nov 2026 09:32:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793727149; cv=none;
        d=google.com; s=arc-20260327;
        b=A9TJIGvMyaMfgySkyYwSJvMr4328qoFWMAIMI7Tx/qqVLVW8e0pfhSiwHoTH123Yfq
         w6nu0xUQ1z0Ru+4oRUbg3l+0bw19bh4XSjeGjiUYqeRsYru7nSxjCA3R4Ge0miQAN3m8
         0tgD9yqLhb69IZWgdGH75y2CZ/7Qb/XCZqTeeHKfghKfqeBYjKI6uzvtQKIZ2nZAkAU4
         oV0Rcwn/QyALja1LJ332vyynGdUtvy0WxcReXLKiMKojck2Vbjagjs9pTTJLeag4/hcr
         rjypCa/GU+C/bNbx2K8U4b6wwG3N8xI8rMKz4qdVieB3dXIScodkFRmXZjW4lH9IoGWo
         4q0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BjAvXl9t7a/JdDo3zmQDUheOgn/OssmLnxGDAWna7Kc=;
        fh=46zu/Mq32xu6YnZ13sALnvhHWh+DZvDp9+LRQLL9T4Q=;
        b=E/CB4fa6vSDW3IlPUuIMS9S6MD+8eUTU/M5hKGbpjic6hkMFsBjmJeSy30CNJDSVBB
         HHWrnP7QNLNyVT8s58f9jLcYNye6LTeZk76vWVLMAZFOSdEdvxvaP5MHA7kOL0BfLS2Z
         QaZPGNdSy7seipB7M0Qmp7bhzYr+LQ3jIiPSvZmOv2EYlS9zZw1VTIrW6Ykj6Th1JnJp
         hdcpllLWIZy0rwf/QOOZU2ipYiI0yefZwiMsLhlcz3Wb/ldn8wjWf8GRLFVw11+UgwPx
         3UATr6yvOcNsv7uOoT0ywXn5yq/Ix9NRxp7798y4o+thDP+9NdYyt3PkSkHqJ/Fa1x2i
         Ij2A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793727149; x=1794331949; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BjAvXl9t7a/JdDo3zmQDUheOgn/OssmLnxGDAWna7Kc=;
        b=hKQHkK/aoEuT9mfHLGFgdChCQuSyK31iKsry7MYGOCBAGV//APQ23DK1II4ZzigI+I
         e0se9nuvTOeTfJbLie9C4SQZLCnqIQQ++XD82UPCD9pCtru1DVpFtGBFVjbN8lWb7hah
         4mRBoChLPwXtpg++ONVrMZ+s0d+S2vFMMslyDruQze013sYkV+E1/EGN1Jf2y2W4eEbZ
         rCTEwXm/QqBKpV8/XWcfcbenZtLK7ceavP4UkaqMRy/popTG/Pk8mccl1XJYtuJk8scq
         /bqFfIZZeRm6pCc/BiHNYPmwtTjLXFRyrXA4caqkSmPFXWL6vMwvy+xC2P/dqqRCVpXJ
         yQ9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793727149; x=1794331949;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BjAvXl9t7a/JdDo3zmQDUheOgn/OssmLnxGDAWna7Kc=;
        b=s2/Q9e8A+DSgm1QJ6nKJ+0Lx05sBxTKwq7kGXDvKBFr/pd+KhQohIFQZJgyhf5+bQn
         UW4dOebS/d7IrC5FUys6SKEJWD5kc8BPFjrJwUmYRKT2foptZW0KCu5Y6hyqgmWr07R6
         OzjNDPLAz8YVRIhihQ+0NDc+o8Jnps2rXXgnGzUTn31AoV73IaRy5v1KOuM+OZo3cM/w
         M88SQFqCqHAtRqsX4vX4oW+epwq7vDY+xYtErOWq6znJXJnVMW8hP8Y/NOGApt/LCwvn
         yDEN5lGlb+ZmDPJMZXpmR+WrK82xGwJEJ8wkGaakCRJsWS/V4rKZpxVYOlOGozuacIQV
         fR2g==
X-Forwarded-Encrypted: i=1; AKwUvBz1aP65o8KojBPfH3WRaZX2CDtFUlPZfPLmdXv7qwTSFIk6SjBfY2kLp30MPNw1xk9GyRXSLcYSZSgG@vger.kernel.org
X-Gm-Message-State: APuU4Z9jWg0VAIQF6qlglcQ18BgsAccC5DjLojR7EkZeOj0dMzXBBlQc
	fGLTs2xiJOwo3Qsj0L8CEt390VMdKIRgK3niYAGsno26+rrbfwUjmlV5ln9MTNBcGn6L3t9T8JG
	ajgVU1C78lzCJQF4hxD8HETSh2QAREYM=
X-Gm-Gg: AYBFou0VDWbmVRuXtcYR58S9m6JsV5WvVCEH351RWkEK2zb+wHNmnVOSYU9H26LkaAH
	2vIZlILhlUGgc2zH2ShLWSJNv9SPagQOQXFpGEEpKtwtlBB9Wq5/JjOwVYJsrkOmUTC2fr+4dwR
	h93UVEPQLAK/wkLx0T1fMFcJcA87rGOmr48aChxkjwcZktHhd0P4BSVfvHRBaXHMiNR3s7d+M+7
	3ccNRfm1nAh9IBtNsSzQeQgH9I63AaKpejbfQsgRVC7byBjeZkT2nHU02BLZEPuomxm62wGKIU+
	0Bygiop0HfuH2ViDH8cZNJvuqZre+L/BTV/L00wVD0Vnu4FGLd6P1sQFzGyzafHqf4R+KWDGaIb
	d66JnAyR4gmk+oBMzL268ud3vHvSn2Tih9HYO
X-Received: by 2002:a05:6000:2c03:b0:48c:6cdd:ba89 with SMTP id
 ffacd0b85a97d-48e6e4ff80emr28595835f8f.36.1793727148868; Tue, 03 Nov 2026
 09:32:28 -0800 (PST)
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-6-2f44f64f0b66@kernel.org> <sashiko-outbox-191225@kernel.org>
In-Reply-To: <sashiko-outbox-191225@kernel.org>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Wed, 4 Nov 2026 02:32:10 +0900
X-Gm-Features: AclHuK_xchRwxsZ5xCgnuvGf3QgoTbZDme23pAKWici3-nvdFpdRQtDLUtkXtDM
Message-ID: <CAKFNMombDWkJ=m+CjMy7qnd_yy-vZ9c-EE7R95HKKkcy-M0+SQ@mail.gmail.com>
Subject: Re: [PATCH v2 06/34] nilfs2: don't set SB_RDONLY after filesystem errors
To: sashiko-reviews@lists.linux.dev, Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, 
	linux-mm@kvack.org, linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, 
	Karl Mehltretter <kmehltretter@gmail.com>, dsterba@suse.cz, tytso@mit.edu, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 31, 2026 at 1:09=E2=80=AFAM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
> - [Medium] nilfs2: nilfs_reconfigure() and nilfs_get_tree() bypass sb_eme=
rgency_ro()
> --
>
> commit ff163f1297bca8964f03776869c3a8bc9e3c38ba
> Author: Christian Brauner <brauner@kernel.org>
>
> nilfs2: don't set SB_RDONLY after filesystem errors
>
> This commit replaces setting SB_RDONLY in __nilfs_error() with
> sb_set_emergency_ro() and introduces nilfs_sb_rdonly() to guard write pat=
hs
> after filesystem errors without taking s_umount.
>
> Link: https://lore.kernel.org/r/20260903060855.4610-1-kmehltretter@gmail.=
com
>
> > diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
> > index 2e3b591c117c9..edb7d379ecbdf 100644
> > --- a/fs/nilfs2/super.c
> > +++ b/fs/nilfs2/super.c
> > @@ -137,12 +137,13 @@ void __nilfs_error(struct super_block *sb, const =
char *function,
> >
> >       va_end(args);
> >
> > -     if (!sb_rdonly(sb)) {
> > +     if (!nilfs_sb_rdonly(sb)) {
> >               nilfs_set_error(sb);
> >
> >               if (nilfs_test_opt(nilfs, ERRORS_RO)) {
> >                       printk(KERN_CRIT "Remounting filesystem read-only=
\n");
> > -                     sb->s_flags |=3D SB_RDONLY;
> > +                     /* SB_RDONLY needs s_umount, see sb_set_emergency=
_ro(). */
> > +                     sb_set_emergency_ro(sb);
> >               }
> >       }
>
> [ ... ]
>
> > @@ -1141,6 +1146,10 @@ static int nilfs_reconfigure(struct fs_context *=
fc)
> >       if (fc->sb_flags & SB_RDONLY) {
> >               sb->s_flags |=3D SB_RDONLY;
> >
> > +             /* After an error nothing may be written, just go read-on=
ly. */
> > +             if (sb_emergency_ro(sb))
> > +                     goto out;
> > +
> >               /*
> >                * Remounting a valid RW partition RDONLY, so set
> >                * the RDONLY flag and then mark the partition as valid a=
gain.
> > @@ -1152,6 +1161,12 @@ static int nilfs_reconfigure(struct fs_context *=
fc)
> >               __u64 features;
> >               struct nilfs_root *root;
> >
> > +             /* The VFS doesn't refuse this when nilfs_get_tree() call=
s us. */
> > +             if (sb_emergency_ro(sb)) {
> > +                     err =3D -EROFS;
> > +                     goto ignore_opts;
> > +             }
> > +
>
> [Severity: Medium]
> Can this sb_emergency_ro(sb) check in the else branch of nilfs_reconfigur=
e()
> be bypassed after an error on a read-write mount?
>
> When __nilfs_error() calls sb_set_emergency_ro(sb) on a read-write mount,
> SB_RDONLY is not set in sb->s_flags, so sb_rdonly(sb) remains false.
>
> In nilfs_reconfigure(), right before the if (fc->sb_flags & SB_RDONLY) bl=
ock:
>
>         if ((bool)(fc->sb_flags & SB_RDONLY) =3D=3D sb_rdonly(sb))
>                 goto out;
>
> When a read-write mount or remount is requested (!(fc->sb_flags & SB_RDON=
LY))
> on a superblock where sb_emergency_ro(sb) is true and sb_rdonly(sb) is st=
ill
> false (for example, via nilfs_get_tree() -> nilfs_reconfigure() when the
> superblock was kept alive by a snapshot after the corrupted read-write mo=
unt
> was unmounted, or via reconfigure_super() -> nilfs_reconfigure() on a dir=
ect
> remount,rw without an intermediate remount,ro), this comparison evaluates
> false =3D=3D false and jumps straight to out, overwriting nilfs->ns_mount=
_opt and
> returning 0 instead of -EROFS.

I have reviewed the related code paths across all patterns regarding
Sashiko's concerns.  Regarding this first point, there is no need for
concern.

Skip check in nilfs_reconfigure():
   if ((bool)(fc->sb_flags & SB_RDONLY) =3D=3D sb_rdonly(sb))
           goto out;

Skipping this block when the requested state matches the current state
is valid because no RO/RW transition is being requested.  In particular,
with the workaround patch ("super: keep the read-only state if a
reconfiguration doesn't change it") queued in the vfs-7.5.super branch,
reconfigure_super() ensures that fc->sb_flags inherits SB_RDONLY bit
from sb->s_flags even when "rw" or "ro" option is not specified.

When called via nilfs_get_tree() -> nilfs_reconfigure():

  - If only a read-only snapshot mount exists and a read-only current
    mount is added, skipping via this check is correct.
  - If a read-write current mount is requested instead, this skip check
    is bypassed (since sb_rdonly(s) is true for snapshot mounts while
    fc->sb_flags does not have SB_RDONLY), and the downstream
    sb_emergency_ro() check safely rejects it with -EROFS if the
    superblock has entered the emergency RO state.

> Also, in nilfs_get_tree(), when nilfs_tree_is_busy(s->s_root) is true:
>
>         } else if (!ctx->cno) {
>                 if (nilfs_tree_is_busy(s->s_root)) {
>                         if ((fc->sb_flags ^ s->s_flags) & SB_RDONLY) {
>                                 nilfs_err(s,
>                                           "the device already has a %s mo=
unt.",
>                                           sb_rdonly(s) ? "read-only" : "r=
ead/write");
>                                 err =3D -EBUSY;
>                                 goto failed_super;
>                         }
>
> Because s->s_flags does not have SB_RDONLY set after sb_set_emergency_ro(=
s),
> doesn't this treat the emergency read-only superblock as read/write, reje=
cting
> a secondary read-only mount with -EBUSY while allowing a secondary read-w=
rite
> mount?

Sashiko's point here has a valid aspect.

This inconsistency can be resolved by inserting the following handling
logic if sb_emergency_ro(s) is true:

       } else if (!ctx->cno) {
                if (nilfs_tree_is_busy(s->s_root)) {
                        if (sb_emergency_ro(s)) {
                                if (!(fc->sb_flags & SB_RDONLY)) {
                                        err =3D -EROFS;
                                        goto failed_super;
                                } else {
                                        s->s_flags |=3D SB_RDONLY;
                                }
                        } else if ((fc->sb_flags ^ s->s_flags) & SB_RDONLY)=
 {
                                nilfs_err(s,
                                          "the device already has a %s moun=
t.",
                                          sb_rdonly(s) ? "read-only" :
"read/write");
                                err =3D -EBUSY;
                                goto failed_super;
                        }
                } else {
                     =E2=80=A6
                }
     }

This makes all transitions behave consistently under emergency RO:

* RW (degraded) --- RW mount request --> Rejected with -EROFS
                 |
                 `- RO mount request --> RO (degraded)

* RO (degraded) --- RW mount request --> Rejected with -EROFS
                 |
                 `- RO mount request --> RO (degraded)

* Snapshot-only RO --- RW mount request --> Rejected with -EROFS
  (degraded)        |                  [Blocked by emergency_ro check
                    |                   in nilfs_reconfigure()]
                    `- RO mount request --> RO (degraded)
                                       [Reused via nilfs_reconfigure()]

The current v2 patch is safe as-is since write paths are fully
protected by nilfs_sb_rdonly()
even if a degraded RW-mount is reused, but including this change
handles secondary
mounts under emergency RO much more cleanly.

Thanks,
Ryusuke Konishi

> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-work-fs-=
sb_rdonly-v2-0-2f44f64f0b66@kernel.org?part=3D6
