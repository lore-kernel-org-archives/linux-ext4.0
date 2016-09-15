From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] jbd2: move more common code into journal_init_common()
Date: Thu, 15 Sep 2016 15:58:18 -0400
Message-ID: <20160915195818.q5aa4cc3lrvpsw2m@thunk.org>
References: <cover.1473240936.git.geliangtang@gmail.com>
 <50f2f9e8f6e503a3bd9a54b4dcb58531e18dbf52.1473240936.git.geliangtang@gmail.com>
 <20160907131624.GU28922@quack2.suse.cz>
 <20160915160309.okkvwpxz4im5abti@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Jan Kara <jack@suse.cz>, Geliang Tang <geliangtang@gmail.com>,
        Jan Kara <jack@suse.com>, Eric Ren <zren@suse.com>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160915160309.okkvwpxz4im5abti@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Sep 15, 2016 at 12:03:09PM -0400, Theodore Ts'o wrote:
> On Wed, Sep 07, 2016 at 03:16:24PM +0200, Jan Kara wrote:
> > On Wed 07-09-16 20:41:13, Geliang Tang wrote:
> > > There are some repetitive code in jbd2_journal_init_dev() and
> > > jbd2_journal_init_inode(). So this patch moves the common code into
> > > journal_init_common() helper to simplify the code. And fix the coding
> > > style warnings reported by checkpatch.pl by the way.
> > > 
> > > Signed-off-by: Geliang Tang <geliangtang@gmail.com>
> > 
> > The patch looks good to me. You can add:
> > 
> > Reviewed-by: Jan Kara <jack@suse.cz>
> 
> Applied, thanks.
> 

Hi Geiliang,

This patch is causing a WARN_ON:

[   13.923139] ------------[ cut here ]------------
[   13.924644] WARNING: CPU: 0 PID: 2534 at /usr/projects/linux/ext4/fs/proc/generic.c:369 __proc_create+0xe1/0x156
[   13.926751] name len 0
[   13.927283] Modules linked in:
[   13.927954] CPU: 0 PID: 2534 Comm: mount Tainted: G        W       4.8.0-rc4-00139-g52c4278 #685
[   13.929809] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Debian-1.8.2-1 04/01/2014
[   13.931643]  00000000 00000246 f3c1dd3c c13faa3e f3c1dd68 c11cc9c1 f3c1dd54 c1087d00
[   13.933425]  00000171 f4727b0c f3c1ddac f5183bc0 f3c1dd70 c1087d44 00000009 00000000
[   13.935199]  f3c1dd68 c1969704 f3c1dd84 f3c1dda0 c11cc9c1 c19696d9 00000171 c1969704
[   13.936987] Call Trace:
[   13.937507]  [<c13faa3e>] dump_stack+0x73/0xa5
[   13.938438]  [<c11cc9c1>] ? __proc_create+0xe1/0x156
[   13.939503]  [<c1087d00>] __warn+0xbc/0xd3
[   13.940404]  [<c1087d44>] warn_slowpath_fmt+0x2d/0x32
[   13.941470]  [<c11cc9c1>] __proc_create+0xe1/0x156
[   13.942461]  [<c11ccc8d>] proc_mkdir_data+0x2c/0x6e
[   13.943484]  [<c11cccf6>] proc_mkdir+0x13/0x15
[   13.944425]  [<c122a597>] journal_init_common+0x1a8/0x26a
[   13.945539]  [<c122a753>] jbd2_journal_init_inode+0xa9/0xfd
[   13.946702]  [<c11fa5cf>] ext4_fill_super+0x18e5/0x2a92
[   13.947794]  [<c1402d01>] ? bitmap_string.isra.6+0xa9/0xc1
[   13.948926]  [<c117ec1f>] mount_bdev+0x114/0x15f
[   13.950333]  [<c11f48c4>] ext4_mount+0x15/0x17
[   13.951985]  [<c11f8cea>] ? ext4_calculate_overhead+0x30e/0x30e
[   13.954172]  [<c117f49d>] mount_fs+0x58/0x115
[   13.955789]  [<c11943cb>] vfs_kern_mount+0x4c/0xae
[   13.957588]  [<c11966dc>] do_mount+0x6b0/0x8d7
[   13.959270]  [<c1405620>] ? _copy_from_user+0x44/0x57
[   13.961140]  [<c1150873>] ? strndup_user+0x31/0x42
[   13.962919]  [<c1196aab>] SyS_mount+0x57/0x7b
[   13.964609]  [<c10015b2>] do_int80_syscall_32+0x4d/0x5f
[   13.966555]  [<c16f6ccb>] entry_INT80_32+0x2f/0x2f
[   13.968402] ---[ end trace 2eb7cc6d9a94f309 ]---
[   14.017482] EXT4-fs (vdc): mounted filesystem with ordered data mode. Opts: (null)

The problem is that journal->j_devname isn't initialized until *after*
journal_init_common(), and it's used by jbd2_stats_proc_init(), which
is called by journal_init_common().

To fix it I applied the following fix on top of your patch.

       	    	    		      	     - Ted

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 07e14ef..927da49 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1141,13 +1141,11 @@ static journal_t *journal_init_common(struct block_device *bdev,
 	journal->j_fs_dev = fs_dev;
 	journal->j_blk_offset = start;
 	journal->j_maxlen = len;
-	jbd2_stats_proc_init(journal);
 	n = journal->j_blocksize / sizeof(journal_block_tag_t);
 	journal->j_wbufsize = n;
 	journal->j_wbuf = kmalloc_array(n, sizeof(struct buffer_head *),
 					GFP_KERNEL);
 	if (!journal->j_wbuf) {
-		jbd2_stats_proc_exit(journal);
 		kfree(journal);
 		return NULL;
 	}
@@ -1157,7 +1155,6 @@ static journal_t *journal_init_common(struct block_device *bdev,
 		pr_err("%s: Cannot get buffer for journal superblock\n",
 			__func__);
 		kfree(journal->j_wbuf);
-		jbd2_stats_proc_exit(journal);
 		kfree(journal);
 		return NULL;
 	}
@@ -1202,6 +1199,7 @@ journal_t *jbd2_journal_init_dev(struct block_device *bdev,
 
 	bdevname(journal->j_dev, journal->j_devname);
 	strreplace(journal->j_devname, '/', '!');
+	jbd2_stats_proc_init(journal);
 
 	return journal;
 }
@@ -1241,6 +1239,7 @@ journal_t *jbd2_journal_init_inode(struct inode *inode)
 	bdevname(journal->j_dev, journal->j_devname);
 	p = strreplace(journal->j_devname, '/', '!');
 	sprintf(p, "-%lu", journal->j_inode->i_ino);
+	jbd2_stats_proc_init(journal);
 
 	return journal;
 }
