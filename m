From: Fengguang Wu <fengguang.wu@intel.com>
Subject: [ext4:dev 47/50] fs/ext4/extents.c:4949 ext4_ext_punch_hole() warn:
 inconsistent returns mutex:&inode->i_mutex: locked (4813,4815) unlocked
 (4806,4949)
Date: Mon, 1 Oct 2012 10:50:47 +0800
Message-ID: <20121001025047.GB12711@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kernel-janitors@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:45870 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476Ab2JACuw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 30 Sep 2012 22:50:52 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Dmitry,

FYI, there are new smatch warnings show up in

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev
head:   07043757c1a4018a04aded14deb1f28269a4b2ad
commit: c6a59106b4106d13dc824a388c5572ddd65a0779 [47/50] ext4: punch_hole should wait for DIO writers

  arch/x86/include/asm/jump_label.h:25 arch_static_branch() info: ignoring unreachable code.
+ fs/ext4/extents.c:4949 ext4_ext_punch_hole() warn: inconsistent returns mutex:&inode->i_mutex: locked (4813,4815) unlocked (4806,4949)

vim +4949 fs/ext4/extents.c

c6a59106 (Dmitry Monakhov   2012-09-29  4800) 	 */
c6a59106 (Dmitry Monakhov   2012-09-29  4801) 	if (mapping->nrpages && mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
c6a59106 (Dmitry Monakhov   2012-09-29  4802) 		err = filemap_write_and_wait_range(mapping,
c6a59106 (Dmitry Monakhov   2012-09-29  4803) 			offset, offset + length - 1);
c6a59106 (Dmitry Monakhov   2012-09-29  4804) 
c6a59106 (Dmitry Monakhov   2012-09-29  4805) 		if (err)
c6a59106 (Dmitry Monakhov   2012-09-29  4806) 			return err;
c6a59106 (Dmitry Monakhov   2012-09-29  4807) 	}
c6a59106 (Dmitry Monakhov   2012-09-29  4808) 
c6a59106 (Dmitry Monakhov   2012-09-29  4809) 	mutex_lock(&inode->i_mutex);
c6a59106 (Dmitry Monakhov   2012-09-29  4810) 	/* Need recheck file flags under mutex */
c6a59106 (Dmitry Monakhov   2012-09-29  4811) 	/* It's not possible punch hole on append only file */
c6a59106 (Dmitry Monakhov   2012-09-29  4812) 	if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
c6a59106 (Dmitry Monakhov   2012-09-29  4813) 		return -EPERM;
c6a59106 (Dmitry Monakhov   2012-09-29  4814) 	if (IS_SWAPFILE(inode))
c6a59106 (Dmitry Monakhov   2012-09-29  4815) 		return -ETXTBSY;
c6a59106 (Dmitry Monakhov   2012-09-29  4816) 
2be4751b (Allison Henderson 2011-09-03  4817) 	/* No need to punch hole beyond i_size */
2be4751b (Allison Henderson 2011-09-03  4818) 	if (offset >= inode->i_size)
c6a59106 (Dmitry Monakhov   2012-09-29  4819) 		goto out_mutex;
2be4751b (Allison Henderson 2011-09-03  4820) 
2be4751b (Allison Henderson 2011-09-03  4821) 	/*
2be4751b (Allison Henderson 2011-09-03  4822) 	 * If the hole extends beyond i_size, set the hole
2be4751b (Allison Henderson 2011-09-03  4823) 	 * to end after the page that contains i_size
2be4751b (Allison Henderson 2011-09-03  4824) 	 */
2be4751b (Allison Henderson 2011-09-03  4825) 	if (offset + length > inode->i_size) {
2be4751b (Allison Henderson 2011-09-03  4826) 		length = inode->i_size +
2be4751b (Allison Henderson 2011-09-03  4827) 		   PAGE_CACHE_SIZE - (inode->i_size & (PAGE_CACHE_SIZE - 1)) -
2be4751b (Allison Henderson 2011-09-03  4828) 		   offset;
2be4751b (Allison Henderson 2011-09-03  4829) 	}
2be4751b (Allison Henderson 2011-09-03  4830) 
a4bb6b64 (Allison Henderson 2011-05-25  4831) 	first_page = (offset + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
a4bb6b64 (Allison Henderson 2011-05-25  4832) 	last_page = (offset + length) >> PAGE_CACHE_SHIFT;
a4bb6b64 (Allison Henderson 2011-05-25  4833) 
a4bb6b64 (Allison Henderson 2011-05-25  4834) 	first_page_offset = first_page << PAGE_CACHE_SHIFT;
a4bb6b64 (Allison Henderson 2011-05-25  4835) 	last_page_offset = last_page << PAGE_CACHE_SHIFT;
a4bb6b64 (Allison Henderson 2011-05-25  4836) 
a4bb6b64 (Allison Henderson 2011-05-25  4837) 	/* Now release the pages */
a4bb6b64 (Allison Henderson 2011-05-25  4838) 	if (last_page_offset > first_page_offset) {
5e44f8c3 (Hugh Dickins      2012-06-01  4839) 		truncate_pagecache_range(inode, first_page_offset,
5e44f8c3 (Hugh Dickins      2012-06-01  4840) 					 last_page_offset - 1);
a4bb6b64 (Allison Henderson 2011-05-25  4841) 	}
a4bb6b64 (Allison Henderson 2011-05-25  4842) 
c6a59106 (Dmitry Monakhov   2012-09-29  4843) 	/* Wait all existing dio workers, newcomers will block on i_mutex */
c6a59106 (Dmitry Monakhov   2012-09-29  4844) 	ext4_inode_block_unlocked_dio(inode);
c6a59106 (Dmitry Monakhov   2012-09-29  4845) 	inode_dio_wait(inode);
d1579744 (Dmitry Monakhov   2012-09-29  4846) 	err = ext4_flush_completed_IO(inode);
d1579744 (Dmitry Monakhov   2012-09-29  4847) 	if (err)
c6a59106 (Dmitry Monakhov   2012-09-29  4848) 		goto out_dio;
a4bb6b64 (Allison Henderson 2011-05-25  4849) 
a4bb6b64 (Allison Henderson 2011-05-25  4850) 	credits = ext4_writepage_trans_blocks(inode);
a4bb6b64 (Allison Henderson 2011-05-25  4851) 	handle = ext4_journal_start(inode, credits);
c6a59106 (Dmitry Monakhov   2012-09-29  4852) 	if (IS_ERR(handle)) {
c6a59106 (Dmitry Monakhov   2012-09-29  4853) 		err = PTR_ERR(handle);
c6a59106 (Dmitry Monakhov   2012-09-29  4854) 		goto out_dio;
c6a59106 (Dmitry Monakhov   2012-09-29  4855) 	}
a4bb6b64 (Allison Henderson 2011-05-25  4856) 
a4bb6b64 (Allison Henderson 2011-05-25  4857) 
a4bb6b64 (Allison Henderson 2011-05-25  4858) 	/*
ba06208a (Allison Henderson 2011-09-03  4859) 	 * Now we need to zero out the non-page-aligned data in the
ba06208a (Allison Henderson 2011-09-03  4860) 	 * pages at the start and tail of the hole, and unmap the buffer
ba06208a (Allison Henderson 2011-09-03  4861) 	 * heads for the block aligned regions of the page that were
ba06208a (Allison Henderson 2011-09-03  4862) 	 * completely zeroed.
a4bb6b64 (Allison Henderson 2011-05-25  4863) 	 */
ba06208a (Allison Henderson 2011-09-03  4864) 	if (first_page > last_page) {
ba06208a (Allison Henderson 2011-09-03  4865) 		/*
ba06208a (Allison Henderson 2011-09-03  4866) 		 * If the file space being truncated is contained within a page
ba06208a (Allison Henderson 2011-09-03  4867) 		 * just zero out and unmap the middle of that page
ba06208a (Allison Henderson 2011-09-03  4868) 		 */
ba06208a (Allison Henderson 2011-09-03  4869) 		err = ext4_discard_partial_page_buffers(handle,
ba06208a (Allison Henderson 2011-09-03  4870) 			mapping, offset, length, 0);
ba06208a (Allison Henderson 2011-09-03  4871) 
ba06208a (Allison Henderson 2011-09-03  4872) 		if (err)
ba06208a (Allison Henderson 2011-09-03  4873) 			goto out;
ba06208a (Allison Henderson 2011-09-03  4874) 	} else {
ba06208a (Allison Henderson 2011-09-03  4875) 		/*
ba06208a (Allison Henderson 2011-09-03  4876) 		 * zero out and unmap the partial page that contains
ba06208a (Allison Henderson 2011-09-03  4877) 		 * the start of the hole
ba06208a (Allison Henderson 2011-09-03  4878) 		 */
ba06208a (Allison Henderson 2011-09-03  4879) 		page_len  = first_page_offset - offset;
ba06208a (Allison Henderson 2011-09-03  4880) 		if (page_len > 0) {
ba06208a (Allison Henderson 2011-09-03  4881) 			err = ext4_discard_partial_page_buffers(handle, mapping,
ba06208a (Allison Henderson 2011-09-03  4882) 						   offset, page_len, 0);
ba06208a (Allison Henderson 2011-09-03  4883) 			if (err)
ba06208a (Allison Henderson 2011-09-03  4884) 				goto out;
ba06208a (Allison Henderson 2011-09-03  4885) 		}
ba06208a (Allison Henderson 2011-09-03  4886) 
ba06208a (Allison Henderson 2011-09-03  4887) 		/*
ba06208a (Allison Henderson 2011-09-03  4888) 		 * zero out and unmap the partial page that contains
ba06208a (Allison Henderson 2011-09-03  4889) 		 * the end of the hole
ba06208a (Allison Henderson 2011-09-03  4890) 		 */
ba06208a (Allison Henderson 2011-09-03  4891) 		page_len = offset + length - last_page_offset;
ba06208a (Allison Henderson 2011-09-03  4892) 		if (page_len > 0) {
ba06208a (Allison Henderson 2011-09-03  4893) 			err = ext4_discard_partial_page_buffers(handle, mapping,
ba06208a (Allison Henderson 2011-09-03  4894) 					last_page_offset, page_len, 0);
ba06208a (Allison Henderson 2011-09-03  4895) 			if (err)
ba06208a (Allison Henderson 2011-09-03  4896) 				goto out;
a4bb6b64 (Allison Henderson 2011-05-25  4897) 		}
a4bb6b64 (Allison Henderson 2011-05-25  4898) 	}
a4bb6b64 (Allison Henderson 2011-05-25  4899) 
2be4751b (Allison Henderson 2011-09-03  4900) 	/*
2be4751b (Allison Henderson 2011-09-03  4901) 	 * If i_size is contained in the last page, we need to
2be4751b (Allison Henderson 2011-09-03  4902) 	 * unmap and zero the partial page after i_size
2be4751b (Allison Henderson 2011-09-03  4903) 	 */
2be4751b (Allison Henderson 2011-09-03  4904) 	if (inode->i_size >> PAGE_CACHE_SHIFT == last_page &&
2be4751b (Allison Henderson 2011-09-03  4905) 	   inode->i_size % PAGE_CACHE_SIZE != 0) {
2be4751b (Allison Henderson 2011-09-03  4906) 
2be4751b (Allison Henderson 2011-09-03  4907) 		page_len = PAGE_CACHE_SIZE -
2be4751b (Allison Henderson 2011-09-03  4908) 			(inode->i_size & (PAGE_CACHE_SIZE - 1));
2be4751b (Allison Henderson 2011-09-03  4909) 
2be4751b (Allison Henderson 2011-09-03  4910) 		if (page_len > 0) {
2be4751b (Allison Henderson 2011-09-03  4911) 			err = ext4_discard_partial_page_buffers(handle,
2be4751b (Allison Henderson 2011-09-03  4912) 			  mapping, inode->i_size, page_len, 0);
2be4751b (Allison Henderson 2011-09-03  4913) 
2be4751b (Allison Henderson 2011-09-03  4914) 			if (err)
2be4751b (Allison Henderson 2011-09-03  4915) 				goto out;
2be4751b (Allison Henderson 2011-09-03  4916) 		}
2be4751b (Allison Henderson 2011-09-03  4917) 	}
2be4751b (Allison Henderson 2011-09-03  4918) 
5f95d21f (Lukas Czerner     2012-03-19  4919) 	first_block = (offset + sb->s_blocksize - 1) >>
5f95d21f (Lukas Czerner     2012-03-19  4920) 		EXT4_BLOCK_SIZE_BITS(sb);
5f95d21f (Lukas Czerner     2012-03-19  4921) 	stop_block = (offset + length) >> EXT4_BLOCK_SIZE_BITS(sb);
5f95d21f (Lukas Czerner     2012-03-19  4922) 
a4bb6b64 (Allison Henderson 2011-05-25  4923) 	/* If there are no blocks to remove, return now */
5f95d21f (Lukas Czerner     2012-03-19  4924) 	if (first_block >= stop_block)
a4bb6b64 (Allison Henderson 2011-05-25  4925) 		goto out;
a4bb6b64 (Allison Henderson 2011-05-25  4926) 
a4bb6b64 (Allison Henderson 2011-05-25  4927) 	down_write(&EXT4_I(inode)->i_data_sem);
a4bb6b64 (Allison Henderson 2011-05-25  4928) 	ext4_ext_invalidate_cache(inode);
a4bb6b64 (Allison Henderson 2011-05-25  4929) 	ext4_discard_preallocations(inode);
a4bb6b64 (Allison Henderson 2011-05-25  4930) 
5f95d21f (Lukas Czerner     2012-03-19  4931) 	err = ext4_ext_remove_space(inode, first_block, stop_block - 1);
a4bb6b64 (Allison Henderson 2011-05-25  4932) 
5f95d21f (Lukas Czerner     2012-03-19  4933) 	ext4_ext_invalidate_cache(inode);
5f95d21f (Lukas Czerner     2012-03-19  4934) 	ext4_discard_preallocations(inode);
a4bb6b64 (Allison Henderson 2011-05-25  4935) 
a4bb6b64 (Allison Henderson 2011-05-25  4936) 	if (IS_SYNC(inode))
a4bb6b64 (Allison Henderson 2011-05-25  4937) 		ext4_handle_sync(handle);
a4bb6b64 (Allison Henderson 2011-05-25  4938) 
a4bb6b64 (Allison Henderson 2011-05-25  4939) 	up_write(&EXT4_I(inode)->i_data_sem);
a4bb6b64 (Allison Henderson 2011-05-25  4940) 
a4bb6b64 (Allison Henderson 2011-05-25  4941) out:
a4bb6b64 (Allison Henderson 2011-05-25  4942) 	inode->i_mtime = inode->i_ctime = ext4_current_time(inode);
a4bb6b64 (Allison Henderson 2011-05-25  4943) 	ext4_mark_inode_dirty(handle, inode);
a4bb6b64 (Allison Henderson 2011-05-25  4944) 	ext4_journal_stop(handle);
c6a59106 (Dmitry Monakhov   2012-09-29  4945) out_dio:
c6a59106 (Dmitry Monakhov   2012-09-29  4946) 	ext4_inode_resume_unlocked_dio(inode);
c6a59106 (Dmitry Monakhov   2012-09-29  4947) out_mutex:
c6a59106 (Dmitry Monakhov   2012-09-29  4948) 	mutex_unlock(&inode->i_mutex);
a4bb6b64 (Allison Henderson 2011-05-25 @4949) 	return err;
a4bb6b64 (Allison Henderson 2011-05-25  4950) }
6873fa0d (Eric Sandeen      2008-10-07  4951) int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
6873fa0d (Eric Sandeen      2008-10-07  4952) 		__u64 start, __u64 len)

The code at line 4949 was first introduced by commit:
a4bb6b6 ext4: enable "punch hole" functionality

---
0-DAY kernel build testing backend         Open Source Technology Centre
Fengguang Wu, Yuanhan Liu                              Intel Corporation
