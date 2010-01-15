From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: Re: [REPOST][RFC][PATCH] ext4: unify each meaning of the offset in
 ext4_check_dir_entry calling from some functions.
Date: Fri, 15 Jan 2010 12:40:01 +0900
Message-ID: <20100115124001.873ebf14.toshi.okajima@jp.fujitsu.com>
References: <20100114155739.99150559.toshi.okajima@jp.fujitsu.com>
	<F9B87217-D6BA-4BF6-BD13-1B960DB4B20C@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39528 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755445Ab0AOEAF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Jan 2010 23:00:05 -0500
Received: from m3.gw.fujitsu.co.jp ([10.0.50.73])
	by fgwmail5.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id o0F400H5011982
	for <linux-ext4@vger.kernel.org> (envelope-from toshi.okajima@jp.fujitsu.com);
	Fri, 15 Jan 2010 13:00:01 +0900
Received: from smail (m3 [127.0.0.1])
	by outgoing.m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 0BCA945DE53
	for <linux-ext4@vger.kernel.org>; Fri, 15 Jan 2010 13:00:00 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by m3.gw.fujitsu.co.jp (Postfix) with ESMTP id CEF1F45DE52
	for <linux-ext4@vger.kernel.org>; Fri, 15 Jan 2010 12:59:59 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 8D181E08001
	for <linux-ext4@vger.kernel.org>; Fri, 15 Jan 2010 12:59:59 +0900 (JST)
Received: from ml14.s.css.fujitsu.com (ml14.s.css.fujitsu.com [10.249.87.104])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 2DCBA1DB803E
	for <linux-ext4@vger.kernel.org>; Fri, 15 Jan 2010 12:59:59 +0900 (JST)
In-Reply-To: <F9B87217-D6BA-4BF6-BD13-1B960DB4B20C@sun.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas, thanks for your comment.

On Thu, 14 Jan 2010 10:18:53 -0500
Andreas Dilger <adilger@sun.com> wrote:

> > --- Examples ---
> > Error message which is changed by this patch:
> > EXT4-fs error (device loop0): htree_dirblock_to_tree: bad entry in  
> > directory
> > #12: rec_len is too small for name_len - block_nr=78:offset=0,  
> > inode=216,
> > rec_len=12, name_len=11
> 
> I personally would prefer to see "block=78, offset=0" instead of the  
> above.
OK. I change it.

> 
> > @@ -84,9 +84,10 @@ int ext4_check_dir_entry(const char *fun
> >
> > 	if (error_msg != NULL)
> > 		ext4_error(dir->i_sb, function,
> > +			"bad entry in directory #%lu: %s - block_nr=%llu:"
> > 			"offset=%u, inode=%u, rec_len=%d, name_len=%d",
> > +			dir->i_ino, error_msg,
> > +			(u64)bh->b_blocknr, (u32)(offset%bh->b_size),
> 
> 

> One problem here is that "(u64)" is not necessarily a "long long".  On  
> some 64-bit platforms it will be a "long" and this will generate a  
> compiler warning.  Better to use "(unsigned long long)", and you may  
> as well use "(unsigned)" for the offset value.
I understand. (u64 doesn't always mean "unsigned long long int")

I apply your all comment, and then I remake a patch.

Regards, 
Toshiyuki Okajima
---
Subject: [PATCH] ext4: unify each meaning of the offset in ext4_check_dir_entry calling from some functions.

From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>

"offset" of the error message of ext4_check_dir_entry() might change the
meaning by the caller. There are 2 meanings:
- "File offset"
  called by:
   ext4_readdir, htree_dirblock_to_tree, search_dirblock, ext4_dx_find_entry,
   empty_dir
- "Buffer offset"
  called by:
   add_dirent_to_buf, ext4_delete_entry

The best way to solve this problem is to change the meaning of 
"Buffer offset" into "File offset" but it is not easy.
However, we can solve this problem easily if we unify the meanings into 
"Buffer offset". So, instead of "File Offset" meaning, we add the block number 
information to this message.

--- Examples ---
Original error message:
EXT4-fs error (device loop0): htree_dirblock_to_tree: bad entry in directory \
#12: rec_len is too small for name_len - offset=12288, inode=216, rec_len=12,\
 name_len=11

Error message which is changed by this patch:
EXT4-fs error (device loop0): htree_dirblock_to_tree: bad entry in directory \
#12: rec_len is too small for name_len - block=78, offset=0, inode=216, \
rec_len=12, name_len=11

Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
---
 fs/ext4/dir.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index 9dc9316..65da7e5 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -84,9 +84,11 @@ int ext4_check_dir_entry(const char *function, struct inode *dir,
 
 	if (error_msg != NULL)
 		ext4_error(dir->i_sb, function,
-			"bad entry in directory #%lu: %s - "
+			"bad entry in directory #%lu: %s - block=%llu, "
 			"offset=%u, inode=%u, rec_len=%d, name_len=%d",
-			dir->i_ino, error_msg, offset,
+			dir->i_ino, error_msg, 
+			(unsigned long long)bh->b_blocknr, 
+			(unsigned)(offset%bh->b_size),
 			le32_to_cpu(de->inode),
 			rlen, de->name_len);
 	return error_msg == NULL ? 1 : 0;
