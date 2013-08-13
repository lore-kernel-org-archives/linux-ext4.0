From: Anatol Pomozov <anatol.pomozov@gmail.com>
Subject: xfstests-301 fails on HEAD version
Date: Tue, 13 Aug 2013 13:28:24 -0700
Message-ID: <CAOMFOmWhF6kA2RFEphJLbiJn6bYaA8vZkV=rvX51YmS0Jn7F3A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Dmitry Monakhov <dmonakhov@openvz.org>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:40315 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758938Ab3HMU20 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Aug 2013 16:28:26 -0400
Received: by mail-ee0-f48.google.com with SMTP id l10so4438332eei.35
        for <linux-ext4@vger.kernel.org>; Tue, 13 Aug 2013 13:28:25 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi, everyone

I was running xfstests on different Linux versions and spotted a test
regression. In particular 301 works fine on 3.3 and fails on
3.11-HEAD. Here is the message from 3.11:

Starting 5 processes
fio: io_u.c:1150: __get_io_u: Assertion `io_u->flags & IO_U_F_FREE'
failed.ta 1158050441d:03h:32m:07s]
fio: pid=10564, got signal=6 done] [895KB/383KB/0KB /s] [13/5/0 iops]
[eta 1158050441d:03h:32m:06s]
fio: pid=10561, err=16/file:ioengines.c:295, func=td_io_queue,
error=Device or resource busy
fio: pid=10560, err=16/file:ioengines.c:295, func=td_io_queue,
error=Device or resource busy
fio: pid=10563, err=16/file:ioengines.c:295, func=td_io_queue,
error=Device or resource busy


I checked where this error comes from and it is FIO/engines/e4defrag.c:

ret = ioctl(f->fd, EXT4_IOC_MOVE_EXT, &me);

so ioctl(EXT4_IOC_MOVE_EXT) return EBUSY. I added some kernel traces
and the error comes from ext4_move_extents() function that in turn
comes from move_extent_per_page(). At the end the error code is set
here

       /* At this point all buffers in range are uptodate, old mapping layout
        * is no longer required, try to drop it now. */
       if ((page_has_private(pagep[0]) && !try_to_release_page(pagep[0], 0)) ||
           (page_has_private(pagep[1]) && !try_to_release_page(pagep[1], 0))) {
               *err = -EBUSY;
               goto unlock_pages;
       }



I talked about this error with Ted and he suggested to add
ext4_unwritten_wait() to ext4_move_extents() like in the patch below,
but I still see the same test failure.


@@ -1334,6 +1334,8 @@ ext4_move_extents(struct file *o_filp, struct
file *d_filp,
        ext4_inode_block_unlocked_dio(donor_inode);
        inode_dio_wait(orig_inode);
        inode_dio_wait(donor_inode);
+       ext4_unwritten_wait(orig_inode);
+       ext4_unwritten_wait(donor_inode);

        /* Protect extent tree against block allocations via delalloc */
        ext4_double_down_write_data_sem(orig_inode, donor_inode);



Ted, Dmitry, do you have any ideas why this regression happen?
