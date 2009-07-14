From: Jan Kara <jack@suse.cz>
Subject: Re: quick question on journal_checksum
Date: Tue, 14 Jul 2009 20:52:41 +0200
Message-ID: <20090714185241.GA30638@atrey.karlin.mff.cuni.cz>
References: <7284e2210906121115r14c1cd52xa23a072009349759@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="gBBFr7Ir9EOA20Yy"
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Doug Hunley <doug@hunley.homeip.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60038 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbZGNSwm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Jul 2009 14:52:42 -0400
Content-Disposition: inline
In-Reply-To: <7284e2210906121115r14c1cd52xa23a072009349759@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

  Hi,

> If one specifies journal_checksum as a mount option for an ext4
> rootfs, it should show up in the output of 'mount', yes? I'm not
> seeing it.
> 
> My grub line:
> kernel /boot/vmlinuz-2.6.30-gentoo-r1 rw vga=0x31B
> video=vesafb:1280x1024-24,mtrr:3,ywrap hpet=force fastboot quiet
> forcedeth.msi=1 forcedeth.msix=1 forcedeth.dma_64bit=1 root=/dev/md3
> rootfstype=ext4 rootflags=journal_checksum
> 
> and the 'mount' output:
> rootfs on / type rootfs (rw)
> /dev/root on / type ext4 (rw,relatime,barrier=1,data=writeback)
> 
> Is this related to barriers failing? From dmesg:
> JBD: barrier-based sync failed on md3:8 - disabling barriers
  This is unrelated. It's a bug in how ext4 shows options in
/proc/mounts. Attached patch should fix it. Ted, will you merge it
please?

							Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs

--gBBFr7Ir9EOA20Yy
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-ext4-Show-journal_checksum-option.patch"

>From 8ce9bf5627f0f4257d87a500594ebc1368fdd630 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 14 Jul 2009 20:37:30 +0200
Subject: [PATCH] ext4: Show journal_checksum option

We failed to show journal_checksum option in /proc/mounts. Fix it.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/super.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 8f4f079..04fdaf1 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -846,6 +846,8 @@ static int ext4_show_options(struct seq_file *seq, struct vfsmount *vfs)
 	seq_puts(seq, test_opt(sb, BARRIER) ? "1" : "0");
 	if (test_opt(sb, JOURNAL_ASYNC_COMMIT))
 		seq_puts(seq, ",journal_async_commit");
+	else if (test_opt(sb, JOURNAL_CHECKSUM))
+		seq_puts(seq, ",journal_checksum");
 	if (test_opt(sb, NOBH))
 		seq_puts(seq, ",nobh");
 	if (test_opt(sb, I_VERSION))
-- 
1.6.0.2


--gBBFr7Ir9EOA20Yy--
