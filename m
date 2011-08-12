From: Jan Kara <jack@suse.cz>
Subject: Re: DIO process stuck apparently due to dioread_nolock (3.0)
Date: Fri, 12 Aug 2011 15:07:29 +0200
Message-ID: <20110812130729.GC28324@quack.suse.cz>
References: <4E4262A5.6030903@msgid.tls.msk.ru>
 <20110811115943.GF4755@quack.suse.cz>
 <4E43C956.3060507@msgid.tls.msk.ru>
 <20110811140101.GA18802@quack.suse.cz>
 <4E4435F4.6000406@msgid.tls.msk.ru>
 <CAFgt=MCgfN-6_uBm=pDaeLqJKJQkSHry91XbYwWq=iBXip3D-w@mail.gmail.com>
 <4E44C6ED.2030506@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="y0ulUmNC+osPPQO6"
Cc: Jiaying Zhang <jiayingz@google.com>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56103 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271Ab1HLNHb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 12 Aug 2011 09:07:31 -0400
Content-Disposition: inline
In-Reply-To: <4E44C6ED.2030506@msgid.tls.msk.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri 12-08-11 10:23:41, Michael Tokarev wrote:
> 12.08.2011 06:46, Jiaying Zhang wrote:
> > Hi Michael,
> > 
> > Could you try your test with the patch I just posted:
> > http://marc.info/?l=linux-ext4&m=131311627101278&w=2
> > and see whether it fixes the problem?
> 
> No it does not.  I'm now able to trigger it more or
> less reliable - I need to decompress a relatively
> small (about 70Gb) oracle database and try to start
> it (this requires a rebuild of initrd and reboot ofcourse --
> whole thing takes about 15 minutes) - and I see this:
> 
> [  945.729965] EXT4-fs (sda11): Unaligned AIO/DIO on inode 5767175 by oracle; performance will be poor.
> [  960.915602] SysRq : Show Blocked State
> [  960.915650]   task                        PC stack   pid father
> [  960.915852] oracle          D 0000000000000000     0  4985      1 0x00000000
> [  960.915909]  ffff88103e627040 0000000000000082 ffff881000000000 ffff881078e3f7d0
> [  960.917855]  ffff88103f88ffd8 ffff88103f88ffd8 ffff88103f88ffd8 ffff88103e627040
> [  960.917953]  0000000001c08400 ffff88203e98c948 ffff88207873e240 ffffffff813527c6
> [  960.918045] Call Trace:
> [  960.918092]  [<ffffffff813527c6>] ? printk+0x43/0x48
> [  960.918153]  [<ffffffffa01432a8>] ? ext4_msg+0x58/0x60 [ext4]
> [  960.918201]  [<ffffffffa0123e6d>] ? ext4_file_write+0x20d/0x260 [ext4]
> [  960.918252]  [<ffffffff8106aee0>] ? abort_exclusive_wait+0xb0/0xb0
> [  960.918301]  [<ffffffffa0123c60>] ? ext4_llseek+0x120/0x120 [ext4]
> [  960.918348]  [<ffffffff81162173>] ? aio_rw_vect_retry+0x73/0x1d0
> [  960.918392]  [<ffffffff8116302f>] ? aio_run_iocb+0x5f/0x160
> [  960.918436]  [<ffffffff81164258>] ? do_io_submit+0x4f8/0x600
> [  960.918483]  [<ffffffff81359b52>] ? system_call_fastpath+0x16/0x1b
> 
> (Inum 5767175 is one of oracle redologs).
> 
> Jan, I lied to you initially - I didn't even test your first patch,
> because I loaded the wrong initrd.  With it applied, situation does
> not improve still, and it looks exactly the same as with this new
> patch by Jiaying Zhang:
> 
> [  415.288104] EXT4-fs (sda11): Unaligned AIO/DIO on inode 5767177 by oracle; performance will be poor.
> [  422.967323] SysRq : Show Blocked State
> [  422.967494]   task                        PC stack   pid father
> [  422.967872] oracle          D 0000000000000000     0  3743      1 0x00000000
> [  422.968112]  ffff88203e5a2810 0000000000000086 ffff882000000000 ffff88103f403080
> [  422.968505]  ffff88203eeddfd8 ffff88203eeddfd8 ffff88203eeddfd8 ffff88203e5a2810
> [  422.968895]  0000000001c08400 ffff88103f3db348 ffff88103f2fe800 ffffffff813527c6
> [  422.969287] Call Trace:
> [  422.969397]  [<ffffffff813527c6>] ? printk+0x43/0x48
> [  422.969528]  [<ffffffffa0143288>] ? ext4_msg+0x58/0x60 [ext4]
> [  422.969643]  [<ffffffffa0123e6d>] ? ext4_file_write+0x20d/0x260 [ext4]
> [  422.969758]  [<ffffffff8106aee0>] ? abort_exclusive_wait+0xb0/0xb0
> [  422.969873]  [<ffffffffa0123c60>] ? ext4_llseek+0x120/0x120 [ext4]
> [  422.969985]  [<ffffffff81162173>] ? aio_rw_vect_retry+0x73/0x1d0
> [  422.970093]  [<ffffffff8116302f>] ? aio_run_iocb+0x5f/0x160
> [  422.970200]  [<ffffffff81164258>] ? do_io_submit+0x4f8/0x600
> [  422.970312]  [<ffffffff81359b52>] ? system_call_fastpath+0x16/0x1b
> 
> Note in both this cases, I now see slightly different
> backtrace -- both mentions ext4_llseek and abort_exclusive_wait,
> but the rest is different:
> 
> >> [   76.982985] EXT4-fs (dm-1): Unaligned AIO/DIO on inode 3407879 by oracle; performance will be poor.
> >> [ 1469.734114] SysRq : Show Blocked State
> >> [ 1469.734157]   task                        PC stack   pid father
> >> [ 1469.734473] oracle          D 0000000000000000     0  6146      1 0x00000000
> >> [ 1469.734525]  ffff88103f604810 0000000000000082 ffff881000000000 ffff881079791040
> >> [ 1469.734603]  ffff880432c19fd8 ffff880432c19fd8 ffff880432c19fd8 ffff88103f604810
> >> [ 1469.734681]  ffffea000ec13590 ffffffff00000000 ffff881438c8dad8 ffffffff810eeda2
> >> [ 1469.734760] Call Trace:
> >> [ 1469.734800]  [<ffffffff810eeda2>] ? __do_fault+0x422/0x520
> >> [ 1469.734863]  [<ffffffffa0123e6d>] ? ext4_file_write+0x20d/0x260 [ext4]
> >> [ 1469.734909]  [<ffffffff8106aee0>] ? abort_exclusive_wait+0xb0/0xb0
> >> [ 1469.734956]  [<ffffffffa0123c60>] ? ext4_llseek+0x120/0x120 [ext4]
> >> [ 1469.734999]  [<ffffffff81162173>] ? aio_rw_vect_retry+0x73/0x1d0
> >> [ 1469.735039]  [<ffffffff8116302f>] ? aio_run_iocb+0x5f/0x160
> >> [ 1469.735078]  [<ffffffff81164258>] ? do_io_submit+0x4f8/0x600
> >> [ 1469.735122]  [<ffffffff81359b52>] ? system_call_fastpath+0x16/0x1b
> 
> As Jan already pointed out, this place looks bogus, and
> the same can be said about the new backtrace.  So I wonder
> if there's some stack corruption going on there as well.
  Probably not, just garbage on stack confuses the stack unwinder. Note
