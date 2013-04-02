From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: s390x: kernel BUG at fs/ext4/inode.c:1591! (powerpc too!)
Date: Tue, 02 Apr 2013 23:49:32 +0400
Message-ID: <87mwtgvhkj.fsf@openvz.org>
References: <2133129347.8273339.1364549222854.JavaMail.root@redhat.com> <87ip46ss0o.fsf@openvz.org> <1211053180.322948.1364797847717.JavaMail.root@redhat.com> <87fvzaspr8.fsf@openvz.org> <874841142.414482.1364875584266.JavaMail.root@redhat.com> <alpine.DEB.2.10.1304012249440.5874@trent.utfs.org> <877gkls1q7.fsf@openvz.org> <20130402123356.GA10703@gmail.com> <alpine.DEB.2.10.1304021202100.13746@trent.utfs.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Cc: CAI Qian <caiqian@redhat.com>, Theodore Ts'o <tytso@mit.edu>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-s390 <linux-s390@vger.kernel.org>,
	Steve Best <sbest@redhat.com>, linux-ext4@vger.kernel.org
To: Christian Kujau <lists@nerdbynature.de>,
	Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:58567 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932401Ab3DBTti (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Apr 2013 15:49:38 -0400
In-Reply-To: <alpine.DEB.2.10.1304021202100.13746@trent.utfs.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=

On Tue, 2 Apr 2013 12:07:37 -0700 (PDT), Christian Kujau <lists@nerdbynature.de> wrote:
> On Tue, 2 Apr 2013 at 20:33, Zheng Liu wrote:
> > Could you please revert your tree to this commit (3a225670), and try
> > again. I want to make sure that the regression won't be fixed until now
> > or it is introduced after this commit.
> 
> I have git-revert'ed this commit and the same BUG_ON was triggered again. 
> I could not bring "fsstress" to trigger this but resuming this 4.3 GB 
> Fedora DVD image via bittorrent made the machine crash after a couple of 
> minutes.
> 
> Sadly the only message netconsole is able to catch is this single line 
> from the subject above, but I'll try to apply the proposed patches[0] and 
> see if it helps anything.
Ok if netconsole can't log in case of BUG_ON then we just skip panic :)
Please use following patch instead of enable_ES_AGGRESSIVE_TEST.diff

--=-=-=
Content-Type: text/x-patch
Content-Disposition: inline;
 filename=0001-enable-ES_AGGRESSIVE_TEST-V2.patch

>From e802d032225a74156f8256467aa64535369ae45c Mon Sep 17 00:00:00 2001
From: Dmitry Monakhov <dmonakhov@openvz.org>
Date: Tue, 2 Apr 2013 23:33:16 +0400
Subject: [PATCH] enable ES_AGGRESSIVE_TEST V2


Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/extents_status.h |    2 +-
 fs/ext4/inode.c          |   17 +++++++++++++++--
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/extents_status.h b/fs/ext4/extents_status.h
index d8e2d4d..70233a6 100644
--- a/fs/ext4/extents_status.h
+++ b/fs/ext4/extents_status.h
@@ -24,7 +24,7 @@
  * With ES_AGGRESSIVE_TEST defined, the result of es caching will be
  * checked with old map_block's result.
  */
-#define ES_AGGRESSIVE_TEST__
+#define ES_AGGRESSIVE_TEST
 
 /*
  * These flags live in the high bits of extent_status.es_pblk
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 840a23e..7712aff 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1546,7 +1546,18 @@ static int mpage_da_submit_io(struct mpage_da_data *mpd,
 					}
 					if (buffer_unwritten(bh) ||
 					    buffer_mapped(bh))
-						BUG_ON(bh->b_blocknr != pblock);
+						if (bh->b_blocknr != pblock) {
+							printk(KERN_ERR "mpage_da_submit_io failed"
+							       " block=%llu != b_blocknr=%llu\n",
+							       (unsigned long long)pblock,
+							       (unsigned long long)bh->b_blocknr);
+							printk(KERN_ERR "ino:%ld lbkl:%lu, "
+							       "b_state=0x%08lx, b_size=%zu\n",
+							       inode->i_ino, cur_logical,
+							       bh->b_state, bh->b_size);
+							WARN_ON(1);
+							goto skip_page;
+						}
 					if (map->m_flags & EXT4_MAP_UNINIT)
 						set_buffer_uninit(bh);
 					clear_buffer_unwritten(bh);
@@ -1556,8 +1567,10 @@ static int mpage_da_submit_io(struct mpage_da_data *mpd,
 				 * skip page if block allocation undone and
 				 * block is dirty
 				 */
-				if (ext4_bh_delay_or_unwritten(NULL, bh))
+				if (ext4_bh_delay_or_unwritten(NULL, bh)) {
+				skip_page:
 					skip_page = 1;
+				}
 				bh = bh->b_this_page;
 				block_start += bh->b_size;
 				cur_logical++;
-- 
1.7.1


--=-=-=

So once you hit the bug it will print a lot of warnings and try to
pretend what nothing is happens.

So my predictions is follows:
1) with enable_ES_AGGRESSIVE_TEST-V2.diff patch you will see a lot of
warnings

2) with enable_ES_AGGRESSIVE_TEST-V2.diff and
   http://nerdbynature.de/bits/3.9.0-rc4/ext4/disable-es_lookup_extent.patch
 
   Issue probably will go away (will be hidden)

> 
> Thanks,
> Christian.
> 
> [0] http://nerdbynature.de/bits/3.9.0-rc4/ext4/
> -- 
> BOFH excuse #344:
> 
> Network failure -  call NBC

--=-=-=--
