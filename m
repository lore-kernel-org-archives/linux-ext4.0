Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794657813;
	b=Jhf2eaKbC9PTq0dbCeI69976WBZ1mpMfgTSoF3yZ97LxHe9zLlxPyXnNRTo6fWPC2GbS
	 JutJJ5pmS+/KGVHisvmCbNyPpDkrDA4/AQGWCECGV3+L/l2E7+syfWRTJ/8oCc5CZ4Ojo
	 I0wOQLK+QILTEPadNcR4tkrHB6SibK3hc1qRuQJKIWfWgCz3wSK3BwUvXDWIp2E+Me0NN
	 KfrHp2gRr1++sUC2XX2A32Mzqq6fyLyD60BoR2QPWMc2XUVBQ2Wcjw93UgwbI3xWFgNnc
	 WatSwWkFPNIhdbLd5oPVtq3r+YFKnwedNl1Ls32YNnBEOCZ8OKSSckyGCvw0WblY0Rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794657813;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Wv8I5sT0IlSg6c2AVaztBfZxjeSqbtwOh/i1U+WLAMs=;
	b=oPhttN64F3o0flvYjwOjSyg0j3i6R2sU1JJfZo7ssN5nkCCIDaz40hRdSdk4zaR0UPQi
	 DnWDmgwxEgzJQxCyLeRnQOHXSp7bRX3POkvq/6K3wN4RiwLfvZ8FsnwIsIPQI+qi418kX
	 NmdI8zqzFTLJNiu5isv/TqK5O+trf/SxNOtf5y/yNo5qnmJfaihsDzJI/aSVsYhnUktfw
	 9KFPBISA0JI/M1XvUIZFinbXFiUEbNCUyJnA0zQdRl7TWrWW1uZGN23NeqTF9Ig4csntH
	 Ry1lehcd+iGeVmxg8pR5QBvM6QEYAgJcMUzGFU5L8mja2PZcCHQBfhz3Db6M5rJAmwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=facCz0qq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57038606A339;
	Sat, 14 Nov 2026 12:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=facCz0qq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92A9B1F000C5;
	Sat, 14 Nov 2026 12:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794657813;
	bh=Wv8I5sT0IlSg6c2AVaztBfZxjeSqbtwOh/i1U+WLAMs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=facCz0qqs9QrwkdnVkScfrWc4RWGu0fgu+gPH1rhfIGd2cxJQ2KSJ/ctGaPNos2xi
	 yWhxu7QJ0i6YpbkN1Wc7D2N4KWL4torud90tRKqnT6ebGmQdOGnRAv7l3HnBZhDBeD
	 dTbRGlUT6jWcK5MpPZwGqYZCs6bj2fMnoEOWDQ+NoPZXgiTSdKMWs2m4EXF8YJ6NhV
	 r/j2o+eDJOR6wn2tJuY5RiKieaDzELDUnGuzt4memBBwaPzmLhfkDG/rL/Smd3sOZ3
	 mZ+VG+Xng4Jy/xzTFLsbuNEpb29N0PWcpdH+7/NnfZ0DANXp4W53CWW62b9PrVL4Ef
	 KXJ02F5rI1Fnw==
Message-ID: <sashiko-outbox-214464@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 13/33] hfs: don't set SB_RDONLY after MDB write
 errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.com>
Cc: "Al Viro" <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, "Viacheslav
 Dubeyko" <slava@dubeyko.com>, dsterba@suse.cz, tytso@mit.edu, "Mark Fasheh" <mark@fasheh.com>, "Joel
 Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-13-0be92bb73709@kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
 <20261113-work-fs-sb_rdonly-v3-13-0be92bb73709@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 12:03:32 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] hfs: early return in hfs_file_truncate() corrupts inode and
  catalog sizes
--

commit bfa80e19c6c9ea6b12943abb2839781be7835d98
Author: Christian Brauner <brauner@kernel.org>

hfs: don't set SB_RDONLY after MDB write errors

Instead of setting SB_RDONLY without holding s_umount when an MDB write
fails, this commit introduces HFS_FLG_EMERGENCY_RO and rejects filesystem
modifications with -EROFS once the flag is set.

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
Can returning at the top of hfs_file_truncate() leave inode->i_size out
of sync with HFS_I(inode)->phys_size and HFS_I(inode)->alloc_blocks?

CPU0                                  CPU1
hfs_inode_setattr()
  hfs_emergency_ro(sb) -> false
  inode_dio_wait(inode)
                                      hfs_mdb_commit()
                                        set_bit(HFS_FLG_EMERGENCY_RO, ...)
  truncate_setsize(inode, ia_size)
  hfs_file_truncate(inode)
    if (hfs_emergency_ro(sb))
      return;  <-- skips i_size rollback
  mark_inode_dirty(inode)

When an expanding truncate hits -EROFS in hfs_write_begin(), the
inode->i_size > HFS_I(inode)->phys_size branch normally resets
inode->i_size =3D HFS_I(inode)->phys_size.  Returning before that branch
leaves inode->i_size expanded without allocated blocks, and because
hfs_write_inode() still runs after an MDB error, writeback persists
LgLen > PyLen into the catalog B-tree record via hfs_inode_write_fork().

Similarly, if an extending write allocates blocks in hfs_get_block() and
then fails a later block allocation after HFS_FLG_EMERGENCY_RO is set,
hfs_write_failed() -> hfs_file_truncate() returns before the out: label
resets phys_size, fs_blocks, and the inode byte count back to
inode->i_size.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-work-fs-sb=
_rdonly-v3-0-0be92bb73709@kernel.org?part=3D13
