From: Matthew Wilcox <willy@linux.intel.com>
Subject: Race affecting superblock buffer_head
Date: Wed, 2 Apr 2014 10:07:57 -0400
Message-ID: <20140402140757.GE5667@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:16990 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932072AbaDBOH7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Apr 2014 10:07:59 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


If one enables enough of the kernel machinery to run xfstests shared/305
against ext4, it becomes remarkably easy to trigger WARNINGs and other
tombstone generators.  For those not familiar, shared/305 is:

# Run fsstress and fio(dio/aio and mmap) and simulate disk failure
# check filesystem consistency at the end.

It uses the fail_make_request feature to simulate the disk failures.
I'm testing with -o dax which appears to make errors even easier to hit
since all user accesses bypass the BIO code, so the only requests which
get failed are metadata I/Os.

Certainly we need to be spamming the syslog with information to let the
admin know that they are losing data, but it's clear that we're also
hitting logic errors.

For example:

        if (ext4_handle_valid(handle)) {
                err = jbd2_journal_dirty_metadata(handle, bh);
                /* Errors can only happen if there is a bug */
                if (WARN_ON_ONCE(err)) {

The comment appears to be untrue ... we can also get errors back when
dealing with faulty media.

Here's the current one puzzling me.  We're hitting this warning in fs/buffer.c:

void mark_buffer_dirty(struct buffer_head *bh)
{
        WARN_ON_ONCE(!buffer_uptodate(bh));

Looking at the backtrace (below), this is being called from
ext4_commit_super().  But ext4_commit_super() is pretty careful to set
buffer_uptodate before it calls mark_buffer_dirty:

        if (buffer_write_io_error(sbh)) {
                ext4_msg(sb, KERN_ERR, "previous I/O error to "
                       "superblock detected");
                clear_buffer_write_io_error(sbh);
                set_buffer_uptodate(sbh);
        }

and as you can see in the log, we print that ext4_msg().

So I'm forced to surmise that there's a race where buffer_uptodate is
getting cleared between that call to set_buffer_uptodate() and the call
to mark_buffer_dirty().

Looking forther down the call stack, this call to ext4_commit_super()
comes via __ext4_abort's call to save_error_info() which calls
ext4_commit_super().  I've had a good look around, and I can't see any
locking that prevents ext4_commit_super() from being called in parallel
with ... well, anything else.  But I also have proven ad nauseam that I
don't understand the buffer cache, so I'm not quite clear on what it's
racing with that is causing uptodate to get cleared.

So I don't know how to fix this warning.  I'll send a couple of other
patches along in a minute to eliminate a couple of other problems
I've hit.

(I'm using the prd driver in this instance, but it's equally reproducible
with brd).

[60067.854909] EXT4-fs (pmem1): mounted filesystem with ordered data mode. Opts:
 acl,user_xattr,dax
[60097.875628] quiet_error: 276 callbacks suppressed
[60097.875633] Buffer I/O error on device pmem1, logical block 275784
[60097.875635] lost page write due to I/O error on pmem1
[60097.876591] Aborting journal on device pmem1-8.
[60097.876597] Buffer I/O error on device pmem1, logical block 262144
[60097.876599] lost page write due to I/O error on pmem1
[60097.876601] JBD2: Error -5 detected when updating journal superblock for pmem
1-8.
[60097.876954] Buffer I/O error on device pmem1, logical block 0
[60097.876955] lost page write due to I/O error on pmem1
[60097.876957] EXT4-fs error (device pmem1): ext4_journal_check_start:56: Detected aborted journal
[60097.876961] EXT4-fs (pmem1): Remounting filesystem read-only
[60097.876962] EXT4-fs (pmem1): previous I/O error to superblock detected
[60097.876964] Buffer I/O error on device pmem1, logical block 0
[60097.876965] lost page write due to I/O error on pmem1
[60097.876973] ------------[ cut here ]------------
[60097.876981] WARNING: CPU: 3 PID: 19340 at fs/buffer.c:1166 mark_buffer_dirty+0x16c/0x180()
[60097.876983] Modules linked in: dm_mod prd bnep rfcomm
[60097.876993] EXT4-fs (pmem1): I/O error while writing superblock
[60097.876993]  bluetooth 6lowpan_iphc rfkill binfmt_misc nfsd
[60097.876999] EXT4-fs error (device pmem1): ext4_journal_check_start:56:  auth_rpcgss oid_registry nfs_acl
[60097.877004] Detected aborted journal nfs lockd fscache
[60097.877009] 
[60097.877009]  sunrpc fuse loop ppdev lp iTCO_wdt iTCO_vendor_support snd_hda_codec_realtek snd_hda_codec_generic snd_hda_codec_hdmi hid_generic usbhid hid psmouse i2c_i801 pcspkr serio_raw evdev lpc_ich mfd_core mei_me mei snd_hda_intel parport_pc parport snd_hda_codec snd_hwdep i915 snd_pcm snd_seq snd_seq_device video snd_timer i2c_algo_bit drm_kms_helper drm snd i2c_core soundcore button processor ext4 crc16 mbcache jbd2 sg sd_mod crc_t10dif crct10dif_common ahci libahci libata e1000e scsi_mod xhci_hcd ptp ehci_pci ehci_hcd usbcore usb_common pps_core fan thermal thermal_sys
[60097.877062] CPU: 3 PID: 19340 Comm: fio Not tainted 3.14.0-rc7+ #38
[60097.877064] Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./Q87M-D2H, BIOS F6 08/03/2013
[60097.877065]  0000000000000009 ffff8800a357fa88 ffffffff8158d26e 0000000000000000
[60097.877071]  ffff8800a357fac0 ffffffff8106dc3d 00000000000186cd ffff8802256e7920
[60097.877076]  ffff88021a00a400 0000000000000000 ffff880235506000 ffff8800a357fad0
[60097.877080] Call Trace:
[60097.877085]  [<ffffffff8158d26e>] dump_stack+0x4d/0x66
[60097.877089]  [<ffffffff8106dc3d>] warn_slowpath_common+0x7d/0xa0
[60097.877091]  [<ffffffff8106dd1a>] warn_slowpath_null+0x1a/0x20
[60097.877095]  [<ffffffff812187fc>] mark_buffer_dirty+0x16c/0x180
[60097.877116]  [<ffffffffa01ce3d6>] ext4_commit_super+0x176/0x230 [ext4]
[60097.877118] Buffer I/O error on device pmem1, logical block 51331
[60097.877120] lost page write due to I/O error on pmem1
[60097.877123] Buffer I/O error on device pmem1, logical block 1838
[60097.877125] lost page write due to I/O error on pmem1
[60097.877128] Buffer I/O error on device pmem1, logical block 650
[60097.877139]  [<ffffffffa01cecec>] __ext4_abort+0x3c/0x130 [ext4]
[60097.877141] lost page write due to I/O error on pmem1
[60097.877144] Buffer I/O error on device pmem1, logical block 20040
[60097.877145] lost page write due to I/O error on pmem1
[60097.877148] Buffer I/O error on device pmem1, logical block 105718
[60097.877157]  [<ffffffffa01b568a>] ? ext4_dirty_inode+0x2a/0x60 [ext4]
[60097.877159] lost page write due to I/O error on pmem1
[60097.877172]  [<ffffffffa01e01bd>] ext4_journal_check_start+0x8d/0xb0 [ext4]
[60097.877185]  [<ffffffffa01e0246>] __ext4_journal_start_sb+0x36/0x1a0 [ext4]
[60097.877186] Buffer I/O error on device pmem1, logical block 614
[60097.877189] lost page write due to I/O error on pmem1
[60097.877199]  [<ffffffffa01b568a>] ext4_dirty_inode+0x2a/0x60 [ext4]
[60097.877202]  [<ffffffff812100c2>] __mark_inode_dirty+0xc2/0x420
[60097.877213]  [<ffffffffa01aefa0>] ? _ext4_get_block+0x1b0/0x1b0 [ext4]
[60097.877217]  [<ffffffff811fdda1>] update_time+0x81/0xd0
[60097.877221]  [<ffffffff811fdfb0>] file_update_time+0x80/0xd0
[60097.877224]  [<ffffffff81239336>] dax_fault+0x46/0x70
[60097.877235]  [<ffffffffa01a7825>] ext4_dax_fault+0x15/0x20 [ext4]
[60097.877239]  [<ffffffff81195eed>] __do_fault+0x3d/0xa0
[60097.877242]  [<ffffffff810afd35>] ? local_clock+0x25/0x30
[60097.877244]  [<ffffffff81196785>] do_shared_fault.isra.56+0x35/0x1e0
[60097.877247]  [<ffffffff8119a6ff>] handle_mm_fault+0x2bf/0xfe0
[60097.877251]  [<ffffffff810c6597>] ? __lock_is_held+0x57/0x80
[60097.877254]  [<ffffffff81599cf6>] __do_page_fault+0x186/0x570
[60097.877257]  [<ffffffff810c545d>] ? trace_hardirqs_on+0xd/0x10
[60097.877261]  [<ffffffff815951a7>] ? _raw_spin_unlock+0x27/0x40
[60097.877266]  [<ffffffff81316d6a>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[60097.877268]  [<ffffffff8159a102>] do_page_fault+0x22/0x30
[60097.877272]  [<ffffffff81596338>] page_fault+0x28/0x30
[60097.877274] ---[ end trace 3dae036e7aa48cdb ]---
[60097.877279] EXT4-fs error (device pmem1): ext4_journal_check_start:56: Detected aborted journal
[60098.417278] EXT4-fs warning (device pmem1): ext4_end_bio:317: I/O error -5 writing to inode 29901 (offset 0 size 0 starting block 44122)

