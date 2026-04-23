Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95FED21B191
	for <linux-ext4@vger.kernel.org>; Thu, 23 Apr 2026 00:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776906000; cv=pass; b=s/C1CLkfxozrJQ+6aJU/Ql+5KNb+bf6HWa4SpIHYkMBJEVH5KyJOjgkTJZDss3sApbXsmUjPDSbhn6PXC453jCSPL/JE+GjZcQ3PBhMDBd/2OEs5TC7pmPDuJA6AhxCYaDJ92CvOsCxTWjWYHuhOsXUa14d5F5rSlleqnhubun4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776906000; c=relaxed/simple;
	bh=glEATcMQjgXcIVNGcFv/jGZwSA4FOZck5uTqZXkwZrk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kWfpuHiVVVN1g3FeXNCYKpIvEYNn9GutN8KL2qQGlS659hHP0+jnr3+4t5h3Q74QUJ2CcBJ2yi7aAiqLBKmwIvC0v+aMYHZ5AkAgfFzPvoI0+rg87cFecx/6Pm5vGhKWPtvC9fx9ZbmPjf9s1f6cLxCS06N+wB6fz4W1q5EwTuk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YMRiJS2/; arc=pass smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YMRiJS2/"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-8ee7ffd738dso243490585a.1
        for <linux-ext4@vger.kernel.org>; Wed, 22 Apr 2026 17:59:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776905997; cv=none;
        d=google.com; s=arc-20240605;
        b=H/o5M5RkQa5D+4aqsHZr0sW75PVSNnA2gC0bJxtdbj4qVDo/QeZN8FvDu3NoKaDgDr
         QtSKnKuScBi5qt5dVC3YzI1+Dkjc26K10Nb2uPMlgCqiH6iB8mx0V7ElYat3iX+pVl3X
         lJ1t+WbeXQtqZJHXDfdItuAztKgjG6V2JRIrecXCys21cB3Cdbz2WsFI+nkAUCBqXSmi
         9XCWxr6X8xf6Mod7OSAjtHgUAJ47Ky1Y18uplEftMBcdM3qL7LdSmroMYARk1qkinMEY
         /mktAkr2X2LdscRjJoUnJHoVM4pJs0lK70li9fShDU/4Z8/hwUhYUdF05zaKESAypugt
         FC6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=t/Auuo3ewU9oR2gX8cwKFh7CPK/qOcoVmyN6PErL6wA=;
        fh=uyzB+pD3w9R2ChWtmQVD1Pisz9mWxK65wPiwdGXYuGI=;
        b=bedASs0Lh4Utl8sHSUUkuf73/yqPc6PbCLum1qmBZT6PvcXf6OqcFzen0l/+nvf39R
         L/MHGja/U0uzyEfIKapKScORTnW4I7mZuHfLnn3etzAsXaIzReTWJGTLQERt8tvhze/v
         i5Jhtf1iqcMlPqJ6L8sdIjQitnT1TFYRfZRC9PL/m2NnI/6O1IYHHXCN3EjMo9ZStXTp
         IhIJ4YVpvJSeVDqpquMrS9PiNciTDDlyoYvjPv3GRKzQaGccb0CXEXtKCYROCeX9BMoP
         bJ2Bz9ypOMtodBMIEvt45N3YigroqE0tjSG9Q1kG/cFYRld2gfA1PJqKdEXKOXTlYoy0
         3bCQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776905997; x=1777510797; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t/Auuo3ewU9oR2gX8cwKFh7CPK/qOcoVmyN6PErL6wA=;
        b=YMRiJS2/7iPeV6CGivmFNZlhKtWjZPgsedWvhWP74UAv3lHrFmEFD0Aur6BIskzh0g
         QWBYcqG55fzdQVfvpnQ9RV5vQsjz0rWZL56X2ebc3clKJU48exG+EENE6kbVBxOFpPk+
         5t2gNgAxnqyaIvLY5ck4yRXX+nydQgvVrTEgBY8JAQXSqA8G3K6ongzaSlOAcv5LE5uM
         Yo7Lct+7ITiCGlvIXN81wLh8Pdlp3XWrN5vkapIFlpVoCanONo4VVCoHnyFslJtMBaWb
         mcFu62lehj3ZRz/Tw8nwq2iDe7aP0WaWjUg+TjiMd5pr/GNJgLYryCDxWm3FILghrLh2
         OYZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776905997; x=1777510797;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=t/Auuo3ewU9oR2gX8cwKFh7CPK/qOcoVmyN6PErL6wA=;
        b=F3qwa1jpCIQb28ae8VdCBZbDZqUGoXhNJZprbLsIW25OKV7lLyPX46ZnSCVTrPw4ij
         gcdajv+Vq/xpffEWGRw6qek5nB+wvcZ32vctDKBDHSgNY5DfkAdpGc7ftI7vLcO7tNIN
         0zdylykVgFWKGf7a+Z2LPDP0h9q5r/JPDOiBnT8jyQiwrsVk6kQHJ1ZV5g2OgkAyJpgG
         gGxiUr8DFKd5uuINpHNkB311wl88c1zmsHewUHrwVeST7FneGkj2itlGZRxNlRYZ5jrb
         h7ldbQZA8gh1AMIxIvCDIly8hc7ryE+EZSum5FKQrZ8fqueiMSC+lKZN+1KOx9qqeibO
         rWPw==
