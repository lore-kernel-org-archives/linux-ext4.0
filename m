Received: from out01.mxguardian.net (out01.mxguardian.net [54.88.152.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC1194848BC
	for <linux-ext4@vger.kernel.org>; Thu,  8 Oct 2026 23:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.88.152.167
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791501114; cv=none; b=Jc1D5sXOs2ZneMLHUUvpVOQhqPvOSRrl5V449gf6EvtYUxhZ2mn7GumrsMkPetFgxPcy1k+RTxLoW5gzrqWrwreUY6wISfnO6avNVqHp96wPVQ8XMPgiVOashvRrp92QX386AR7t87hBfkE7C/4KFu44QT56W3k1P1IY9AAafP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791501114; c=relaxed/simple;
	bh=WLDTgt1KgF3/+v3zrklexTpdmPkdcUNI1HqTXkdGCuw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Z7SPNVRWGKFZUBX2s7WuU/VqcRms8b7VVJYU6zpF+kcTTeT/c/z0T6ZtaYCxhrU0O4xn3rox7KbCMHB6QM6szlLK9QzrO1rhFDIl3drIZZ5TAUJpWkaMQrtczNO+5TKBb/Fjee322QohapzBW1enEVY+/hriBgIYqeJO3tA+yP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mhn.org; spf=pass smtp.mailfrom=mhn.org; dkim=fail (1024-bit key) header.d=mhn.org header.i=@mhn.org header.b=RvQaoZfx reason="signature verification failed"; arc=none smtp.client-ip=54.88.152.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mhn.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mhn.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mhn.org header.i=@mhn.org header.b="RvQaoZfx"
Received: from localhost (localhost [127.0.0.1])
	by out01.mxguardian.net (Postfix) with ESMTP id 6A109642F6;
	Thu,  8 Oct 2026 23:09:18 +0000 (UTC)
X-MXG-Results: DI:6449; PI:0; C:C; S:0
Received: from smtp01.mxguardian.net ([172.16.1.26])
	by localhost (out01.mxguardian.net [172.16.1.181]) (MXG, port 10024)
	with ESMTP id GfAr8gIJJVN8; Thu,  8 Oct 2026 23:09:17 +0000 (UTC)
X-MXG-Auth: 52.14.61.233
X-MXG-Auth: 52.14.61.233
Received: from mhn.org (mhn.org [52.14.61.233])
	by smtp01.mxguardian.net (Postfix) with ESMTPS id 4D865601A7;
	Thu,  8 Oct 2026 23:09:17 +0000 (UTC)
Received: from terra.int.mhn.org (136-56-27-198.googlefiber.net [136.56.27.198] (may be forged))
	(authenticated bits=0)
	by mhn.org (8.16.1/8.16.1) with ESMTPSA id 698N9AhN242042
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Thu, 8 Oct 2026 19:09:16 -0400
DKIM-Filter: OpenDKIM Filter v2.11.0 mhn.org 698N9AhN242042
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mhn.org; s=default;
	t=1791500956; bh=eS4hGeMX8epiPJtQCQDtWKyEjMR73QJ48GuiGGxXQZU=;
	h=From:To:Cc:Subject:Date:From;
	b=RvQaoZfxjoFVhSCo/bt2Fn+QJAPLGvY5dBN+4FhDvQGp/TuO9hP4iudsiZR5Zc7mL
	 5Bwi03Z0xWHXFUJ82ajJaqD04lwwik7myafBZOyy35U/pen5/QdLIeG9EWCJ0ZBPTk
	 MqpuGIJuy9uqr1Z8o+Apogkp/BGR5kReRlIbMFJ4=
From: graham@mhn.org
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu, Graham Mainwaring <graham@mhn.org>
Subject: [PATCH] mke2fs: tolerate unsupported xattrs in mke2fs -d
Date: Thu,  8 Oct 2026 19:08:58 -0400
Message-ID: <20261008230858.87001-1-graham@mhn.org>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

From: Graham Mainwaring <graham@mhn.org>

When populating a filesystem image with "mke2fs -d", set_inode_xattr()
copies the extended attributes of each source file. If llistxattr()
fails with ENOTSUP it simply returns 0 and copies no attributes.

However, if llistxattr() reports an attribute name but the subsequent
lgetxattr() fails with ENOTSUP, the whole copy is aborted and mke2fs
returns with an error. This can happen when running mke2fs inside a
sandboxed environment running on an SELinux-enabled host. Processes
in the sandbox see, but cannot read, the "security.selinux" label
from host files.

The fix is just to extend the existing ENOTSUP tolerance to the
per-attribute lgetxattr() calls.

Signed-off-by: Graham Mainwaring <graham@mhn.org>
---
 misc/create_inode.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/misc/create_inode.c b/misc/create_inode.c
index 7bce8e9b..31df8313 100644
--- a/misc/create_inode.c
+++ b/misc/create_inode.c
@@ -204,6 +204,8 @@ static errcode_t set_inode_xattr(ext2_filsys fs, ext2=
_ino_t ino,
=20
 		value_size =3D lgetxattr(filename, name, NULL, 0);
 		if (value_size =3D=3D -1) {
+			if (errno =3D=3D ENOTSUP)
+				continue;
 			retval =3D errno;
 			com_err(__func__, retval,
 				_("while reading attribute \"%s\" of \"%s\""),
@@ -220,6 +222,8 @@ static errcode_t set_inode_xattr(ext2_filsys fs, ext2=
_ino_t ino,
 		value_size =3D lgetxattr(filename, name, value, value_size);
 		if (value_size =3D=3D -1) {
 			ext2fs_free_mem(&value);
+			if (errno =3D=3D ENOTSUP)
+				continue;
 			retval =3D errno;
 			com_err(__func__, retval,
 				_("while reading attribute \"%s\" of \"%s\""),
--=20
2.56.0

