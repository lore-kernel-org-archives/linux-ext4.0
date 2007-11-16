From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [PATCH] ext3,4:fdatasync should skip metadata writeout
Date: Fri, 16 Nov 2007 04:43:32 +0100
Message-ID: <20071116034332.GK13834@lazybastard.org>
References: <6.0.0.20.2.20071116114652.03b9e4e8@172.19.0.2>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lazybastard.de ([212.112.238.170]:51715 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466AbXKPDsc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Nov 2007 22:48:32 -0500
Content-Disposition: inline
In-Reply-To: <6.0.0.20.2.20071116114652.03b9e4e8@172.19.0.2>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 16 November 2007 11:47:27 +0900, Hisashi Hifumi wrote:
>=20
> diff -Nrup linux-2.6.24-rc2.org/fs/ext3/fsync.c linux-2.6.24-rc2/fs/e=
xt3/fsync.c
> --- linux-2.6.24-rc2.org/fs/ext3/fsync.c	2007-11-07 06:57:46.00000000=
0 +0900
> +++ linux-2.6.24-rc2/fs/ext3/fsync.c	2007-11-15 17:50:24.000000000 +0=
900
> @@ -72,6 +72,9 @@ int ext3_sync_file(struct file * file, s
>  		goto out;
>  	}
> =20
> +	if (datasync)
> +		goto out;=09
> +
>  	/*
>  	* The VFS has written the file data.  If the inode is unaltered
>  	* then we need not start a commit.

This is wrong.  If I_DIRTY_DATASYNC is set, the inode needs to be
written even for datasync.

How about the patch below?

J=C3=B6rn

--=20
Audacity augments courage; hesitation, fear.
-- Publilius Syrus


Signed-off-by: J=C3=B6rn Engel <joern@logfs.org>
---

 fs/ext3/fsync.c |    3 ++-
 fs/ext4/fsync.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- git_I_DIRTY/fs/ext3/fsync.c~ext3_datasync	2007-11-15 20:51:54.00000=
0000 +0100
+++ git_I_DIRTY/fs/ext3/fsync.c	2007-11-16 04:42:28.000000000 +0100
@@ -76,7 +76,8 @@ int ext3_sync_file(struct file * file, s
 	 * The VFS has written the file data.  If the inode is unaltered
 	 * then we need not start a commit.
 	 */
-	if (inode->i_state & (I_DIRTY_SYNC|I_DIRTY_DATASYNC)) {
+	if (((inode->i_state & I_DIRTY_SYNC) && !datasync)
+			|| (inode->i_state & I_DIRTY_DATASYNC)) {
 		struct writeback_control wbc =3D {
 			.sync_mode =3D WB_SYNC_ALL,
 			.nr_to_write =3D 0, /* sys_fsync did this */
--- git_I_DIRTY/fs/ext4/fsync.c~ext3_datasync	2007-11-15 20:51:54.00000=
0000 +0100
+++ git_I_DIRTY/fs/ext4/fsync.c	2007-11-16 04:44:29.000000000 +0100
@@ -76,7 +76,8 @@ int ext4_sync_file(struct file * file, s
 	 * The VFS has written the file data.  If the inode is unaltered
 	 * then we need not start a commit.
 	 */
-	if (inode->i_state & (I_DIRTY_SYNC|I_DIRTY_DATASYNC)) {
+	if (((inode->i_state & I_DIRTY_SYNC) && !datasync)
+			|| (inode->i_state & I_DIRTY_DATASYNC)) {
 		struct writeback_control wbc =3D {
 			.sync_mode =3D WB_SYNC_ALL,
 			.nr_to_write =3D 0, /* sys_fsync did this */
