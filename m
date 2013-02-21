From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH] ext4: fix overhead calculation in bigalloc filesystem (Re:
 ... )
Date: Thu, 21 Feb 2013 20:15:45 +0800
Message-ID: <20130221121545.GA30821@gmail.com>
References: <1361433665-16880-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:49619 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397Ab3BUMA6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Feb 2013 07:00:58 -0500
Received: by mail-pa0-f42.google.com with SMTP id kq12so4716046pab.15
        for <linux-ext4@vger.kernel.org>; Thu, 21 Feb 2013 04:00:57 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1361433665-16880-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 21, 2013 at 09:01:05AM +0100, Lukas Czerner wrote:
> ext4_has_free_clusters() should tell us whether there is enough free
> clusters to allocate, however number of free clusters in the file system
> is converted to blocks using EXT4_C2B() which is not only wrong use of
> the macro (we should have used EXT4_NUM_B2C) but it's also completely
> wrong concept since everything else is in cluster units.
> 
> Moreover when calculating number of root clusters we should be using
> macro EXT4_NUM_B2C() instead of EXT4_C2B() otherwise the result will
> usually be off by one.
> 
> As a result number of free clusters is much bigger than it should have
> been and ext4_has_free_clusters() would return 1 even if there is really
> not enough free clusters available.
> 
> Fix this by removing the EXT4_C2B() conversion of free clusters and
> using EXT4_NUM_B2C() when calculating number of root clusters. This bug
> affects number of xfstests tests covering file system ENOSPC situation
> handling. With this patch most of the ENOSPC problems with bigalloc file
> system disappear, especially the errors caused by delayed allocation not
> having enough space when the actual allocation is finally requested.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Great!  Thanks for fixing it.  After applied this patch, xfstests #15
with bigalloc and delalloc won't cause a failure.  You can add
Reviewed-and-tested-by: Zheng Liu <wenqing.lz@taobao.com>

BTW, xfstests (204, 219, 233, 235, 273, and 274) still cause failures in
my test environment, and I still get a warning message which looks like:

kernel: EXT4-fs (sda2): ext4_da_update_reserve_space: ino 3658, allocated 1
with only 0 reserved metadata blocks
kernel:
kernel: ------------[ cut here ]------------
kernel: WARNING: at fs/ext4/inode.c:362 ext4_da_update_reserve_space+0x10f/0x21b
[ext4]()
kernel: Hardware name: OptiPlex 780                 
kernel: Modules linked in: ext4 jbd2 crc16 cpufreq_ondemand ipv6 dm_mirror
dm_region_hash dm_log dm_mod parport_pc parport cspkr i2c_i801 i2c_core
serio_raw sg ehci_pci ehci_hcd button e1000e ext3 jbd sd_mod ahci libahci libata
scsi_mod uhci_hcd
kernel: Pid: 2628, comm: 2372.fsstress.b Tainted: G W    3.8.0+ #7
kernel: Call Trace:
kernel: [<ffffffff82031d68>] warn_slowpath_common+0x85/0x9d
kernel: [<ffffffff82031d9a>] warn_slowpath_null+0x1a/0x1c
kernel: [<ffffffffa0200240>] ext4_da_update_reserve_space+0x10f/0x21b [ext4]
kernel: [<ffffffffa02277cd>] ext4_ext_map_blocks+0xd83/0xf66 [ext4]
kernel: [<ffffffff820ba4a8>] ? release_pages+0x169/0x178
kernel: [<ffffffff820ba011>] ? pagevec_lookup_tag+0x25/0x2e
kernel: [<ffffffffa02018d3>] ? write_cache_pages_da+0x107/0x3c4 [ext4]
kernel: [<ffffffffa0200c36>] ext4_map_blocks+0x135/0x1ef [ext4]
kernel: [<ffffffffa0201451>] mpage_da_map_and_submit+0x111/0x3d8 [ext4]
kernel: [<ffffffffa0201f0e>] ext4_da_writepages+0x37e/0x526 [ext4]
kernel: [<ffffffff820b86d9>] do_writepages+0x20/0x29
kernel: [<ffffffff820b13da>] __filemap_fdatawrite_range+0x50/0x52
kernel: [<ffffffff820b19a5>] filemap_fdatawrite+0x1f/0x21
kernel: [<ffffffff820b19c4>] filemap_write_and_wait+0x1d/0x38
kernel: [<ffffffff820fc4a9>] do_vfs_ioctl+0x2db/0x47f
kernel: [<ffffffff820fc6ab>] sys_ioctl+0x5e/0x82
kernel: [<ffffffff82386942>] system_call_fastpath+0x16/0x1b
kernel: ---[ end trace d96610456f905628 ]---

It is easy to trigger this warning when running xfstests #127 or #225.

Moreover, it seems that there still has an improvement in
ext4_calculate_overhead().  I paste the patch here.

Regards,
                                                - Zheng

Subject: [PATCH] ext4: fix overhead calculation in bigalloc filesystem

From: Zheng Liu <wenqing.lz@taobao.com>

ext4_calculate_overhead() should compute the overhead and stash it in
sbi->s_overhead.  But we miss use EXT4_B2C() to calculate the number of
clusters before first_data_block and the number of journal blocks.  This
commit use EXT4_NUM_B2C() instead of EXT4_B2C() to calculate the
overhead.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 3d4fb81..6165558 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3219,7 +3219,7 @@ int ext4_calculate_overhead(struct super_block *sb)
 	/*
 	 * All of the blocks before first_data_block are overhead
 	 */
-	overhead = EXT4_B2C(sbi, le32_to_cpu(es->s_first_data_block));
+	overhead = EXT4_NUM_B2C(sbi, le32_to_cpu(es->s_first_data_block));
 
 	/*
 	 * Add the overhead found in each block group
@@ -3235,7 +3235,7 @@ int ext4_calculate_overhead(struct super_block *sb)
 	}
 	/* Add the journal blocks as well */
 	if (sbi->s_journal)
-		overhead += EXT4_B2C(sbi, sbi->s_journal->j_maxlen);
+		overhead += EXT4_NUM_B2C(sbi, sbi->s_journal->j_maxlen);
 
 	sbi->s_overhead = overhead;
 	smp_wmb();
-- 
1.7.12.rc2.18.g61b472e

