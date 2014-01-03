From: Robert Yang <liezhi.yang@windriver.com>
Subject: [PATCH 0/2] e2fsprogs: two fixes
Date: Fri, 3 Jan 2014 04:15:39 -0500
Message-ID: <1388740541-28123-1-git-send-email-liezhi.yang@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <linux-ext4@vger.kernel.org>
To: <tytso@mit.edu>, <sgh@sgh.dk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail1.windriver.com ([147.11.146.13]:55017 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbaACJP5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Jan 2014 04:15:57 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Fix icache
* Fix populate-extfs.sh

Robert Yang (1):
  inode.c: only update the icache for ext2_inode

S=C3=B8ren Holm (1):
  populate-extfs.sh: espace the space in the filename

 contrib/populate-extfs.sh |   20 ++++++++++----------
 lib/ext2fs/inode.c        |   20 ++++++++++++--------
 2 files changed, 22 insertions(+), 18 deletions(-)
 mode change 100755 =3D> 100644 contrib/populate-extfs.sh

--=20
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
