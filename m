From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: [PATCH] resize2fs: exit fix_sb_journal_backup early for external
	journal
Date: Mon, 9 Nov 2009 19:54:11 -0800
Message-ID: <4877c76c0911091954p237058cfn2ce9f41cd966d2dc@mail.gmail.com>
References: <4AF88220.90908@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f188.google.com ([209.85.222.188]:62161 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823AbZKJDyF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Nov 2009 22:54:05 -0500
Received: by pzk26 with SMTP id 26so2571019pzk.4
        for <linux-ext4@vger.kernel.org>; Mon, 09 Nov 2009 19:54:11 -0800 (PST)
In-Reply-To: <4AF88220.90908@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thank you for the patch, I've refined your testcase:

#!/bin/sh
touch testfs
truncate -s2G testfs
touch testjournal
truncate -s128M testjournal
LOLOG=3D`losetup -f`
losetup "${LOLOG}" testjournal
mke2fs -O journal_dev "${LOLOG}"
LOFS=3D`losetup -f`
losetup "${LOFS}" testfs
mkfs.ext4 -J device=3D"${LOLOG}" "${LOFS}" 127680
echo -e "\n\nThis will fail\n"
resize2fs "${LOFS}"
echo -e "\nFsck to clear\n"
fsck -fy "${LOFS}"
echo -e "\n\nIf run in the build dir of a the current version/git
checkout with the patch applied and build... ./resize/resize2fs will
work.\n"
=2E/resize/resize2fs "${LOFS}"
losetup -d "${LOLOG}"
losetup -d "${LOFS}"


Insert data checks/etc as desired.

On Mon, Nov 9, 2009 at 12:57 PM, Eric Sandeen <sandeen@redhat.com> wrot=
e:
> Resizing a filesystem with an external journal fails when it tries
> to read inode 0:
>
> # touch testfs
> # truncate testfs 1342177280
> # touch testjournal
> # truncate testjournal 134217728
> # mke2fs -O journal_dev testjournal
> # losetup /dev/loop0 testjournal
> # mkfs.ext4 -J device=3D/dev/loop0 testfs 127680
> # resize2fs testfs
> resize2fs 1.41.9 (22-Aug-2009)
> Resizing the filesystem on testfs to 327680 (4k) blocks.
> resize2fs: Illegal inode number while trying to resize testfs
> Please run 'e2fsck -fy testfs' to fix the filesystem
> after the aborted resize operation.
>
> I think the right, simple thing to do is just bail out early
> for an external journal here, as there are no backup blocks
> to update.
>
> Reported-by: mjevans1983@gmail.com
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>
> diff --git a/resize/resize2fs.c b/resize/resize2fs.c
> index 5a1eb2a..2d4a14f 100644
> --- a/resize/resize2fs.c
> +++ b/resize/resize2fs.c
> @@ -1887,6 +1887,10 @@ static errcode_t fix_sb_journal_backup(ext2_fi=
lsys fs)
> =A0 =A0 =A0 =A0if (!(fs->super->s_feature_compat & EXT3_FEATURE_COMPA=
T_HAS_JOURNAL))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
>
> + =A0 =A0 =A0 /* External journal? Nothing to do. */
> + =A0 =A0 =A0 if (fs->super->s_journal_dev && !fs->super->s_journal_i=
num)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> +
> =A0 =A0 =A0 =A0retval =3D ext2fs_read_inode(fs, fs->super->s_journal_=
inum, &inode);
> =A0 =A0 =A0 =A0if (retval)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return retval;
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
