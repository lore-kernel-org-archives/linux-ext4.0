From: Tony Lindgren <tony@atomide.com>
Subject: Re: Regression in next with ext4 oops
Date: Tue, 4 Oct 2016 07:18:22 -0700
Message-ID: <20161004141822.uf3okqibwo3yb5mp@atomide.com>
References: <20161003233054.eltv3coiweht3ui4@atomide.com>
 <20161004090041.GE17515@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Biggers <ebiggers@google.com>, Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger@dilger.ca>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161004090041.GE17515@quack2.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

* Jan Kara <jack@suse.cz> [161004 02:01]:
> Hi!
> 
> On Mon 03-10-16 16:30:55, Tony Lindgren wrote:
> > I'm seeing a repeatable oops with Linux next while running
> > update-initramfs, see below. I tried reverting commit 59aa5a3aeead
> > ("fscrypto: make filename crypto functions return 0 on success")
> > as that's the only commit changing ext4_htree_store_dirent, but
> > that did not help.
> > 
> > Anybody else seeing something like this?
> 
> Never seen this but I suspect it is a fallout from Al's directory locking
> changes. In particular ext4_htree_fill_tree() builds rb-tree of found
> directory entries in file->private_data (and generally modifies the
> structure stored there) but after Al's changes we don't have exclusive
> access to struct file if I'm right so if two processes end up calling
> getdents() for the same 'struct file' we are doomed.

OK..

> That being said two getdents() calls for a single fd looks like a stupid
> things to do but I don't see anything that would prevent this. Does the
> attached patch fix the issue for you?

Looks like with your patch I saw the oops few times during kernel boot
already, see below. And the errors seem more random now..

I've verified I can run mkinitramfs just fine with my curent for-next
that's based on 4.8.0-rc6, so this does not seem to be any memory or
MMC related issue.

Trying to bisect this would be a pain as the error does not happen
every time..

Regards,

Tony

8< -------------------
Unable to handle kernel NULL pointer dereference at virtual address 00000004
pgd = c22a46c0
[00000004] *pgd=00000000
Internal error: Oops: 205 [#1] SMP ARM
Modules linked in: usbkbd usb_f_rndis usb_f_ecm usb_f_acm u_ether usb_f_mass_storage usb]
CPU: 1 PID: 364 Comm: startpar Not tainted 4.8.0-rc8-next-20161003+ #1005
Hardware name: Generic OMAP5 (Flattened Device Tree)
task: c2090ec0 task.stack: c25b2000
PC is at rb_insert_color+0x1c/0x1b8
LR is at ext4_htree_store_dirent+0xe0/0x104
pc : [<c0594b10>]    lr : [<c042ade0>]    psr: 600f0013
sp : c25b3db0  ip : c2297bd8  fp : c0a17618
r10: 00000000  r9 : c25b3e00  r8 : c2297bd0
r7 : c2298f80  r6 : 79de0293  r5 : 998623c8  r4 : 00000000
r3 : 00000000  r2 : c2297c08  r1 : c2298f80  r0 : c2297bd8
Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 30c5387d  Table: 822a46c0  DAC: 55555555
Process startpar (pid: 364, stack limit = 0xc25b2218)
Stack: (0xc25b3db0 to 0xc25b4000)
3da0:                                     00000000 998623c8 79de0293 c042ade0
3dc0: e92460b4 ed080200 ed084790 c25b3e58 e92460bc e9246ff8 00000000 c043ee9c
3de0: c25b3e00 ed080200 e9246000 00001000 000000b4 c028a6e4 00000009 ee48a400
3e00: e92460bc 0000000d c1025cb4 c2298f80 ed0848c0 ed084790 00000000 ee48a400
3e20: 00000000 c25b3e58 c2257800 c043fc14 00000000 00000000 00000006 024080c0
3e40: c2298fa0 00000000 600f0013 c100253c c10936b4 c02871ac 998623c8 79de0293
3e60: 00000004 c22570b8 c2298f80 c0383f40 030d8fb9 69db434f c2298f80 c20aa000
3e80: 7f5c2000 c2298f80 ed0848c0 c25b3f68 ed084790 ed084830 ee48a400 ed084790
3ea0: c2257800 c042aa04 00000000 00000000 600f0013 c10930b0 00000001 c028c230
3ec0: 00000001 00000000 00000000 00000000 00000000 00000000 00000800 600f0013
3ee0: 00000000 00000002 00000000 ed084830 00000000 00000001 c03b4e3c ed084830
3f00: ee48a400 00000000 bef92f0c c08d4530 00000001 ee48a400 00000000 00000000
3f20: c25b3f68 ed084830 ee48a400 00000000 bef92f0c c03b4e70 ee48a400 bef90800
3f40: 7f59d01d 7f5ba6f0 00008000 00000004 000000d9 ee48a400 ee48a400 00000000
3f60: bef92f0c c03b54a0 c03b5124 00000000 00000000 00000000 7f5ba6f0 00000000
3f80: 00008000 00000000 00000020 00000020 7f5ba6d0 7f5ba6f0 000000d9 c02080c4
3fa0: c25b2000 c0207f40 00000020 7f5ba6d0 00000004 7f5ba6f0 00008000 00000000
3fc0: 00000020 7f5ba6d0 7f5ba6f0 000000d9 b6f15850 00000000 00000000 bef92f0c
3fe0: 000000d9 bef9080c b6e57fa3 b6e006f6 200f0030 00000004 00000000 00150072
[<c0594b10>] (rb_insert_color) from [<c042ade0>] (ext4_htree_store_dirent+0xe0/0x104)
[<c042ade0>] (ext4_htree_store_dirent) from [<c043ee9c>] (htree_dirblock_to_tree+0xb0/0x)
[<c043ee9c>] (htree_dirblock_to_tree) from [<c043fc14>] (ext4_htree_fill_tree+0x7c/0x2a0)
[<c043fc14>] (ext4_htree_fill_tree) from [<c042aa04>] (ext4_readdir+0x62c/0x910)
[<c042aa04>] (ext4_readdir) from [<c03b4e70>] (iterate_dir+0xcc/0x194)
[<c03b4e70>] (iterate_dir) from [<c03b54a0>] (SyS_getdents64+0x7c/0x10c)
[<c03b54a0>] (SyS_getdents64) from [<c0207f40>] (ret_fast_syscall+0x0/0x1c)
Code: e5923000 e3130001 1a000062 e92d4070 (e593c004)
---[ end trace 8970a95866a25898 ]---
