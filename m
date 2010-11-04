From: =?UTF-8?B?Iua9mOWNq+W5syhQZXRlciBQYW4pIg==?=
	<wppan@redflag-linux.com>
Subject: [PATCH] no need for memset since kzalloc
Date: Thu, 04 Nov 2010 16:20:23 +0800
Message-ID: <4CD26CC7.3090502@redflag-linux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

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