X-Forwarded-Encrypted: i=1; AFNElJ8n4uSS+04onhsHc4fgdJly9LklbH8R5q9OpF/pbpJC94PmtM/rDRacyaV70Wqb60K+bcofLCxAI0eY@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4jIfCoCsuq0SO1Eaj0IoVFUByiragJ/ZG5xe+n6zJJsz5zLid
	OSPM2L/Er5HWALg6oaGRAn7O5vS46Y53mDDNfU70ChXY6aXQKyfgvoFGZvcc2o7b9nkGD2xs4Se
	JMkReSdwvmb0uFq7QLMnDBIXyQuW8POo=
X-Gm-Gg: AeBDietLGU9dglVNuJh752EPb9gsvMQSVNyjEkRVVbKzf4ba2p2ccRgQ0xPQXQgFXTU
	+8hlFoI3aDWBSUTpWeAVqb+jeantoKYsHbL6p7/7wQsxE0TOrxEuteCh/d5l3debd493JX97dWr
	LYeHOG9kfu8v560aJJRMW49pBRdX2jCQABVV0Xwrhh4QOsIRCfKIbTVmPxkW2eP9L4NG/pdNrKp
	UQ2FE8Hn1wsiotNoqYJfWoypPnWQFI5pDSIj17DKYQlCuneeW4XoX+x1Uj++PvQvciwml5FCdwd
	diDY7BSrrvQceQpeglMzxFhjKB1ZKm5hs82qOMmJCKPm0vAMpTZFvAmRlSSIUZh4hxZO/9cxJhP
	curfkUdR31j1BirSkbh/D07nS1QGEXIjkVGE6kFqrQ4y/9lEXSjG/9zaIxNvRU/SyU5xWztzRft
	JQdZg6cLy1ZxG7mKV1GuaqdkTLFHwbB3Cy1VD5xeBot+g=
X-Received: by 2002:a05:6214:490a:b0:8ac:b3ba:eb0c with SMTP id
 6a1803df08f44-8b0282f35c0mr336785626d6.2.1776905997499; Wed, 22 Apr 2026
 17:59:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260422-case-sensitivity-v9-0-be023cc070e2@oracle.com> <20260422-case-sensitivity-v9-10-be023cc070e2@oracle.com>
In-Reply-To: <20260422-case-sensitivity-v9-10-be023cc070e2@oracle.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 22 Apr 2026 19:59:43 -0500
X-Gm-Features: AQROBzCtyORnfuVHnIm1n6WO0qai8y2HQyRw138-ozkefgToPmyDNAGdDckhKog
Message-ID: <CAH2r5muvUVY8FD6ZM+ARecM8evjejB15n0Ea9Z=GGn=i5aKFNA@mail.gmail.com>
Subject: Re: [PATCH v9 10/17] cifs: Implement fileattr_get for case sensitivity
To: Chuck Lever <cel@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
	linux-nfs@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, hirofumi@mail.parknet.co.jp, 
	linkinjeon@kernel.org, sj1557.seo@samsung.com, yuezhang.mo@sony.com, 
	almaz.alexandrovich@paragon-software.com, slava@dubeyko.com, 
	glaubitz@physik.fu-berlin.de, frank.li@vivo.com, tytso@mit.edu, 
	adilger.kernel@dilger.ca, cem@kernel.org, sfrench@samba.org, pc@manguebit.org, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, trondmy@kernel.org, 
	anna@kernel.org, jaegeuk@kernel.org, chao@kernel.org, hansg@kernel.org, 
	senozhatsky@chromium.org, Chuck Lever <chuck.lever@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Acked-by: Steve French <stfrench@microsoft.com>

