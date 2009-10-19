From: Peng Tao <bergwolf@gmail.com>
Subject: Re: donor file data inconsistent after EXT4_IOC_MOVE_EXT
Date: Mon, 19 Oct 2009 13:42:37 +0800
Message-ID: <4ADBFC4D.8050405@gmail.com>
References: <4ADABDB2.6080905@gmail.com> <4ADBB585.7050402@rs.jp.nec.com> <4ADBCEDE.3050009@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Kazuya Mio <k-mio@sx.jp.nec.com>, Theodore Ts'o <tytso@mit.edu>
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f208.google.com ([209.85.219.208]:62462 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233AbZJSFmr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Oct 2009 01:42:47 -0400
Received: by ewy4 with SMTP id 4so1189871ewy.37
        for <linux-ext4@vger.kernel.org>; Sun, 18 Oct 2009 22:42:50 -0700 (PDT)
In-Reply-To: <4ADBCEDE.3050009@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi, Akira,

Peng Tao wrote:
> Hi, Akira,
> Akira Fujita wrote:
>> Hi Peng,
>>
>> This is a known issue, and I sent a patch to linux-ext4 2 weeks ago.
>> Unfortunately it is not included in the ext4 patch queue yet.
>>
>> http://marc.info/?l=linux-ext4&m=125447192709338&w=2
>>
>> Would you retry your test case with above my patch?
> It didn't work. I still got the old donor file data.
invalidate_mapping_pages() in your patch won't invalidate the locked page returned by
grab_cache_page(). The following patch addresses the bug by calling
invalidate_inode_pages2_range() instead.

commit e88c6fa454c38039e9f342196129f8ef782f5edb
Author: Peng Tao <bergwolf@gmail.com>
Date:   Mon Oct 19 10:57:51 2009 +0800

    ext4: Invalidate donor file pagecache in EXT4_IOC_MOVE_EXT
    
    After calling EXT4_IOC_MOVE_EXT, the donor file will have data blocks previously
    owned by the orig file. But the pagecache for donor file still refers to old
    blocks in memory. The patch invalidates all pagecaches for donor file corresponding
    to replaced blocks. So later reading donor file won't hit the wrong pagecache.
    
    Signed-off-by: Peng Tao <bergwolf@gmail.com>

diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index 25b6b14..dcdfec8 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -826,6 +826,7 @@ move_extent_per_page(struct file *o_filp, struct inode *donor_inode,
 	const struct address_space_operations *a_ops = mapping->a_ops;
 	handle_t *handle;
 	ext4_lblk_t orig_blk_offset;
+	pgoff_t donor_page_offset = orig_page_offset;
 	long long offs = orig_page_offset << PAGE_CACHE_SHIFT;
 	unsigned long blocksize = orig_inode->i_sb->s_blocksize;
 	unsigned int w_flags = 0;
@@ -920,6 +921,8 @@ move_extent_per_page(struct file *o_filp, struct inode *donor_inode,
 	ext4_ext_invalidate_cache(orig_inode);
 	ext4_ext_invalidate_cache(donor_inode);
 
+	invalidate_inode_pages2_range(donor_inode->i_mapping, donor_page_offset,
+					donor_page_offset);
 	if (!page_has_buffers(page))
 		create_empty_buffers(page, 1 << orig_inode->i_blkbits, 0);
 



