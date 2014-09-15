From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: mark_buffer_dirty WARN_ON_ONCE on buffer_uptodate
Date: Mon, 15 Sep 2014 21:56:44 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958C81B63@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"tytso@mit.edu" <tytso@mit.edu>,
	"adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
	"Jens Axboe <axboe@kernel.dk> (axboe@kernel.dk)" <axboe@kernel.dk>,
	Christoph Hellwig <hch@infradead.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:58664 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754984AbaIOV6p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Sep 2014 17:58:45 -0400
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Stress-testing blk-mq/scsi-mq (3.17rc4/blk-next), I was running 
fio + mkfs.ext4 + e2fsck to 16 mpt3sas devices and unplugged the 
JBOD containing the SAS SSDs.  This triggered lots of mpt3sas,
SCSI midlayer, and block layer error messages, as expected.
The linux device (/dev/sdc) does not disappear here; it just
starts generating errors for every IO.

After it triggered "Remounting filesystem read-only", a 
WARN_ON_ONCE triggered in mark_buffer_dirty in the filesystem
layer.  I don't know if that is expected/desired error handling 
behavior.

Kernel log excerpt:
...
[18075.539314] Buffer I/O error on dev sdk, logical block 0, lost sync page write
[18075.539333] EXT4-fs (sdk): previous I/O error to superblock detected
<presumably one of those also appeared for sdc, but it is no longer in the buffer>

...
[18156.572672] mpt3sas0: log_info(0x311201ff): originator(PL), code(0x12), sub_code(0x01ff)
[18156.572676] sd 0:0:2:0: timing out command, waited 0s
[18156.572680] Buffer I/O error on dev sdc, logical block 48791552, lost sync page write
[18156.572699] JBD2: Error -5 detected when updating journal superblock for sdc-8.
[18156.582177] sd 0:0:2:0: timing out command, waited 0s
[18156.583969] Buffer I/O error on dev sdc, logical block 0, lost sync page write
[18156.586107] mpt3sas0: log_info(0x311201ff): originator(PL), code(0x12), sub_code(0x01ff)
[18156.589136] EXT4-fs error (device sdc): ext4_journal_check_start:56: Detected aborted journal
[18156.589137] EXT4-fs (sdc): Remounting filesystem read-only
[18156.589142] ------------[ cut here ]------------
[18156.589146] WARNING: CPU: 1 PID: 3368 at fs/buffer.c:1139 mark_buffer_dirty+0xb5/0xd0()
[18156.589171] Modules linked in: ftdi_sio usbserial nfsd nfs_acl exportfs autofs4 rpcsec_gss_krb5 auth_rpcgss nfsv4 nfs fscache lockd sunrpc cpufrendemand pcc_cpufreq dm_mirror dm_region_hash dm_log uinput ipv6 iTCO_wdt iTCO_vendor_support microcode serio_raw pcspkr sb_edac edac_core hpilo hpwdt lpc_ich mfd_core ioatdma dca dm_mod wmi sg tg3 ptp pps_core ext4(E) jbd2(E) mbcache(E) sd_mod(E) crc_t10dif(E) crct10dif_common(E) pata_acpi(E) ata_generic(E) ata_piix(E) hpsa(E) mpt3sas(E) scsi_transport_sas(E) raid_class(E)
[18156.589174] CPU: 1 PID: 3368 Comm: ddpt Tainted: G        W   EL 3.17.0-rc4+ #3
[18156.589175] Hardware name: HP ProLiant DL380p Gen8, BIOS P70 09/08/2013
[18156.589177]  0000000000000473 ffff8800b777b9f8 ffffffff815a8b3f 0000000000000473
[18156.589179]  0000000000000000 ffff8800b777ba38 ffffffff8105267c ffffffff8181c8fa
[18156.589181]  ffff88037afd5800 ffff8803537cdd28 ffff8803ddda2400 0000000000000001
[18156.589182] Call Trace:
[18156.589186]  [<ffffffff815a8b3f>] dump_stack+0x49/0x62
[18156.589189]  [<ffffffff8105267c>] warn_slowpath_common+0x8c/0xc0
[18156.589191]  [<ffffffff810526ca>] warn_slowpath_null+0x1a/0x20
[18156.589193]  [<ffffffff811cc0b5>] mark_buffer_dirty+0xb5/0xd0
[18156.589205]  [<ffffffffa00d8a9a>] ext4_commit_super+0x18a/0x250 [ext4]
[18156.589215]  [<ffffffffa00d93c3>] save_error_info+0x23/0x30 [ext4]
[18156.589223]  [<ffffffffa00d9a6e>] __ext4_abort+0x10e/0x130 [ext4]
[18156.589226]  [<ffffffff815a93f9>] ? _cond_resched+0x9/0x40
[18156.589234]  [<ffffffffa00c638a>] ? ext4_da_write_begin+0x19a/0x2b0 [ext4]
[18156.589244]  [<ffffffffa00f0f88>] ext4_journal_check_start+0x68/0x90 [ext4]
[18156.589253]  [<ffffffffa00f13f1>] __ext4_journal_start_sb+0x41/0xf0 [ext4]
[18156.589261]  [<ffffffffa00c638a>] ext4_da_write_begin+0x19a/0x2b0 [ext4]
[18156.589265]  [<ffffffff8115d5dd>] ? iov_iter_fault_in_readable+0xd/0x80
[18156.589268]  [<ffffffff8113554a>] generic_perform_write+0xca/0x1c0
[18156.589270]  [<ffffffff815aef5d>] ? ftrace_call+0x5/0x2f
[18156.589273]  [<ffffffff811384ef>] __generic_file_write_iter+0x18f/0x390
[18156.589280]  [<ffffffffa00bcc19>] ext4_file_write_iter+0x109/0x420 [ext4]
[18156.589]  [<ffffffff8115d219>] ? iov_iter_init+0x9/0x40
[18156.589286]  [<ffffffff811996a2>] new_sync_write+0x92/0xd0
[18156.589289]  [<ffffffff81199bbe>] vfs_write+0xce/0x180
[18156.589291]  [<ffffffff8119a1fa>] SyS_write+0x5a/0xd0
[18156.589294]  [<ffffffff815ad152>] system_call_fastpath+0x16/0x1b
[18156.589296] ---[ end trace 72065e1b51c7c1cb ]---