Do you know which xfstests this would enable?  IIRC a few of them
depend on the fs supporting fileattr_get

On Wed, Apr 22, 2026 at 6:34=E2=80=AFPM Chuck Lever <cel@kernel.org> wrote:
>
> From: Chuck Lever <chuck.lever@oracle.com>
>
> Upper layers such as NFSD need a way to query whether a filesystem
> handles filenames in a case-sensitive manner. Report CIFS/SMB case
> handling behavior via the FS_XFLAG_CASEFOLD flag.
>
> CIFS servers (typically Windows or Samba) are usually case-insensitive
> but case-preserving, meaning they ignore case during lookups but store
> filenames exactly as provided.
>
> The implementation reports case sensitivity based on the nocase mount
> option, which reflects whether the client expects the server to perform
> case-insensitive comparisons. When nocase is set, the mount is reported
> as case-insensitive.
>
> The callback is registered in all three inode_operations structures
> (directory, file, and symlink) to ensure consistent reporting across
> all inode types.
>
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> ---
>  fs/smb/client/cifsfs.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>
> diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
> index 2025739f070a..9b70ffa3e01d 100644
> --- a/fs/smb/client/cifsfs.c
> +++ b/fs/smb/client/cifsfs.c
> @@ -30,6 +30,7 @@
>  #include <linux/xattr.h>
>  #include <linux/mm.h>
>  #include <linux/key-type.h>
> +#include <linux/fileattr.h>
>  #include <uapi/linux/magic.h>
>  #include <net/ipv6.h>
>  #include "cifsfs.h"
> @@ -1199,6 +1200,22 @@ struct file_system_type smb3_fs_type =3D {
>  MODULE_ALIAS_FS("smb3");
>  MODULE_ALIAS("smb3");
>
> +static int cifs_fileattr_get(struct dentry *dentry, struct file_kattr *f=
a)
> +{
> +       struct cifs_sb_info *cifs_sb =3D CIFS_SB(dentry->d_sb);
> +       struct cifs_tcon *tcon =3D cifs_sb_master_tcon(cifs_sb);
> +
> +       /*
> +        * The nocase mount option installs case-insensitive dentry
> +        * operations on this superblock. SMB preserves case on the
> +        * wire and at rest, so the mount matches FS_XFLAG_CASEFOLD
> +        * semantics: case-folded lookup, verbatim storage.
> +        */
> +       if (tcon->nocase)
> +               fa->fsx_xflags |=3D FS_XFLAG_CASEFOLD;
> +       return 0;
> +}
> +
>  const struct inode_operations cifs_dir_inode_ops =3D {
>         .create =3D cifs_create,
>         .atomic_open =3D cifs_atomic_open,
> @@ -1217,6 +1234,7 @@ const struct inode_operations cifs_dir_inode_ops =
=3D {
>         .listxattr =3D cifs_listxattr,
>         .get_acl =3D cifs_get_acl,
>         .set_acl =3D cifs_set_acl,
> +       .fileattr_get =3D cifs_fileattr_get,
>  };
>
>  const struct inode_operations cifs_file_inode_ops =3D {
> @@ -1227,6 +1245,7 @@ const struct inode_operations cifs_file_inode_ops =
=3D {
>         .fiemap =3D cifs_fiemap,
>         .get_acl =3D cifs_get_acl,
>         .set_acl =3D cifs_set_acl,
> +       .fileattr_get =3D cifs_fileattr_get,
>  };
>
>  const char *cifs_get_link(struct dentry *dentry, struct inode *inode,
> @@ -1261,6 +1280,7 @@ const struct inode_operations cifs_symlink_inode_op=
s =3D {
>         .setattr =3D cifs_setattr,
>         .permission =3D cifs_permission,
>         .listxattr =3D cifs_listxattr,
> +       .fileattr_get =3D cifs_fileattr_get,
>  };
>
>  /*
>
> --
> 2.53.0
>
>


--=20
Thanks,

Steve
