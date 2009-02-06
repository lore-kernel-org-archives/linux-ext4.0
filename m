From: "J.D. Bakker" <jdb@lartmaker.nl>
Subject: Recovering a damaged ext4 fs - revisited.
Date: Fri, 6 Feb 2009 04:06:38 +0100
Message-ID: <p06240517c5b14e12f7d1@[10.1.5.33]>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii" ; format="flowed"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.lartmaker.nl ([69.93.127.100]:50768 "EHLO www.lartmaker.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224AbZBFDyt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Feb 2009 22:54:49 -0500
Received: from bakker by www.lartmaker.nl with local (Exim 4.69)
	(envelope-from <bakker@lartmaker.nl>)
	id 1LVH3N-0005zA-Ds
	for linux-ext4@vger.kernel.org; Fri, 06 Feb 2009 04:06:53 +0100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

My 4TB ext4 RAID-6 has just become damaged for the second time in two 
months. While I do have backups for most of my data, it would be good 
to know if there is a recovery procedure or a way to avoid these 
crashes. The symptoms are massive group descriptor corruption, 
similar to what was mentioned in 
http://thread.gmane.org/gmane.comp.file-systems.ext4/10844 and 
http://article.gmane.org/gmane.comp.file-systems.ext4/11195 .

The bad news: on the first occurrence I didn't record any information 
but decided to zero the partitions and restart from scratch. This 
second time my kernel is tainted by the nvidia module (as I since 
switched to an nVidia 8500-card from the Radeon X1300 I'd borrowed to 
get the system up).

The machine is an Intel i720 on an Asus P6T with 3GB RAM, running 
2.6.28 x86_64. /dev/md0 is a RAID-6 over six 1TB drives. Details:

http://lartmaker.nl/ext4/kernel-config.txt
http://lartmaker.nl/ext4/dmesg.txt
http://lartmaker.nl/ext4/lspci.txt
http://lartmaker.nl/ext4/proc-mdstat.txt
http://lartmaker.nl/ext4/proc-partitions.txt

This afternoon I issued an rm on a file which was a few hundred MB 
large. The rm process kept running at 100% CPU for over a minute, and 
could not be terminated through either CTRL-C or kill -9 (process 
would remain in the 'R'-state). The kernel reported a soft lockup, 
with the following call trace:

   [<ffffffff8050f1b7>] ? _spin_lock+0x16/0x19
   [<ffffffff80308a23>] ? ext4_mb_init_cache+0x6d2/0x876
   [<ffffffff802754de>] ? __lru_cache_add+0x8a/0xb2
   [<ffffffff80308cd6>] ? ext4_mb_load_buddy+0x10f/0x2f2
   [<ffffffff80309d15>] ? ext4_mb_free_blocks+0x2b3/0x611
   [<ffffffff802f0aa8>] ? ext4_free_blocks+0x75/0xa8
   [<ffffffff80303839>] ? ext4_ext_truncate+0x3f9/0x832
   [<ffffffff802f848e>] ? ext4_truncate+0x67/0x5bc
   [<ffffffff80316279>] ? jbd2_journal_dirty_metadata+0x124/0x146
   [<ffffffff80305ba6>] ? __ext4_journal_dirty_metadata+0x1e/0x46
   [<ffffffff802f3e9b>] ? ext4_mark_iloc_dirty+0x3fa/0x463
   [<ffffffff802f4a81>] ? ext4_mark_inode_dirty+0x134/0x147
   [<ffffffff802f8b2b>] ? ext4_delete_inode+0x148/0x209
   [<ffffffff802f89e3>] ? ext4_delete_inode+0x0/0x209
   [<ffffffff802a7472>] ? generic_delete_inode+0x82/0x108
   [<ffffffff8029ff76>] ? do_unlinkat+0xe2/0x13b
   [<ffffffff8050f8ba>] ? error_exit+0x0/0x70
   [<ffffffff8020bf5a>] ? system_call_fastpath+0x16/0x1b

(full log at http://lartmaker.nl/ext4/softlock-log.txt).

The system was otherwise still responsive, as long as processes 
didn't access the ext4 fs on the RAID array. I tried to halt the 
system, which did not work. Finally I powered the machine down 
manually.

On reboot the system refused to auto-fsck /dev/md0. A manual e2fsck 
-nv /dev/md0 reported:

   e2fsck 1.41.4 (27-Jan-2009)
   ./e2fsck/e2fsck: Group descriptors look bad... trying backup blocks...
   Group descriptor 0 checksum is invalid.  Fix? no
   Group descriptor 1 checksum is invalid.  Fix? no
   Group descriptor 2 checksum is invalid.  Fix? no
   [...]
   Group descriptor 29808 checksum is invalid.  Fix? no
   newraidfs contains a file system with errors, check forced.
   Pass 1: Checking inodes, blocks, and sizes
   Pass 2: Checking directory structure
   Pass 3: Checking directory connectivity
   Pass 4: Checking reference counts
   Pass 5: Checking group summary information
   Block bitmap differences:  [...]
   Fix? no
   Free blocks count wrong for group #0 (23513, counted=464).
   Fix? no
   Free blocks count wrong for group #1 (31743, counted=509).
   Fix? no
   [...]
   Free inodes count wrong for group #7748 (8192, counted=940).
   Fix? no
   Directories count wrong for group #7748 (0, counted=1).
   Fix? no
   Free inodes count wrong for group #7749 (8192, counted=8059).
   Fix? no
   Free inodes count wrong (244195317, counted=237646747).
   Fix? no
   newraidfs: ***** FILE SYSTEM WAS MODIFIED *****
   newraidfs: ********** WARNING: Filesystem still has errors **********
         11 inodes used (0.00%)
      41796 non-contiguous files (379963.6%)
       3002 non-contiguous directories (27290.9%)
            # of inodes with ind/dind/tind blocks: 0/0/0
            Extent depth histogram: 4423417/4694/3
   15377150 blocks used (1.57%)
          0 bad blocks
        106 large files

    3738164 regular files
     685644 directories
       3663 character device files
       8709 block device files
         19 fifos
    2180635 links
      47335 symbolic links (43028 fast symbolic links)
         54 sockets
   --------
    6664223 files
   Error writing block 1 (Attempt to write block from filesystem 
resulted in short write).  Ignore error? no
   Error writing block 2 (Attempt to write block from filesystem 
resulted in short write).  Ignore error? no
   Error writing block 3 (Attempt to write block from filesystem 
resulted in short write).  Ignore error? no
   [...]
   Error writing block 231 (Attempt to write block from filesystem 
resulted in short write).  Ignore error? no
   Error writing block 232 (Attempt to write block from filesystem 
resulted in short write).  Ignore error? no

(full log at http://lartmaker.nl/ext4/e2fsck-md0.txt)

As suggested in the earlier threads I ran dumpe2fs; once without the 
-b option, once with -b 32768 and once with -b 98304:

http://lartmaker.nl/ext4/dumpe2fs-md0.txt
http://lartmaker.nl/ext4/dumpe2fs-md0-32768.txt
http://lartmaker.nl/ext4/dumpe2fs-md0-98304.txt

Output of findsuper:

http://lartmaker.nl/ext4/findsuper.txt

Please let me know if you need more information.

As I said, is there anything I can do to recover my data, or to make 
sure this doesn't happen again?

Thanks,

JDB.
-- 
LART. 250 MIPS under one Watt. Free hardware design files.
http://www.lartmaker.nl/