That's apparently from this function:

static int ext4_commit_super(struct super_block *sb, int sync)
{
...
        if (!sbh || block_device_ejected(sb))
                return error;
        if (buffer_write_io_error(sbh)) {
                /*
                 * Oh, dear.  A previous attempt to write the
                 * superblock failed.  This could happen because the
                 * USB device was yanked out.  Or it could happen to
                 * be a transient write error and maybe the block will
                 * be remapped.  Nothing we can do but to retry the
                 * write and hope for the best.
                 */
                ext4_msg(sb, KERN_ERR, "previous I/O error to "
                       "superblock detected");
                clear_buffer_write_io_error(sbh);
                set_buffer_uptodate(sbh);
        }
...
        /*
         * If the file system is mounted read-only, don't update the
         * superblock write time.  This avoids updating the superblock
         * write time when we are mounting the root file system
         * read/only but we need to replay the journal; at that point,
         * for people who are east of GMT and who make their clock
         * tick in localtime for Windows bug-for-bug compatibility,
         * the clock is set in the future, and this will cause e2fsck
         * to complain and force a full file system check.
         */
...
        BUFFER_TRACE(sbh, "marking dirty");
        ext4_superblock_csum_set(sb);
        mark_buffer_dirty(sbh);
...

void mark_buffer_dirty(struct buffer_head *bh)
{
        WARN_ON_ONCE(!buffer_uptodate(bh));


---
Rob Elliott    HP Server Storage


