Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=79.135.106.27
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794898621;
	b=VNfGIl5FioXfaoxyUNgVX+Zo1ivyxuWIoh45L+fAXQdmRL8R+wr89CODa27MUyFBqP+U
	 tJGHK7pobJ/P8pIgl761lA0S7VSon/Wi1DU5fY6fpCPqIEU2CjVZvh3BDKhxmwSMA81ho
	 gdKPFz06CdsC74Ad7HW8zIGMVlXlEjDGVKN/owaypKx/YwEj8XDxS2sITrDiUQWZwMeuB
	 M6sZkZJ2zttOJSuv2wmFwIipa31Hh/NazL/v2WY5ExooUsNfbg+cV+3NlyAPatQKmEwe1
	 PCtX0jKNoU8sbF6YZV+PMMcqClhmChjkBdDiTqKvL4oTPhU/yOaCfj97phTTY08zkgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794898621;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 In-Reply-To:References:Feedback-ID:X-Pm-Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=MHRTTtvckqKw2iT9JpzJ002kKYT/m8IOyPQ3qg8CO6M=;
	b=QN4xUu/wA8NrTNu/emjw9aqMcNn/a15SooJmU46jfAqTEw1sP5zMF9m8VCCCEErd+wt+
	 e/UVkzg6tghdpJMLvxAJ4W1cKVEV9aa7dQJ/MC+cmb3PQknQhaC+jzlwaHNKshMG+Zk5b
	 BuxuSJWDBj6ifTQ9WKCBeKFiB+ygN0m5GG4IDrNCgNECPMm8XuZ4OQW0oCe43bUkXUTix
	 e3qGBHuoaDi5qjlHem0lTYo5VSc/1SvDrmFuzfRpRepFKOi4U/EAPRD1z1JLuHH3S5Gqa
	 OS0OgumaG41c5Hp+s3kd64SiLz7EZgB7HE6lHUvYzpWNxHEvn88t/ygKDUnr6zz3aAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=logarcheon.com;
	spf=pass smtp.mailfrom=logarcheon.com;
	dkim=pass header.d=logarcheon.com header.i=@logarcheon.com header.a=rsa-sha256 header.s=protonmail3 header.b=CmfgHZGN;
	arc=none smtp.remote-ip=79.135.106.27
Received: from mail-10627.protonmail.ch (mail-10627.protonmail.ch [79.135.106.27])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F5B606A336
	for <linux-ext4@vger.kernel.org>; Tue, 17 Nov 2026 06:57:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 22F5B606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=logarcheon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=logarcheon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=logarcheon.com header.i=@logarcheon.com header.a=rsa-sha256 header.s=protonmail3 header.b=CmfgHZGN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=logarcheon.com;
	s=protonmail3; t=1794898619; x=1795157819;
	bh=MHRTTtvckqKw2iT9JpzJ002kKYT/m8IOyPQ3qg8CO6M=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=CmfgHZGNouZNOVuj3zr7VMTYk0zWqZTfMHrgLsw9k4uNGErmwReoaLQwsmfwLavRJ
	 JrPdaDqg9FzCPKHU+zaQm6Ed3CalbuqiSk0PyIl4RZ+hbpBuzOjgw2vELNksvqX2SV
	 cL9JMuU0GPNma4o3dDrbdsmgStx3v7rq/XhSnqW2KYy5JVM6jrsgM0DcAlXwGRpin2
	 rrjwqmbh7JQSDhQXr9iou4Xk+Vp7WAUYLfc4bxRW9OsUwktcrFW7wIF2R+ROLrx8c6
	 VH4csUDOVkAcRGOqcFr/4jFH9DCI6EuMCQv1b0oYvbAhMqwIBUMNZJxfxTUYy602LX
	 fnq4FD0vzViyQ==
Date: Tue, 17 Nov 2026 06:56:53 +0000
To: Theodore Ts'o <tytso@mit.edu>
From: William Chuang <founder@logarcheon.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] ext4: reject a non-regular boot loader inode in EXT4_IOC_SWAP_BOOT
Message-ID: <20261117065645.4409-1-founder@logarcheon.com>
In-Reply-To: <20261117061822.3826-1-founder@logarcheon.com>
References: <20261117061822.3826-1-founder@logarcheon.com>
Feedback-ID: 145408520:user:proton
X-Pm-Message-ID: d1a907de22ab75cfcc2e256345bfd704d9f32861
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

