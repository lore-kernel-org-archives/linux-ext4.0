From: sho@tnes.nec.co.jp
Subject: Re: [RFC] delayed allocation, mballoc, etc
Date: Wed, 27 Dec 2006 20:09:47 +0900
Message-ID: <20061227200947sho@rifu.tnes.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO200.gate.nec.co.jp ([210.143.35.50]:64775 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932310AbWL0LNz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Dec 2006 06:13:55 -0500
Received: from tyo202.gate.nec.co.jp ([10.7.69.202])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id kBRBDrFw008076
	for <linux-ext4@vger.kernel.org>; Wed, 27 Dec 2006 20:13:53 +0900 (JST)
Received: from mailgate3.nec.co.jp (mailgate53.nec.co.jp [10.7.69.162])
	by tyo202.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id kBRB9oao018650
	for <linux-ext4@vger.kernel.org>; Wed, 27 Dec 2006 20:09:50 +0900 (JST)
Received: (from root@localhost) by mailgate3.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id kBRB9oT00436 for linux-ext4@vger.kernel.org; Wed, 27 Dec 2006 20:09:50 +0900 (JST)
Received: from secsv3.tnes.nec.co.jp (tnesvc2.tnes.nec.co.jp [10.1.101.15]) by mailsv5.nec.co.jp (8.11.7/3.7W-MAILSV4-NEC) with ESMTP
	id kBRB9oi19558 for <linux-ext4@vger.kernel.org>; Wed, 27 Dec 2006 20:09:50 +0900 (JST)
Received: from tnesvc2.tnes.nec.co.jp ([10.1.101.15])
	by secsv3.tnes.nec.co.jp (ExpressMail 5.10) with SMTP
	id 20061227.201000.84301844 for <linux-ext4@vger.kernel.org>
	; Wed, 27 Dec 2006 20:10:00 +0900
To: alex@clusterfs.com
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Alex

I found a bug on linux-2.6.19-rc6 with Alex's patches.

With no files on the device, doing the following system call:
1. open with O_CREAT
	fd = open("test_file", O_RDWR|O_CREAT, 0777)
2. ftruncate (length is not aligned with blocksize)
	ftruncate(fd, 200)
3. write out the same block
	write(fd, write_buf, 100)

As a result, panic occurred at the following code:
  ext4_wb_commit_write()
          BUG_ON(EXT4_I(inode)->i_locality_group == NULL);

I tracked down the scenario of causing this panic, which is as below:
1. i_locality_group is set to NULL when a file is created at first

2. Given a length which is not aligned with blocksize to ftruncate,
   PG_dirty flag is set in _set_page_dirty_nobuffers() after zeroing
   out halfway part of the block on ftruncate
   	ext4_wb_block_truncate_page()
        	kaddr = kmap_atomic(page, KM_USER0);
        	memset(kaddr + offset, 0, length);
        	flush_dcache_page(page);
        	kunmap_atomic(kaddr, KM_USER0);
        	SetPageUptodate(page);s
        	_set_page_dirty_nobuffers(page);

3. With PG_dirty flag set, i_locality_group is not set in
   ext4_lg_page_enter_inode()
     ext4_wb_commit_write()
		if (__set_page_dirty_nobuffers(page))
			ext4_lg_page_enter_inode(inode, page,
				PageMappedToDisk(page));

4. i_locality_group set to NULL causes BUG_ON

I tried the attached patch where ext4_lg_page_enter_inode()
is necessarily called.  It seems to me that the problem does not occur
with this patch, how about your comment?

diff -upNr -X linux-2.6.19-rc6/Documentation/dontdiff linux-2.6.19-rc6/fs/ext4/writeback.c linux-2.6.19-rc6-tmp/fs/ext4/writeback.c
--- linux-2.6.19-rc6/fs/ext4/writeback.c        2006-12-22 19:16:17.000000000 +0900
+++ linux-2.6.19-rc6-tmp/fs/ext4/writeback.c   2006-12-22 19:15:45.000000000 +0900
@@ -968,10 +968,8 @@ int ext4_wb_commit_write(struct file *fi
 
-       if (__set_page_dirty_nobuffers(page)) {
-                __set_page_dirty_nobuffers(page);
-               ext4_lg_page_enter_inode(inode, page, PageMappedToDisk(page));
-       }
+       __set_page_dirty_nobuffers(page);
+       ext4_lg_page_enter_inode(inode, page, PageMappedToDisk(page));


Cheers, Takashi
