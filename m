From: =?UTF-8?B?Iua9mOWNq+W5syhQZXRlciBQYW4pIg==?=
	<wppan@redflag-linux.com>
Subject: [PATCH] ext4:memset is needless in ext4_ext_remove_space()
Date: Mon, 08 Nov 2010 09:19:47 +0800
Message-ID: <4CD75033.7080902@redflag-linux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.redflag-linux.com ([219.237.229.196]:43780 "EHLO
	mail.redflag-linux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab0KHBVm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 7 Nov 2010 20:21:42 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


memset is needless because path is allocated by kzalloc.

Signed-off-by: Peter Pan(=E6=BD=98=E5=8D=AB=E5=B9=B3) <wppan@redflag-li=
nux.com>
---
  fs/ext4/extents.c |    1 -
  1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 0554c48..37cdb6e 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2375,7 +2375,6 @@ again:
  			/* go to the next level */
  			ext_debug("move to level %d (block %llu)\n",
  				  i + 1, ext4_idx_pblock(path[i].p_idx));
-			memset(path + i + 1, 0, sizeof(*path));
  			bh =3D sb_bread(sb, ext4_idx_pblock(path[i].p_idx));
  			if (!bh) {
  				/* should we reset i_size? */
--=20
1.6.6


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
