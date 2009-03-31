From: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Subject: [PATCH] check block device size on mount
Date: Tue, 31 Mar 2009 10:58:48 +0200
Message-ID: <49D1DB48.1020708@ph.tum.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020200060200070806030800"
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from hamlet.e18.physik.tu-muenchen.de ([129.187.154.223]:41906 "EHLO
	hamlet.e18.physik.tu-muenchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750754AbZCaI6u (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 31 Mar 2009 04:58:50 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020200060200070806030800
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Dear Ted,

the attached patch (against your ext4 tree) compares device and 
filesystem sizes and refuses to mount a filesystem that is larger than 
the underlying block device.  This is probably needed in the first place 
to make sure that there is a sane limit imposed by the block number 
range checks submitted by Aneesh and me.

Please take a close look at the code.  Although it works for me, I'm not 
sure whether this is the right way to do it.  I tried to work analogous 
to bio_check_eod()...

Kind regards,

Signed-off-by: Thiemo Nagel <thiemo.nagel@ph.tum.de>

P.S.:  This fixes errors of the kind shown below which I got when 
playing around with a loop mount of a truncated filesystem image.

[ 3009.577468] BUG: unable to handle kernel NULL pointer dereference at 
(null)
[ 3009.577499] IP: [<c01b88c9>] seq_escape+0x1b/0xba
[ 3009.577552] *pdpt = 000000001d5f8001 *pde = 0000000000000000
[ 3009.577583] Oops: 0000 [#1] PREEMPT SMP
[ 3009.577595] last sysfs file: 
/sys/devices/pci0000:00/0000:00:1d.0/usb1/1-1/power/autosuspend
[ 3009.577623] Modules linked in: usbhid crc16 cpufreq_stats 
cpufreq_ondemand cpufreq_userspace cpufreq_powersave acpi_cpufreq 
speedstep_lib freq_table toshiba loop snd_intel8x0 snd_ac97_codec 
ac97_bus snd_pcm snd_timer snd soundcore psmouse snd_page_alloc ipw2200 
libipw lib80211 toshiba_acpi rfkill backlight input_polldev battery ac 
button evdev ext3 jbd mbcache sd_mod ata_generic ata_piix libata 
ehci_hcd uhci_hcd e100 mii scsi_mod usbcore thermal processor fan 
thermal_sys [last unloaded: jbd2]
[ 3009.577908]
[ 3009.577933] Pid: 6128, comm: mount Tainted: G  R     W 
(2.6.29-rc7-dbg #1) TECRA A3X
[ 3009.577941] EIP: 0060:[<c01b88c9>] EFLAGS: 00010286 CPU: 0
[ 3009.577967] EIP is at seq_escape+0x1b/0xba
[ 3009.577991] EAX: dd0d3000 EBX: dd0d322b ECX: dec4c640 EDX: 00000000
[ 3009.577998] ESI: dec4c640 EDI: 00001000 EBP: dd593f04 ESP: dd593ee8
[ 3009.578022]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[ 3009.578024] Process mount (pid: 6128, ti=dd592000 task=dd482430 
task.ti=dd592000)
[ 3009.578024] Stack:
[ 3009.578024]  c03c3629 dec4c640 dec4c640 dd0d3221 df07a800 dec4c640 
de8129f0 dd593f14
[ 3009.578024]  c01b5da8 de8129c0 dec4c640 dd593f30 c01b6a9f de8129c0 
cf9e89a4 c0327880
[ 3009.578024]  dec4c640 de8129f0 dd593f6c c01b9086 00000400 b7fdf000 
dd50dd80 dec4c668
[ 3009.578024] Call Trace:
[ 3009.578024]  [<c01b5da8>] ? show_type+0x22/0x5a
[ 3009.578024]  [<c01b6a9f>] ? show_vfsmnt+0x61/0xc2
[ 3009.578024]  [<c01b9086>] ? seq_read+0x258/0x332
[ 3009.578024]  [<c01a22b9>] ? vfs_read+0x97/0x14e
[ 3009.578024]  [<c01b8e2e>] ? seq_read+0x0/0x332
[ 3009.578024]  [<c01a29c4>] ? sys_read+0x3d/0x61
[ 3009.578024]  [<c01031fb>] ? sysenter_do_call+0x12/0x3f
[ 3009.578024] Code: a2 bb 00 00 00 00 89 d8 83 c4 08 5b 5e 5f 5d c3 55 
89 e5 57 56 53 83 ec 10 89 45 e8 89 4d e4 89 c1 8b 00 8b 79 04 89 c3 03 
59 0c <0f> b6 0a 88 4d f3 84 c9 74 7e 01 f8 89 45 ec 39 d8 76 75 89 d7
[ 3009.578024] EIP: [<c01b88c9>] seq_escape+0x1b/0xba SS:ESP 0068:dd593ee8
[ 3009.584755] ---[ end trace 0355de9ee9334cfe ]---

--------------020200060200070806030800
Content-Type: text/x-patch;
 name="check-device-size.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="check-device-size.patch"

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 0328b9d..8b4eabe 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2543,6 +2543,15 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	if (EXT4_BLOCKS_PER_GROUP(sb) == 0)
 		goto cantfind_ext4;
 
+	/* check blocks count against device size */
+	blocks_count = sb->s_bdev->bd_inode->i_size >> sb->s_blocksize_bits;
+	if (blocks_count && ext4_blocks_count(es) > blocks_count) {
+		printk(KERN_WARNING "EXT4-fs: bad geometry: block count %llu "
+		       "exceeds size of device (%llu blocks)\n",
+		       ext4_blocks_count(es), blocks_count);
+		goto failed_mount;
+	}
+
         /*
          * It makes no sense for the first data block to be beyond the end
          * of the filesystem.

--------------020200060200070806030800--
