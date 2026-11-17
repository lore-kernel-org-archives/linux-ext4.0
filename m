Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.70.43.96
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794896316;
	b=GSNLUOmg6MY4NkVpT/1bsX/QzwqDHSrcxhXil02zz2Kj2m+40KnTZ5LN7Aq7V9ww9OrY
	 U8kfVhihJu3Gl/89lhVtilPkur+dLttkkxnfdRK+pcTNsKBTddUhdIxoJyJcsLfLIDRzb
	 yZy8399jvxxToPsU4/sIQlHrUhpfzLdfbagg2FL4zCdfFt/eGKMHM929aWQY/SkpvQ53J
	 hCKi1Ufe+fGSbuJ9OnWK3mGY4OvcB3fTCYvAd7V/abZCUiDRTsWMx5qzyU5Z/2pIqYFtw
	 q6bjTorTiMCXhbuyToLVUyIx+1A7ECrBRG/y3TbMHjsDX8oWmQUl2oiTp/kccTeiTqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794896316;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 Feedback-ID:X-Pm-Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=g9WpbvpWayMQty3L13Bl45/w53/aszcbD+lahmZQyRM=;
	b=d3A+4cBLzh7+qXbnqVqweIxKZwOgLrZqw2wHbCXSKfka7aSR0HUyLbxAIevdPi8s3RmB
	 yHJjs1n9XSNWJC9kcYH6Dqch8ShlmuAreFP9mj8bjzIRU3DdPDLq3dAt4xLuJhN2CC6cH
	 FinEiaN0G7KO/vF2Cv0nG6lVaPoWUj9zneuZdrDHCkgUXLH6fwt/OPjB9zO8iIGagiSK9
	 fdBFUi5xX5LfgtlQl97jq6VVM1+TIjBjTr7mG5ObL0dgqBz5QzLcV9w+3pUbTZE7Tj71v
	 3of7m4hZ0RBGeQxaGft2l71ioKDU+IQ4obBVCmxS8lT46Ww76+UWmD3tzcfzeIO55bw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=logarcheon.com;
	spf=pass smtp.mailfrom=logarcheon.com;
	dkim=pass header.d=logarcheon.com header.i=@logarcheon.com header.a=rsa-sha256 header.s=protonmail3 header.b=aMkJ5Ohz;
	arc=none smtp.remote-ip=185.70.43.96
Received: from mail-4396.protonmail.ch (mail-4396.protonmail.ch [185.70.43.96])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C993E606A32F;
	Tue, 17 Nov 2026 06:18:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C993E606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=logarcheon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=logarcheon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=logarcheon.com header.i=@logarcheon.com header.a=rsa-sha256 header.s=protonmail3 header.b=aMkJ5Ohz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=logarcheon.com;
	s=protonmail3; t=1794896312; x=1795155512;
	bh=g9WpbvpWayMQty3L13Bl45/w53/aszcbD+lahmZQyRM=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=aMkJ5Ohze3Y+7hsinO4MXCkJXPdIKh45KSb55ZUDw3FWXosvQfupgdTYdCXGYwxGY
	 QdgthtugQINRkI8mj8sQDNHfu8B5/oNGkPw0oHSeQoElN1+s2adPcexRDbWEBMwWVf
	 da6lBC0Doe48/TlERkZZtQDuwO5f1SRofB0rg8BqE8CKCQvsvMPu3CeU3gvddMawAJ
	 K7dlr2X5WrllzNjZ90vOk9wmbTj/BBLxKxtMOdUR2+497y2F4cpdR6TJjjz/SvmzdY
	 tUG+0ZCz3FzW2WtwfIubSbq9SF46R3jZhTGEad7u1zVtei+kSDup6hhf4Mg2hwW4JP
	 Xi5P5bwp/o1Rw==
Date: Tue, 17 Nov 2026 06:18:28 +0000
To: Theodore Ts'o <tytso@mit.edu>
From: William Chuang <founder@logarcheon.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ext4: reject a non-regular boot loader inode in EXT4_IOC_SWAP_BOOT
Message-ID: <20261117061822.3826-1-founder@logarcheon.com>
Feedback-ID: 145408520:user:proton
X-Pm-Message-ID: ca8656d4290b5230c64af18a94219f857e1b015d
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
return -EFSCORRUPTED unless the inode is a regular file.  The unused
case is unaffected, since make_bad_inode() has already made it
S_IFREG.  This is the check Ted Ts'o suggested when the warning was
first reported.

Tested on UML at 666539eec: inode 5 set to a directory or a character
device with debugfs, then EXT4_IOC_SWAP_BOOT issued twice.  Before
this patch, the directory case warns, and both cases succeed and
leave inode 5 as a regular file on disk.  After it, both return
EFSCORRUPTED, the error is logged, and inode 5 is unchanged.  On a
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
 fs/ext4/ioctl.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index e8e579498..cf005fe2d 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -390,6 +390,20 @@ static long swap_inode_boot_loader(struct super_block =
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
+=09=09iput(inode_bl);
+=09=09return -EFSCORRUPTED;
+=09}
+
 =09/* Protect orig inodes against a truncate and make sure,
 =09 * that only 1 swap_inode_boot_loader is running. */
 =09lock_two_nondirectories(inode, inode_bl);
--=20
2.43.0


