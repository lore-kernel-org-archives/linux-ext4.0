From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: Exposes stale data in ext4 data=ordered + delalloc
Date: Mon, 11 Apr 2016 00:18:35 +0000
Message-ID: <C26C67884C4B7A48980D57463559486403296680@BPXM20GP.gisp.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "tytso@mit.edu" <tytso@mit.edu>,
	"adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO200.gate.nec.co.jp ([210.143.35.50]:47711 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbcDKATt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 10 Apr 2016 20:19:49 -0400
Received: from tyo202.gate.nec.co.jp ([10.7.69.202])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id u3B0Jkah007566
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 11 Apr 2016 09:19:46 +0900 (JST)
Content-Language: ja-JP
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

I found the security problem that exposes stale data in ext4 data=ordered
when the power failure occurred during ext4_writepages(). This problem can be
reproduced in linux-4.5.

Steps to reproduce:
(1) Create 2GB file filled up with the character 'Z' and remove the file.
    It means that all the data blocks in ext4 is filled up with 'Z'.

    # mkfs -t ext4 /dev/sdb1 2G
    # mount /dev/sdb1 /mnt/mp1
    # xfs_io -f -c "pwrite -b 1M -S 0x5A5A5A5A 0 2G" /mnt/mp1/filldata
    # sync
    # rm -f /mnt/mp1/filldata
    # sync

(2) Do force reboot (sysrq + b) during creating six files filled up with
    the character 'A' in parallel.

    # for i in {1..6} ; do \
      xfs_io -f -c "pwrite -b 1M -S 0x41414141 0 300M" /mnt/mp1/file$i & \
      done
    # sleep 10
    # echo b > /proc/sysrq-trigger

(3) After force reboot, when you read the file created by (2), sometimes
    you can see the character 'Z' which is written in the removed file by (1).

    # hexdump -C /mnt/mp1/file1 | tail
    00000000  41 41 41 41 41 41 41 41  41 41 41 41 41 41 41 41  |AAAAAAAAAAAAAAAA|
    *
    0ec00000  5a 5a 5a 5a 5a 5a 5a 5a  5a 5a 5a 5a 5a 5a 5a 5a  |ZZZZZZZZZZZZZZZZ|
    *

Without the following patch, ext4 will achieve data=ordered guarantees.

ext4: remove calls to ext4_jbd2_file_inode() from delalloc write path
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=f3b59291a69d0b734be1fc8be489fef2dd846d3d

Primarily, ext4 writepages operation calls ext4_jbd2_file_inode()
to submit data buffers to disk before committing transaction.
But the above patch makes ext4_writepages() not calling ext4_jbd2_file_inode().
Due to this change, it is possible to precede metadata
in the following power failure case (*):

ext4_writepages
  +- ext4_journal_start_with_reserve
  +- mpage_map_and_submit_extent
  |  |- mpage_map_one_extent
  |  |  |- ext4_map_blocks
  |  |- ext4_mark_inode_dirty
  |
  +- ext4_journal_stop
  |
  | (*) If jbd2_journal_commit_transaction() is called, commit above transaction
  |     with updating extents and file size. And then, power failure occurred
  |     before/during submitting data buffers.
  |
  +- ext4_io_submit

Note that stale data exposure is not happened when writing data into
allocated blocks, but happened when writing data into new blocks.
In ext4, whenever allocating a new block with non-aligned data,
the remaining region is zeroed out. Therefore, if metadata is updated
but corresponding file data is not written in an allocated block,
you can only see the zeroed data which is not the stale data.

I think this work is not data=ordered behavior that prevents
stale data exposure. Is this right?

Regards,
Kazuya Mio

