From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC][PATCH] fstest: regression test for ext4 crash consistency bug
Date: Fri, 1 Sep 2017 17:59:15 +0300
Message-ID: <CAOQ4uxh0KzHRXphxsOU14z8rFa-x2YMV-x5BH8JtXqt+Vvgm3w@mail.gmail.com>
References: <7f4519d6-9e3f-c036-b72d-8a387bf657d3@utexas.edu>
 <CAOQ4uxgRafGec=HFq1strxC5NM0jwNgbu5ZyP1g+c64=b399+A@mail.gmail.com>
 <CAOQ4uxgOu5yNV3zQ9WnJU_AQtpe9G9cxQQL52fWsXd=5bvGLaQ@mail.gmail.com> <CAFk8rvYC4wTw15CF0wTdYLXLBp-FL+Y0xDtcins+uHu5gfrm-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Eryu Guan <eguan@redhat.com>, Josef Bacik <jbacik@fb.com>,
        Vijay Chidambaram <vvijay03@gmail.com>,
        fstests <fstests@vger.kernel.org>,
        Ext4 <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>
To: Ashlie Martinez <ashmrtn@utexas.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f174.google.com ([209.85.161.174]:36152 "EHLO
        mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752069AbdIAO7Q (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Sep 2017 10:59:16 -0400
In-Reply-To: <CAFk8rvYC4wTw15CF0wTdYLXLBp-FL+Y0xDtcins+uHu5gfrm-A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 1, 2017 at 3:21 PM, Ashlie Martinez <ashmrtn@utexas.edu> wrote:
> Apologies for spam, resending plain text so it appears in the archives.
>
>
...
>>>> When free data blocks and inode errors occur, the message is `Free blocks
>>>> count wrong (8795, counted=8714).` and `Free inodes count wrong (2549,
>>>> counted=2546).`
>>>>
>>>> I have not had a chance to look into the above errors to find their root
>>>> causes.
>>>>
>>>
>>> I believe this is what you get when you fsck -yf before trying to mount when
>>> the orphan list is not empty. You should avoid doing that.
>
> Do you know what the kernel does when a file system like that is mounted? The
> link you posted below has a comment about the kernel checking the file system
> faster than fsck can. Do you know how it accomplishes this? Should the
> mount -o errors=remount-ro; unmount sequence be done for all file systems or
> just a select few for which the kernel knows how to handle? Does following the
> mount/unmount, check sequence just mean that the kernel will silently (from the
> perspective of normal users) fix some issues with the file system much like
> fsck does when it is run (though perhaps less thoroughly than fsck)?
>

mount/umount does several things.
among other things, its starts with replaying the journal.
with journalling file systems this is essential to the point that it is really
not safe to fsck before replaying the journal. So e2fsck -y will in fact
replay the journal, but it will do a much worse job (much slower) the
the kernel does when replaying the journal (too hard to explain why).
BTW e2fsck -n will not replay the journal so it may report phantom
errors or refuse to run?

HOWEVER, the comment I referred you to in Android code refers
to the efficiency of the kernel with cleaning up the "orphan inode list".
If you open N files, unlink them sync and crash the kernel will cleanup
the disk space used by those N files on next mount.
e2fsck will "zap" those files and then fix all the inode and block counter
and report they were wrong, like you reported above.

Amir.
