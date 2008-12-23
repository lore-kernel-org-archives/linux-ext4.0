From: Paul Collins <paul@burly.ondioline.org>
Subject: (resend) extent header problems following shrink with resize2fs
Date: Tue, 23 Dec 2008 18:49:15 +1300
Message-ID: <87abanbfvo.fsf@burly.wgtn.ondioline.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from jenny.ondioline.org ([66.220.1.122]:51748 "EHLO
	jenny.ondioline.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbYLWFtQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Dec 2008 00:49:16 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

(resending without gipped attachment)

Running Linux 2.6.28-rc9 as of ab65387243f47a7bc11725f733c86bf27248b326=
=2E
e2fsprogs 1.41.3-1 from Debian.

Yesterday I created a ~464GB ext4 volume and copied about 107GB of musi=
c
files onto it.  Then I decided that I wanted to use half of the disk fo=
r
something else, so last night I resized the ext4 filesystem to ~232GB
and recreated the partitions to suit.  This morning I wrote some new
files to the ext4 filesystem, which went fine.  Then I installed a new
music player, which wanted to scan all of the files on the disk.  It
reported being unable to read some files, and there's rather a lot of
this sort of thing in dmesg (see also http://ondioline.org/~paul/e4dmes=
g.gz):

EXT4-fs error (device sdb1): ext4_ext_find_extent: bad header in inode =
#39565: invalid magic - magic 24e, entries 28338, max 21313(0), depth 2=
8712(0)
EXT4-fs error (device sdb1): ext4_ext_find_extent: bad header in inode =
#39555: invalid magic - magic cd8c, entries 59560, max 57082(0), depth =
5425(0)
EXT4-fs error (device sdb1): ext4_ext_find_extent: bad header in inode =
#39563: invalid magic - magic 976d, entries 52325, max 49256(0), depth =
50316(0)
EXT4-fs error (device sdb1): ext4_ext_find_extent: bad header in inode =
#39556: invalid magic - magic 61c6, entries 47990, max 4668(0), depth 3=
2768(0)
EXT4-fs error (device sdb1): ext4_ext_find_extent: bad header in inode =
#44888: invalid magic - magic 42a, entries 5388, max 32960(0), depth 18=
72(0)
EXT4-fs error (device sdb1): ext4_ext_find_extent: bad header in inode =
#39844: invalid magic - magic 6ae8, entries 44073, max 20807(0), depth =
10869(0)
EXT4-fs error (device sdb1): ext4_ext_find_extent: bad header in inode =
#39843: invalid magic - magic 2200, entries 38282, max 17931(0), depth =
0(0)

There are no "access beyond end of partition" messages, so I don't thin=
k
I screwed up the resize procedure.  The argument I gave resizefs was
"244192000K"; here's the partition table:

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1               1       30401   244196001   83  Linux
/dev/sdb2           30402       60801   244188000   83  Linux


e2fsck aborts when I try to use it fix the filesystem:

        /dev/sdb1 contains a file system with errors, check forced.
        Pass 1: Checking inodes, blocks, and sizes
        Error1: Corrupt extent header on inode 38979
        [New Thread 0x7fe15e066740 (LWP 24166)]

        Program received signal SIGABRT, Aborted.
        [Switching to Thread 0x7fe15e066740 (LWP 24166)]
        0x00007fe15d0fbed5 in raise () from /lib/libc.so.6
        (gdb) bt
        #0  0x00007fe15d0fbed5 in raise () from /lib/libc.so.6
        #1  0x00007fe15d0fd3f3 in abort () from /lib/libc.so.6
        #2  0x000000000040bdae in scan_extent_node (ctx=3D0x24c6f70,=20
            pctx=3D0x7fff6607c7a0, pb=3D0x7fff6607c5f0, start_block=3D0=
, ehandle=3D0x2ed94d0)
            at /build/buildd/e2fsprogs-1.41.3/e2fsck/pass1.c:1700
        #3  0x000000000040cc1d in check_blocks (ctx=3D0x24c6f70, pctx=3D=
0x7fff6607c7a0,=20
            block_buf=3D0x2ec11a0 "=EF=BF=BD002")
            at /build/buildd/e2fsprogs-1.41.3/e2fsck/pass1.c:1773
        #4  0x000000000040e063 in e2fsck_pass1 (ctx=3D0x24c6f70)
            at /build/buildd/e2fsprogs-1.41.3/e2fsck/pass1.c:1030
        #5  0x00000000004089e8 in e2fsck_run (ctx=3D0x24c6f70)
            at /build/buildd/e2fsprogs-1.41.3/e2fsck/e2fsck.c:215
        #6  0x00000000004074a3 in main (argc=3D<value optimized out>,=20
            argv=3D<value optimized out>)
            at /build/buildd/e2fsprogs-1.41.3/e2fsck/unix.c:1278

and e2image exits with:

        e2image: Corrupt extent header while iterating over inode 38979

In the matter of inode 38979, debugfs says:

        debugfs:  bmap <38979> 0
        argv[0]: Corrupt extent header while mapping logical block 0


I can keep the FS around so let me know if you need any more
information.

--=20
Paul Collins
Wellington, New Zealand

Dag vijandelijk luchtschip de huismeester is dood
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
