From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [RESEND][PATCH][BUG] ext4: fix infinite loop at
 ext4_da_writepages with the terminal extent block of too big file
Date: Sat, 9 Oct 2010 18:16:23 -0400
Message-ID: <20101009221623.GA11237@thunk.org>
References: <20100917143556.bb9c303a.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:37986 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999Ab0JIWQ1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 9 Oct 2010 18:16:27 -0400
Content-Disposition: inline
In-Reply-To: <20100917143556.bb9c303a.toshi.okajima@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks, applied, with a slightly edited commit description.

		      		 	   	  - Ted

ext4: fix potential infinite loop in ext4_da_writepages()

From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>

On linux-2.6.36-rc2, if we execute the following script, we can hang
the system when the /bin/sync command is executed:

========================================================================
#!/bin/sh

echo -n "HANG UP TEST: "
/bin/dd if=/dev/zero of=/tmp/img bs=1k count=1 seek=1M 2> /dev/null
/sbin/mkfs.ext4 -Fq /tmp/img
/bin/mount -o loop -t ext4 /tmp/img /mnt
/bin/dd if=/dev/zero of=/mnt/file bs=1 count=1 \
seek=$((16*1024*1024*1024*1024-4096)) 2> /dev/null
/bin/sync
/bin/umount /mnt
echo "DONE"
exit 0
========================================================================

We can see the following backtrace if we get the kdump when this
hangup occurs:

======================================================================
kthread()
=> bdi_writeback_thread()
   => wb_do_writeback()
      => wb_writeback()
         => writeback_inodes_wb()
            => writeback_sb_inodes()
               => writeback_single_inode()
                  => ext4_da_writepages()  ---+ 
                                ^ infinite    |
                                |   loop      |
                                +-------------+
======================================================================

The reason why this hangup happens is described as follows:
1) We write the last extent block of the file whose size is the filesystem 
   maximum size.
2) "BH_Delay" flag is set on the buffer_head of its block.
3) - the member, "m_lblk" of struct mpage_da_data is 4294967295 (UINT_MAX)
   - the member, "m_len" of struct mpage_da_data is 1
  mpage_put_bnr_to_bhs() which is called via ext4_da_writepages()
  cannot clear "BH_Delay" flag of the buffer_head because the type of
  m_lblk is ext4_lblk_t and then m_lblk + m_len is overflow.

  Therefore an infinite loop occurs because ext4_da_writepages()
  cannot write the page (which corresponds to the block) since
  "BH_Delay" flag isn't cleared.
----------------------------------------------------------------------
static void mpage_put_bnr_to_bhs(struct mpage_da_data *mpd,
				struct ext4_map_blocks *map)
{
...
	int blocks = map->m_len;
...
		do {
			// cur_logical = 4294967295
			// map->m_lblk = 4294967295
			// blocks = 1
			// *** map->m_lblk + blocks == 0 (OVERFLOW!) ***
			// (cur_logical >= map->m_lblk + blocks) => true
			if (cur_logical >= map->m_lblk + blocks)
				break;
----------------------------------------------------------------------

NOTE: Mounting with the nodelalloc option will avoid this codepath,
and thus, avoid this hang

Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
