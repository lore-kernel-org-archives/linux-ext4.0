From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 3/5] ext4_zero_range: fix incorect journal credits reservation
Date: Mon, 25 Aug 2014 11:19:39 +0400
Message-ID: <87k35x9gtw.fsf@openvz.org>
References: <1408707147-22482-1-git-send-email-dmonakhov@openvz.org> <1408707147-22482-4-git-send-email-dmonakhov@openvz.org> <20140823190835.GB6236@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Cc: linux-ext4@vger.kernel.org, lczerner@redhat.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:63958 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927AbaHYHTo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Aug 2014 03:19:44 -0400
Received: by mail-lb0-f182.google.com with SMTP id z11so11814608lbi.13
        for <linux-ext4@vger.kernel.org>; Mon, 25 Aug 2014 00:19:42 -0700 (PDT)
In-Reply-To: <20140823190835.GB6236@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=

On Sat, 23 Aug 2014 15:08:35 -0400, "Theodore Ts'o" <tytso@mit.edu> wrote:
> On Fri, Aug 22, 2014 at 03:32:25PM +0400, Dmitry Monakhov wrote:
> > -	handle = ext4_journal_start(inode, EXT4_HT_MISC, 4);
> > +	/* In worst case we have to writeout two nonadjacent unwritten blocks */
> > +	credits = ext4_chunk_trans_blocks(inode, 1) * 2 -
> > +		EXT4_META_TRANS_BLOCKS(inode->i_sb);
> 
> This looks like it would be a massive over-estimate, since it includes
> the block group allocation bitmaps, which we wouldn't need to update,
> no?
  Oh. You right. groups metadata/quota should not be affected.
> 
> Wouldn't
> 
> 	credts = ext4_index_trans_blocks(inode, 1, 1) * 2;
Yes, but ext4_index_trans_blocks is statically defined in inode.c,
but since zero_range works only for extent based
ext4_ext_index_trans_blocks is sufficient. Also we must reserve 2 block
for data. So final calculation looks like follows:
credits =  ext4_ext_index_trans_blocks(inode, 2) + 2


--=-=-=
Content-Type: text/x-patch
Content-Disposition: inline;
 filename=0001-ext4_zero_range-fix-incorect-journal-credits-reserva.patch

>From ec7e1926e8bb99ccd0eb525efc6666cb8ea36a5e Mon Sep 17 00:00:00 2001
From: Dmitry Monakhov <dmonakhov@openvz.org>
Date: Mon, 25 Aug 2014 11:12:35 +0400
Subject: [PATCH] ext4_zero_range: fix incorect journal credits reservation v2

Currently we reserve only 4 blocks but in worst case scenario
ext4_zero_partial_blocks() may want to zeroout and convert two
non adjacent blocks.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/extents.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 5bf718b..f09dbe7 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4740,6 +4740,7 @@ static long ext4_zero_range(struct file *file, loff_t offset,
 	loff_t new_size = 0;
 	int ret = 0;
 	int flags;
+	int credits;
 	int partial;
 	loff_t start, end;
 	ext4_lblk_t lblk;
@@ -4839,8 +4840,9 @@ static long ext4_zero_range(struct file *file, loff_t offset,
 		if (ret)
 			goto out_dio;
 	}
--=-=-=--
