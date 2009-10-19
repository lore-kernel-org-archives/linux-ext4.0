From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: donor file data inconsistent after EXT4_IOC_MOVE_EXT
Date: Mon, 19 Oct 2009 09:40:37 +0900
Message-ID: <4ADBB585.7050402@rs.jp.nec.com>
References: <4ADABDB2.6080905@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Kazuya Mio <k-mio@sx.jp.nec.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: Peng Tao <bergwolf@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:57411 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698AbZJSAl0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 18 Oct 2009 20:41:26 -0400
In-Reply-To: <4ADABDB2.6080905@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Peng,

This is a known issue, and I sent a patch to linux-ext4 2 weeks ago.
Unfortunately it is not included in the ext4 patch queue yet.

http://marc.info/?l=linux-ext4&m=125447192709338&w=2

Would you retry your test case with above my patch?

Regards,
Akira Fujita

Peng Tao wrote:
> Hi,
> 
> As I am looking more closely to the EXT4_IOC_MOVE_EXT ioctl, I found a
> problem. The iotcl exchanges the block layout of the orig file and donor file
> and then writes out orig file data to orig file's new blocks.
> After the ioctl, the donor file would have the blocks previously owned by the
> orig file. But it turns out inconsistent.
> 
> A simple test case for revealing the bug:
> The program a.out is calling EXT4_IOC_MOVE_EXT against argv[1] (as orig file)
> and argv[2] (as donor file) and move_data.len = argv[1]'s block count.
> 
> And I am running mainline kernel 2.6.32-rc3 and the ext4 partition is mounted
> in ordered mode with default settings, if you are interested.
> 
> [bergwolf@move_extent]$sh test-5.sh 
> make full-img
> ========create full.img========
> dd if=/home/bergwolf/vm/OpenSolaris200805.iso of=full-1.img bs=1M count=30
> 30+0 records in
> 30+0 records out
> 31457280 bytes (31 MB) copied, 0.0847457 s, 371 MB/s
> dd if="/home/bergwolf/vm/WINXP_EN_PRO_SP3_MSDN/WinXp+Sp3 enu.iso" of=full-2.img bs=1M count=30
> 30+0 records in
> 30+0 records out
> 31457280 bytes (31 MB) copied, 0.0664263 s, 474 MB/s
> md5sum full-1.img full-2.img
> 4f47bee75290d094c94f8a7cb2075c69  full-1.img
> 9e35330146a610d0aa2fab1d16aa2b09  full-2.img
> ./a.out full-1.img full-2.img
> md5sum full-1.img full-2.img
> 4f47bee75290d094c94f8a7cb2075c69  full-1.img
> 9e35330146a610d0aa2fab1d16aa2b09  full-2.img		<---- wrong content
> [bergwolf@move_extent]$cd
> [bergwolf@~]$sudo umount /other/
> [bergwolf@~]$sudo mount /other/
> [bergwolf@~]$cd -
> /other/test/move_extent
> [bergwolf@move_extent]$md5sum full-1.img full-2.img 
> 4f47bee75290d094c94f8a7cb2075c69  full-1.img
> 4f47bee75290d094c94f8a7cb2075c69  full-2.img		<---- right result
> 
> I verified that the bug is because of the pagecache hit in the  vfs_read(), 
> via the following test case:
> 
> [bergwolf@move_extent]$sudo sh test-4.sh 
> make full-img
> ========create full.img========
> dd if=/home/bergwolf/vm/OpenSolaris200805.iso of=full-1.img bs=1M count=30
> 30+0 records in
> 30+0 records out
> 31457280 bytes (31 MB) copied, 0.115624 s, 272 MB/s
> dd if="/home/bergwolf/vm/WINXP_EN_PRO_SP3_MSDN/WinXp+Sp3 enu.iso" of=full-2.img bs=1M count=30
> 30+0 records in
> 30+0 records out
> 31457280 bytes (31 MB) copied, 1.16482 s, 27.0 MB/s
> md5sum full-1.img full-2.img
> 4f47bee75290d094c94f8a7cb2075c69  full-1.img
> 9e35330146a610d0aa2fab1d16aa2b09  full-2.img
> sync
> echo 1 > /proc/sys/vm/drop_caches	<------- this drops all pagecaches, FYI
> ./a.out full-1.img full-2.img
> md5sum full-1.img full-2.img
> 4f47bee75290d094c94f8a7cb2075c69  full-1.img
> 4f47bee75290d094c94f8a7cb2075c69  full-2.img
> 
> IIUC, this is because pagecache not uptodate.  FWIW, EXT4_IOC_MOVE_EXT
> calls ext4_ext_invalidate_cache() to prevent later access to donor file reading
> old data. But if the data is already in the pagecache (in which case,
> ext4_get_blocks() won't be called), vfs_read will still read the old data.
> But I don't know if there is a way to discard all pagecache for a specific
> inode. I tried to write something similar to ext4_da_block_invalidatepages()
> and ClearPageUptodate() on each page found in the mapping address,
> but it didn't work.
> 
> So am I missing anything? And any hints how to force the following vfs_read()
> to read from disk?
> 
