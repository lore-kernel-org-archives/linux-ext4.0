From: =?UTF-8?q?T=C3=B6r=C3=B6k=20Edwin?= <edwintorok@gmail.com>
Subject: [PATCH] fix wrong iput on d_inode introduced by e6bc45d65d
Date: Thu, 16 Jun 2011 00:06:14 +0300
Message-ID: <1308171974-7323-1-git-send-email-edwintorok@gmail.com>
References: <4DF868C8.3040903@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	=?UTF-8?q?T=C3=B6r=C3=B6k=20Edwin?= <edwintorok@gmail.com>
To: Dave Jones <davej@redhat.com>, Eric Sandeen <sandeen@redhat.com>,
	"Theodore Ts'o" <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>,
	Norbert Preining <preining@logic.at>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42131 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab1FOVG1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Jun 2011 17:06:27 -0400
In-Reply-To: <4DF868C8.3040903@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Git bisection shows that commit e6bc45d65df8599fdbae73be9cec4ceed274db5=
3 causes
BUG_ONs under high I/O load:

kernel BUG at fs/inode.c:1368!
[ 2862.501007] Call Trace:
[ 2862.501007]  [<ffffffff811691d8>] d_kill+0xf8/0x140
[ 2862.501007]  [<ffffffff81169c19>] dput+0xc9/0x190
[ 2862.501007]  [<ffffffff8115577f>] fput+0x15f/0x210
[ 2862.501007]  [<ffffffff81152171>] filp_close+0x61/0x90
[ 2862.501007]  [<ffffffff81152251>] sys_close+0xb1/0x110
[ 2862.501007]  [<ffffffff814c14fb>] system_call_fastpath+0x16/0x1b

A reliable way to reproduce this bug is:
Login to KDE, run 'rsnapshot sync', and apt-get install openjdk-6-jdk,
and apt-get remove openjdk-6-jdk.

The buggy part of the patch is this:
	struct inode *inode =3D NULL;
=2E....
-               if (nd.last.name[nd.last.len])
-                       goto slashes;
                inode =3D dentry->d_inode;
-               if (inode)
-                       ihold(inode);
+               if (nd.last.name[nd.last.len] || !inode)
+                       goto slashes;
+               ihold(inode)
=2E..
	if (inode)
		iput(inode);	/* truncate the inode here */

If nd.last.name[nd.last.len] is nonzero (and thus goto slashes branch i=
s taken),
and dentry->d_inode is non-NULL, then this code now does an additional =
iput on
the inode, which is wrong.

=46ix this by only setting the inode variable if nd.last.name[nd.last.l=
en] is 0.

Reference: https://lkml.org/lkml/2011/6/15/50
Reported-by: Norbert Preining <preining@logic.at>
Reported-by: T=C3=B6r=C3=B6k Edwin <edwintorok@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: T=C3=B6r=C3=B6k Edwin <edwintorok@gmail.com>
---
 fs/namei.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 9802345..6301963 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2713,8 +2713,10 @@ static long do_unlinkat(int dfd, const char __us=
er *pathname)
 	error =3D PTR_ERR(dentry);
 	if (!IS_ERR(dentry)) {
 		/* Why not before? Because we want correct error value */
+		if (nd.last.name[nd.last.len])
+			goto slashes;
 		inode =3D dentry->d_inode;
-		if (nd.last.name[nd.last.len] || !inode)
+		if (!inode)
 			goto slashes;
 		ihold(inode);
 		error =3D mnt_want_write(nd.path.mnt);
--=20
1.7.5.4

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
