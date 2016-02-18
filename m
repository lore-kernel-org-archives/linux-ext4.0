From: "Dilger, Andreas" <andreas.dilger@intel.com>
Subject: problem in ext2fs_get_next_inode_full() ?
Date: Thu, 18 Feb 2016 22:05:44 +0000
Message-ID: <D2EB8E48.12F559%andreas.dilger@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:56403 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423513AbcBRWFq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Feb 2016 17:05:46 -0500
Content-Language: en-US
Content-ID: <79B3B3F8F68B634684F26641A23F7ECB@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I was just looking at ext2fs_get_next_inode_full() to trace where we
are using large inodes and whether we could change the APIs to just
pass large inodes around instead of typecasting them.  It has the
following hunk of code:

        if (extra_bytes) {
		memcpy(scan->temp_buffer+extra_bytes, scan->ptr,
		       scan->inode_size - extra_bytes);
		scan->ptr += scan->inode_size - extra_bytes;
		scan->bytes_left -= scan->inode_size - extra_bytes;

#ifdef WORDS_BIGENDIAN
		memset(inode, 0, bufsize);
		ext2fs_swap_inode_full(scan->fs,
				(struct ext2_inode_large *) inode,
				(struct ext2_inode_large *) scan->temp_buffer,
				0, bufsize);
#else
		*inode = *((struct ext2_inode *) scan->temp_buffer);
#endif

So if the inode is being swabbed then it handles the full inode size, but
if it is not being swabbed (the common case) it appears that it is only
copying the small inode into "*inode" using a struct assignment.  This
appears like it would be dropping the large inode data, but I'm not sure
if or when this "extra_bytes" case is hit.  The "else" clause appears to
copy the requested (full) inode size properly via "memcpy(..., bufsize)".

Should the struct assignment be changed similarly to use memcpy()?


Cheers, Andreas
-- 
Andreas Dilger

Lustre Principal Architect
Intel High Performance Data Division