that e.g. ext4_llseek() is at the end of function as well as
abort_exclusive_wait() which probably means these functions have already
finished and just left their addresses on stack. Could you disasseble
your ext4_file_write() function and check where offset 0x20d is? Sadly you
won't see where calls are going when ext4 is compiled as a module (module
is linked when loaded into kernel) so it might be easier to compile ext4
into the kernel and disassemble the function in vmlinux file.

> Btw, does ext4_llseek() look sane here?  Note it's called from
> aio_submit() -- does it _ever_ implement SEEKs?
> 
> Maybe some debugging is neecessary here?
  Yes. The trouble is I'm not completely sure where we are hanging yet.
We should know more from your disassembly. But you can try running with
attached debug patch - maybe it shows something interesting.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--y0ulUmNC+osPPQO6
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="ext4-debug.diff"

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index e4095e9..a897474 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -59,6 +59,8 @@ static void ext4_aiodio_wait(struct inode *inode)
 {
 	wait_queue_head_t *wq = ext4_ioend_wq(inode);
 
+	if (atomic_read(&EXT4_I(inode)->i_aiodio_unwritten) != 0)
+		printk("Going to wait for %lu aios\n", (unsigned long)atomic_read(&EXT4_I(inode)->i_aiodio_unwritten));
 	wait_event(*wq, (atomic_read(&EXT4_I(inode)->i_aiodio_unwritten) == 0));
 }
 

--y0ulUmNC+osPPQO6--
