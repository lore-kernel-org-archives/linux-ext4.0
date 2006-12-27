From: Alex Tomas <alex@clusterfs.com>
Subject: Re: [RFC] delayed allocation, mballoc, etc
Date: Wed, 27 Dec 2006 14:16:48 +0300
Message-ID: <m3hcvhsi5b.fsf@bzzz.home.net>
References: <20061227200947sho@rifu.tnes.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: alex@clusterfs.com, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fe01.tochka.ru ([62.5.255.21]:50026 "EHLO umail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932321AbWL0LRL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Dec 2006 06:17:11 -0500
To: sho@tnes.nec.co.jp
In-Reply-To: <20061227200947sho@rifu.tnes.nec.co.jp> (sho@tnes.nec.co.jp's
	message of "Wed\, 27 Dec 2006 20\:09\:47 +0900")
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Hi,

you're right. thanks for the patch.

thanks, Alex

>>>>> sho  (s) writes:

 s> Hi Alex
 s> I found a bug on linux-2.6.19-rc6 with Alex's patches.

 s> With no files on the device, doing the following system call:
 s> 1. open with O_CREAT
 s> 	fd = open("test_file", O_RDWR|O_CREAT, 0777)
 s> 2. ftruncate (length is not aligned with blocksize)
 s> 	ftruncate(fd, 200)
 s> 3. write out the same block
 s> 	write(fd, write_buf, 100)

 s> As a result, panic occurred at the following code:
 s>   ext4_wb_commit_write()
 s>           BUG_ON(EXT4_I(inode)->i_locality_group == NULL);

 s> I tracked down the scenario of causing this panic, which is as below:
 s> 1. i_locality_group is set to NULL when a file is created at first

 s> 2. Given a length which is not aligned with blocksize to ftruncate,
 s>    PG_dirty flag is set in _set_page_dirty_nobuffers() after zeroing
 s>    out halfway part of the block on ftruncate
 s>    	ext4_wb_block_truncate_page()
 s>         	kaddr = kmap_atomic(page, KM_USER0);
 s>         	memset(kaddr + offset, 0, length);
 s>         	flush_dcache_page(page);
 s>         	kunmap_atomic(kaddr, KM_USER0);
 s>         	SetPageUptodate(page);s
 s>         	_set_page_dirty_nobuffers(page);

 s> 3. With PG_dirty flag set, i_locality_group is not set in
 s>    ext4_lg_page_enter_inode()
 s>      ext4_wb_commit_write()
 s> 		if (__set_page_dirty_nobuffers(page))
 s> 			ext4_lg_page_enter_inode(inode, page,
 s> 				PageMappedToDisk(page));

 s> 4. i_locality_group set to NULL causes BUG_ON

 s> I tried the attached patch where ext4_lg_page_enter_inode()
 s> is necessarily called.  It seems to me that the problem does not occur
 s> with this patch, how about your comment?

 s> diff -upNr -X linux-2.6.19-rc6/Documentation/dontdiff linux-2.6.19-rc6/fs/ext4/writeback.c linux-2.6.19-rc6-tmp/fs/ext4/writeback.c
 s> --- linux-2.6.19-rc6/fs/ext4/writeback.c        2006-12-22 19:16:17.000000000 +0900
 s> +++ linux-2.6.19-rc6-tmp/fs/ext4/writeback.c   2006-12-22 19:15:45.000000000 +0900
 s> @@ -968,10 +968,8 @@ int ext4_wb_commit_write(struct file *fi
 
 s> -       if (__set_page_dirty_nobuffers(page)) {
 s> -                __set_page_dirty_nobuffers(page);
 s> -               ext4_lg_page_enter_inode(inode, page, PageMappedToDisk(page));
 s> -       }
 s> +       __set_page_dirty_nobuffers(page);
 s> +       ext4_lg_page_enter_inode(inode, page, PageMappedToDisk(page));


 s> Cheers, Takashi
