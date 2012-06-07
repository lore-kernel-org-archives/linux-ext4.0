From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] ext4: fix the free blocks calculation for ext3 file
 systems w/ uninit_bg
Date: Thu, 7 Jun 2012 10:12:35 -0700
Message-ID: <CAGXu5jJbLu5C+T7D8n=SNJOkG-VTqw7wD8RAmyLg+T__XQmfnA@mail.gmail.com>
References: <1339077153-13212-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	stable@kernel.org, Sander Eikelenboom <linux@eikelenboom.it>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58730 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754204Ab2FGRMh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Jun 2012 13:12:37 -0400
Received: by bkcji2 with SMTP id ji2so789480bkc.19
        for <linux-ext4@vger.kernel.org>; Thu, 07 Jun 2012 10:12:35 -0700 (PDT)
In-Reply-To: <1339077153-13212-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 7, 2012 at 6:52 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> Ext3 filesystems that are converted to use as many ext4 file system
> features as possible will enable uninit_bg to speed up e2fsck times.
> These file systems will have a native ext3 layout of inode tables and
> block allocation bitmaps (as opposed to ext4's flex_bg layout).
> Unfortunately, in these cases, when first allocating a block in an
> uninitialized block group, ext4 would incorrectly calculate the numbe=
r
> of free blocks in that block group, and then errorneously report that
> the file system was corrupt:
>
> EXT4-fs error (device vdd): ext4_mb_generate_buddy:741: group 30, 322=
54 clusters in bitmap, 32258 in gd
>
> This problem can be reproduced via:
>
> =A0 =A0mke2fs -q -t ext4 -O ^flex_bg /dev/vdd 5g
> =A0 =A0mount -t ext4 /dev/vdd /mnt
> =A0 =A0fallocate -l 4600m /mnt/test
>
> The problem was caused by a bone headed mistake in the check to see i=
f a
> particular metadata block was part of the block group.
>
> Many thanks to Kees Cook for finding and bisecting the buggy commit
> which introduced this bug (commit fd034a84e1, present since v3.2).
>
> Reported-by: Sander Eikelenboom <linux@eikelenboom.it>
> Reported-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Cc: stable@kernel.org
> Cc: Sander Eikelenboom <linux@eikelenboom.it>
> Cc: Kees Cook <keescook@chromium.org>

Tested-by: Kees Cook <keescook@chromium.org>

Thanks! I can confirm that this fixes it.

-Kees

--=20
Kees Cook
Chrome OS Security
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
