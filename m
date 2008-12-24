From: Alberto Bertogli <albertito@blitiri.com.ar>
Subject: jbd2 inside a device mapper module
Date: Wed, 24 Dec 2008 19:10:38 -0200
Message-ID: <20081224211038.GT4127@blitiri.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: dm-devel@redhat.com, linux-ext4@vger.kernel.org
To: linux-mm-cc@lists.laptop.org
Return-path: <linux-mm-cc-bounces@lists.laptop.org>
Content-Disposition: inline
List-Unsubscribe: <http://lists.laptop.org/listinfo/linux-mm-cc>,
	<mailto:linux-mm-cc-request@lists.laptop.org?subject=unsubscribe>
List-Archive: <http://lists.laptop.org/pipermail/linux-mm-cc>
List-Post: <mailto:linux-mm-cc@lists.laptop.org>
List-Help: <mailto:linux-mm-cc-request@lists.laptop.org?subject=help>
List-Subscribe: <http://lists.laptop.org/listinfo/linux-mm-cc>,
	<mailto:linux-mm-cc-request@lists.laptop.org?subject=subscribe>
Sender: linux-mm-cc-bounces@lists.laptop.org
Errors-To: linux-mm-cc-bounces@lists.laptop.org
List-Id: linux-ext4.vger.kernel.org


Hi!

I'm writing a small device mapper module, and I'm interested in placing
a jbd/jdb2 journal on the backing device.

I started by trying to do a __bread() manually (just for early tests)
inside my map function. But it got stucked, as far as I could see,
waiting for a buffer head in wait_on_buffer() IIRC (I could track it
down again if it's needed). And I couldn't find why it was locked, since
it was an unused loopback device, and my code didn't even deal with
buffer heads.

Then, since I was planning on using jbd/jdb2 anyway, I decided to use it
(and went for jbd2).


Now, I'm having issues with journal creation.

I tried using "mkfs.ext3 -O journal_dev", but jbd2_journal_load()
complains that it can't find the journal superblock.

And if I modify jbd2_journal_create(), removing the 'if
(journal->j_inode == NULL)' check (I imagine it's there for a reason,
but from a quick look at the code couldn't find it and thought it was
worth a try) then when creating it I get a warning (pasted below) and it
gets locked up, which I think may be related to what happened when I did
__bread(), but obviously I'm not sure at all.

And I got stucked there, so I thought it'd be better to ask. Does anyone
have any ideas or suggestions on what I'm doing wrong?


I've not published my code yet because it's really rough, but if anyone
wants to take a look at it, please let me know. I was planning on
posting it when it was at least working.

Thanks a lot,
		Alberto



[42949814.780000] ------------[ cut here ]------------
[42949814.780000] WARNING: at /pub/src/linux/linux-2.6/fs/buffer.c:1186 mark_buffer_dirty+0x77/0xa0()
[42949814.780000] Modules linked in:
[42949814.780000] Call Trace:
[42949814.780000] 678f17d8:  [<6003988b>] warn_on_slowpath+0x5b/0x80
[42949814.780000] 678f1818:  [<600bbe9a>] __find_get_block_slow+0x7a/0x110
[42949814.780000] 678f1858:  [<600bc219>] __find_get_block+0x79/0x180
[42949814.780000] 678f1888:  [<60033b05>] __might_sleep+0x105/0x130
[42949814.780000] 678f18c8:  [<600bc353>] __getblk+0x33/0x270
[42949814.780000] 678f18f8:  [<600bc7e7>] mark_buffer_dirty+0x77/0xa0
[42949814.780000] 678f1918:  [<6012b1a8>] jbd2_journal_create+0x88/0x170
[42949814.780000] 678f1958:  [<601aac70>] csum_ctr+0x1b0/0x240
[42949814.780000] 678f1968:  [<6019b810>] get_target_type+0x60/0xa0
[42949814.780000] 678f19a8:  [<6019b0d4>] dm_table_add_target+0x174/0x3b0
[42949814.780000] 678f1a08:  [<6019d057>] table_load+0xb7/0x200
[42949814.780000] 678f1a68:  [<6019dd98>] dm_ctl_ioctl+0x288/0x300
[42949814.780000] 678f1a98:  [<6019cfa0>] table_load+0x0/0x200
[42949814.780000] 678f1c18:  [<600a82fb>] vfs_ioctl+0x1b/0x70
[42949814.780000] 678f1c28:  [<600a8770>] do_vfs_ioctl+0x400/0x660
[42949814.780000] 678f1ca8:  [<600a8a1a>] sys_ioctl+0x4a/0x80
[42949814.780000] 678f1ce8:  [<6001a310>] handle_syscall+0x50/0x80
[42949814.780000] 678f1d08:  [<6002bf1f>] userspace+0x3ff/0x530
[42949814.780000] 678f1fc8:  [<60017012>] fork_handler+0x62/0x70
[42949814.780000]
[42949814.780000] ---[ end trace ebc125a00ee8f9d2 ]---
