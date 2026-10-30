Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793376609;
	b=FbAzIzgE3pAvqokvGaxFOFVPKMHQeYVGukqcs08BPIl+iXNwnJ6FiERgm/GS9x1l885Q
	 THPa3LYLDUEck3tdXFCdIBt2mW7eHKZcqlz5Xwg54XwQfrES8FEftJcCiG6J0KDTogPix
	 O2RfQLv/q8MoFAF8WXkw3srJhcaVoInQ2Nr09PeE4kb647y1PhYNYnMURfu+BV0A7fWck
	 Z1/Q2+shXUEg0C81+1fxqWzSM/EQFITNHBtvFezyUXpPJO5xvlKFIYgUlOSxXu5i5+/sx
	 kJYVTj3le64JJcQ3PZpueDr8EYiHWshnM5uYSCcJCMqtP3TYTvo3tWRUsXYM8g9emjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793376609;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=4f6c50MfKRylF6izNPl1SWtjUxb1UX+AC8qxKNq77dA=;
	b=kh2B1ziqZNas9aJvzoK0AaXWVe5OjgVUXXhSMYflpuNAPSjqLcWXAwt3z2yB3KpcJ7Fx
	 +b0itu+h21hulwJg2uh0RR1PewvPBF0tVnz7UYv5+6vT2REgfabH5nnWsdO2VjHyuEXVA
	 IRigP/OMeyP+WJhmVGkUO+N4ho6KZnv5M1YqwF/12QM72pVMmf07Pq8jTulLQ/UUYAs4O
	 7e9shLGWWYiPKueTh9Ov7MffiCx4BPcIJTrGxpNl5I70WEGzSBonZsSFVJax+JMMCh/LR
	 ih3X4DE9S1gGLLzPymG/0r7qNoAiq8Rz5/+OTVQkW+kg+kMGS+Nlv7MMRoR3OjOBfBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IjvECOsR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A518606A333;
	Fri, 30 Oct 2026 16:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IjvECOsR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 166301F00A15;
	Fri, 30 Oct 2026 16:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793376598;
	bh=4f6c50MfKRylF6izNPl1SWtjUxb1UX+AC8qxKNq77dA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IjvECOsR6+cnwW+krKeqX6TWhRgnEw9YrQrOV40dgHGPIARR3NcGCDrCO8QmiyCTp
	 NU4YH/77lOTvaxi5pAjiJbATh+MA87TeI//mtDuR3M15qQBq6MLFYWpjzkg7cxNo1F
	 RDP4/uHtg6C/SfjJE5m0lya+LI8G6mipsibVliUbT+rLKJrjEn0q7YFtOAlR/+WNBG
	 gugCjVV7pCiYzTEAEgZfKDnxClW6QVjCbSHi4iZF/94oRuVLUfJlL+fWm3B7TWhHQN
	 3zSPIyAuaDdvu2VVfvm2KPlCyUdQxO973uAa2inK4Tl4yKoomQIlqFcssrisdcSKAH
	 aJMmtl3Xtmedg==
Message-ID: <sashiko-outbox-191230@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 11/34] hfs: don't set SB_RDONLY after MDB write
 errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.com>
Cc: "Al Viro" <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, "Viacheslav
 Dubeyko" <slava@dubeyko.com>, dsterba@suse.cz, tytso@mit.edu, "Mark Fasheh" <mark@fasheh.com>, "Joel
 Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-11-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-11-2f44f64f0b66@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 16:09:57 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] hfs: hfs_file_truncate() early return leaves in-memory inode siz=
es inconsistent
--

commit a6e743f06af9edb59d94367cc189bbdb5b8bd883
Author: Christian Brauner <brauner@kernel.org>

hfs: don't set SB_RDONLY after MDB write errors

Instead of setting SB_RDONLY without holding s_umount when an MDB write fai=
ls,
this commit records the error in a new HFS_FLG_EMERGENCY_RO flag and rejects
subsequent filesystem modifications with EROFS.

> diff --git a/fs/hfs/extent.c b/fs/hfs/extent.c
> index 26357086517fc..dacf7ce1ffe4a 100644
> --- a/fs/hfs/extent.c
> +++ b/fs/hfs/extent.c

[ ... ]

> @@ -491,6 +494,8 @@ void hfs_file_truncate(struct inode *inode)
>  	hfs_dbg("ino %llu, phys_size %llu -> i_size %llu\n",
>  		inode->i_ino, (long long)HFS_I(inode)->phys_size,
>  		inode->i_size);
> +	if (unlikely(hfs_emergency_ro(sb)))
> +		return;
>  	if (inode->i_size > HFS_I(inode)->phys_size) {
>  		struct address_space *mapping =3D inode->i_mapping;
>  		void *fsdata =3D NULL;

[Severity: Medium]
Can returning at the top of hfs_file_truncate() in fs/hfs/extent.c leave
in-memory inode size metadata inconsistent when HFS_FLG_EMERGENCY_RO (or
SB_STATE_EMERGENCY_RO in the follow-up commit "hfs: use the generic
emergency read-only state") is set concurrently by the mdb_work worker or
sync_fs()?

First, in the expanding truncate path via hfs_inode_setattr() in
fs/hfs/inode.c (or notify_change() in the follow-up commit):

    if ((attr->ia_valid & ATTR_SIZE) &&
        attr->ia_size !=3D i_size_read(inode)) {
            inode_dio_wait(inode);

            error =3D inode_newsize_ok(inode, attr->ia_size);
            if (error)
                    return error;

            truncate_setsize(inode, attr->ia_size);
            hfs_file_truncate(inode);

If HFS_FLG_EMERGENCY_RO is set after the initial read-only check (for
example, while waiting in inode_dio_wait()), truncate_setsize() updates
inode->i_size and then hfs_file_truncate() returns early before reaching
the expansion block:

    if (inode->i_size > HFS_I(inode)->phys_size) {
            ...
            res =3D hfs_write_begin(NULL, mapping, size + 1, 0, &folio,
                            &fsdata);
            ...
            if (res)
                    inode->i_size =3D HFS_I(inode)->phys_size;
            return;
    }

Without the early return, hfs_write_begin() fails with -EROFS and reverts
inode->i_size back to HFS_I(inode)->phys_size. With the early return,
hfs_inode_setattr() succeeds with inode->i_size larger than
HFS_I(inode)->phys_size and HFS_I(inode)->fs_blocks, causing subsequent
buffered reads via hfs_read_folio() -> block_read_full_folio() ->
hfs_get_block() to see unallocated blocks and return zero-filled pages up
to the new inode->i_size.

Second, when an extending write in hfs_write_begin() or hfs_direct_IO()
allocates some blocks via hfs_get_block() (incrementing
HFS_I(inode)->phys_size, HFS_I(inode)->fs_blocks, and inode->i_bytes) and
then hits -EROFS on a subsequent block after HFS_FLG_EMERGENCY_RO is set,
error cleanup calls hfs_write_failed():

    static void hfs_write_failed(struct address_space *mapping, loff_t to)
    {
            struct inode *inode =3D mapping->host;

            if (to > inode->i_size) {
                    truncate_pagecache(inode, inode->i_size);
                    hfs_file_truncate(inode);
            }
    }

Returning early at the top of hfs_file_truncate() skips the out: label
adjustments as well, leaving HFS_I(inode)->phys_size,
HFS_I(inode)->fs_blocks, and the inode byte count inflated past
inode->i_size.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-work-fs-sb=
_rdonly-v2-0-2f44f64f0b66@kernel.org?part=3D11
