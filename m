From: Paul Collins <paul@burly.ondioline.org>
Subject: Re: (resend) extent header problems following shrink with resize2fs
Date: Thu, 25 Dec 2008 20:18:48 +1300
Message-ID: <877i5ozprb.fsf@burly.wgtn.ondioline.org>
References: <87abanbfvo.fsf@burly.wgtn.ondioline.org>
	<20081223061833.GQ23723@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from jenny.ondioline.org ([66.220.1.122]:44067 "EHLO
	jenny.ondioline.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbYLYHSu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Dec 2008 02:18:50 -0500
In-Reply-To: <20081223061833.GQ23723@mit.edu> (Theodore Tso's message of "Tue,
	23 Dec 2008 01:18:33 -0500")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso <tytso@MIT.EDU> writes:
> Yeah, resize2fs needs to be fixed to handle extents correctly.  At th=
e
> moment it can screw them up pretty badly.

In the meantime, perhaps something like the patch below is appropriate?

> I'll log this as a bug to resize2fs; thanks for reporting it, and I
> hope you didn't suffer any permanent data loss.

No worries there, that was replica N+1 of those particular files.

My real concern, which I didn't highlight well and buried way down in m=
y
original report to boot, was e2fsck blowing up like it did.  Hardware
being what it is, I imagine at some point extent headers will get
corrupted, and losing one file is of course preferable to losing the
entire filesystem.

=46or reference, here's that backtrace again.

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


diff --git a/resize/main.c b/resize/main.c
index 3de333e..fb4fa99 100644
--- a/resize/main.c
+++ b/resize/main.c
@@ -426,6 +426,13 @@ int main (int argc, char ** argv)
 			"long.  Nothing to do!\n\n"), new_size);
 		exit(0);
 	}
+	if ((new_size < fs->super->s_blocks_count) &&
+	    (fs->super->s_feature_incompat & EXT3_FEATURE_INCOMPAT_EXTENTS)) =
{
+		fprintf(stderr, _("Reducing the size of a "
+				  "filesystem with extents enabled\n"
+				  "is currently not supported.\n"));
+		exit(1);
+	}
 	if (mount_flags & EXT2_MF_MOUNTED) {
 		retval =3D online_resize_fs(fs, mtpt, &new_size, flags);
 	} else {


--=20
Paul Collins
Wellington, New Zealand

Dag vijandelijk luchtschip de huismeester is dood
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
