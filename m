From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: Ext4: batched discard support
Date: Mon, 19 Apr 2010 12:20:57 -0400
Message-ID: <h2o87f94c371004190920h5e793818x4113da75dd21da8b@mail.gmail.com>
References: <1271674527-2977-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>,
	Edward Shishkin <eshishki@redhat.com>,
	Eric Sandeen <esandeen@redhat.com>,
	Ric Wheeler <rwheeler@redhat.com>, Mark Lord <liml@rtr.ca>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f199.google.com ([209.85.223.199]:64670 "EHLO
	mail-iw0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215Ab0DSQU6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Apr 2010 12:20:58 -0400
Received: by iwn37 with SMTP id 37so573845iwn.15
        for <linux-ext4@vger.kernel.org>; Mon, 19 Apr 2010 09:20:57 -0700 (PDT)
In-Reply-To: <1271674527-2977-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Adding Mark Lord in cc.

He wrote a preliminary discard solution last summer.  I'm not sure how
it has progressed.

Mark, you can find the 2 patches at:

http://patchwork.ozlabs.org/patch/50441/
http://patchwork.ozlabs.org/patch/50442/

Greg

On Mon, Apr 19, 2010 at 6:55 AM, Lukas Czerner <lczerner@redhat.com> wr=
ote:
> Hi all,
>
> I would like to present a new way to deal with TRIM in ext4 file syst=
em.
> The current solution is not ideal because of its bad performance impa=
ct.
> So basic idea to improve things is to avoid discarding every time som=
e
> blocks are freed. and instead batching is together into bigger trims,
> which tends to be more effective.
>
> The basic idea behind my discard support is to create an ioctl which
> walks through all the free extents in each allocating group and disca=
rd
> those extents. As an addition to improve its performance one can spec=
ify
> minimum free extent length, so ioctl will not bother with shorter ext=
ents.
>
> This of course means, that with each invocation the ioctl must walk
> through whole file system, checking and discarding free extents, whic=
h
> is not very efficient. The best way to avoid this is to keep track of
> deleted (freed) blocks. Then the ioctl have to trim just those free
> extents which were recently freed.
>
> In order to implement this I have added new bitmap into ext4_group_in=
fo
> (bb_bitmap_deleted) which stores recently freed blocks. The ioctl the=
n
> walk through bb_bitmap_deleted, compare deleted extents with free
> extents trim them and then removes it from the bb_bitmap_deleted.
>
> But you may notice, that there is one problem. bb_bitmap_deleted does
> not survive umount. To bypass the problem the first ioctl call have t=
o
> walk through whole file system trimming all free extents. But there i=
s a
> better solution to this problem. The bb_bitmap_deleted can be stored =
on
> disk an can be restored in mount time along with other bitmaps, but I
> think it is a quite big change and should be discussed further.
>
> I have also benchmarked it a little. You can find results here:
>
> people.redhat.com/jmoyer/discard/ext4_batched_discard/
>
> comparison with current solution included. Keep in mind that ideal io=
ctl
> invocation interval is yet to be determined, so in benchmark I have u=
sed
> the performance-worst scenario - without any sleep between execution.
>
>
> There are two patches for this. The first one just creates file syste=
m
> independent ioctl for this and the second one it the batched discard
> support itself.
>
> I will very much appreciate any comment on this, your opinions, ideas=
 to
> make this better etc. Thanks.
>
> If you want to try it, just create EXT4 file system mount it and invo=
ke
> ioctl on the mount point. You can use following code for this (I have
> taken this from xfs patch for the same thing). You can also see some
> debugging messages, but you may want to set EXT4FS_DEBUG for this.
>
> #include <errno.h>
> #include <fcntl.h>
> #include <stdio.h>
> #include <stdint.h>
> #include <sys/ioctl.h>
>
> #define FITRIM =A0 =A0 =A0 =A0 =A0_IOWR('X', 121, int)
>
> int main(int argc, char **argv)
> {
> =A0 =A0 =A0 =A0int minsize =3D 4096;
> =A0 =A0 =A0 =A0int fd;
>
> =A0 =A0 =A0 =A0if (argc !=3D 2) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fprintf(stderr, "usage: %s mountpoint\=
n", argv[0]);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 1;
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0fd =3D open(argv[1], O_RDONLY);
> =A0 =A0 =A0 =A0if (fd < 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0perror("open");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 1;
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0if (ioctl(fd, FITRIM, &minsize)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (errno =3D=3D EOPNOTSUPP)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fprintf(stderr, "TRIM =
not supported\n");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0perror("EXT4_IOC_TRIM"=
);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 1;
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0return 0;
> }
>
> =A0fs/ioctl.c =A0 =A0 =A0 =A0 | =A0 31 ++++++++++++++++++++++++++++++=
+
> =A0include/linux/fs.h | =A0 =A02 ++
> =A02 files changed, 33 insertions(+), 0 deletions(-)
>
> =A0fs/ext4/ext4.h =A0 =A0| =A0 =A04 +
> =A0fs/ext4/mballoc.c | =A0207 +++++++++++++++++++++++++++++++++++++++=
+++++++++++---
> =A0fs/ext4/super.c =A0 | =A0 =A01 +
> =A03 files changed, 202 insertions(+), 10 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