swap_inode_boot_loader() gets the boot loader inode (inode 5) with
EXT4_IGET_BAD.  On a new filesystem that inode is unused, its mode is
0, and ext4_iget() returns it as a bad inode, which make_bad_inode()
sets to S_IFREG.  On a corrupted or crafted filesystem, ext4_iget()
can instead return inode 5 as a directory or another non-regular type,
fully set up with that type's inode and file operations.

Such an inode is first passed to lock_two_nondirectories(), which
warns if it is a directory:

  WARNING: fs/inode.c:1271 at lock_two_nondirectories
   swap_inode_boot_loader
   __ext4_ioctl

The "never used as a boot loader" branch then sets inode_bl->i_mode
to S_IFREG, changing the type of a live in-core inode while it keeps
the operations of its old type.

Check the type right after ext4_iget(): report the corruption and
return -EFSCORRUPTED unless the inode is a regular file.  Mark the
rejected inode bad before iput(), as ext4_get_journal_inode() does, so
that a corrupted inode 5 with i_nlink =3D=3D 0 is not passed to the
deletion path of ext4_evict_inode().  The unused
case is unaffected, since make_bad_inode() has already made it
S_IFREG.  This is the check Ted Ts'o suggested when the warning was
first reported.

Tested on UML at 666539eec: inode 5 set with debugfs to a directory
(with i_links_count 1, and with 0) or a character device, then
EXT4_IOC_SWAP_BOOT issued twice.  Before this patch, the directory
cases warn, and all cases succeed and leave inode 5 as a regular file
on disk.  After it, all return EFSCORRUPTED, the error is logged,
inode 5 is unchanged, and no attempt is made to free it.  On a
new filesystem the ioctl still succeeds, twice.  Not tested: KASAN
builds and syzbot's 2023 reproducer.

Fixes: 991ed014de08 ("ext4: fix bug_on in __es_tree_search caused by bad bo=
ot loader inode")
Suggested-by: Theodore Ts'o <tytso@mit.edu>
Link: https://lore.kernel.org/all/tencent_DABB2333139E8D1BCF4B5D1B2725FABA9=
108@qq.com/T/
Link: https://sashiko.dev/#/bug/linux-8cfc8e22-8259-4c89-8a8b-64c16e4481a5
Signed-off-by: William Chuang <founder@logarcheon.com>
---
v2: mark the rejected inode bad before iput(), as ext4_get_journal_inode()
    does (Sashiko review).  Without it, a corrupted inode 5 with
    i_links_count 0 went to the deletion path on iput(), which logged
    "ext4_free_inode: reserved or nonexistent inode 5".  Added that case
    to the tests.
v1: https://lore.kernel.org/all/20261117061822.3826-1-founder@logarcheon.co=
m/

 fs/ext4/ioctl.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index e8e579498..8990122f5 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -390,6 +390,26 @@ static long swap_inode_boot_loader(struct super_block =
*sb,
 =09=09return PTR_ERR(inode_bl);
 =09ei_bl =3D EXT4_I(inode_bl);
=20
+=09/*
+=09 * An unused boot loader inode comes back from ext4_iget() as a bad
+=09 * inode, which make_bad_inode() leaves as S_IFREG.  Any other type
+=09 * means the on-disk inode is corrupted; its type cannot be changed
+=09 * in place below.
+=09 */
+=09if (!S_ISREG(inode_bl->i_mode)) {
+=09=09EXT4_ERROR_INODE(inode_bl,
+=09=09=09=09 "boot loader inode is not a regular file (mode 0%o)",
+=09=09=09=09 inode_bl->i_mode);
+=09=09/*
+=09=09 * Drop it as a bad inode, as ext4_get_journal_inode() does:
+=09=09 * with i_nlink =3D=3D 0, a plain iput() would try to delete the
+=09=09 * reserved inode, and otherwise it would stay cached.
+=09=09 */
+=09=09make_bad_inode(inode_bl);
+=09=09iput(inode_bl);
+=09=09return -EFSCORRUPTED;
+=09}
+
 =09/* Protect orig inodes against a truncate and make sure,
 =09 * that only 1 swap_inode_boot_loader is running. */
 =09lock_two_nondirectories(inode, inode_bl);
--=20
2.43.0


