From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH] ext4: Avoid creating new file in append-only dir when
 open(2) return error
Date: Sun, 30 Oct 2011 09:23:47 +0800
Message-ID: <CA+dCu8_bMXy3FN9BWFUwCcg4=peH93Mv7CcypShfQETA71Hebw@mail.gmail.com>
References: <1319824961-5587-1-git-send-email-guaneryu@gmail.com> <20111029185421.GA16825@thunk.org>
Reply-To: guaneryu@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64010 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932655Ab1J3BYJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 29 Oct 2011 21:24:09 -0400
Received: by iaby12 with SMTP id y12so5609141iab.19
        for <linux-ext4@vger.kernel.org>; Sat, 29 Oct 2011 18:24:08 -0700 (PDT)
In-Reply-To: <20111029185421.GA16825@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Oct 30, 2011 at 2:54 AM, Ted Ts'o <tytso@mit.edu> wrote:
> On Sat, Oct 29, 2011 at 02:02:41AM +0800, Eryu Guan wrote:
>> Newly created file on ext4 inherits inode flags from parent director=
y,
>> so new inode created in append-only directory has S_APPEND flag set,
>> may_open() called by do_last() checks that flag then returns -EPERM,
>> but at that time the new inode is already created.
>
> I have the following patch in the ext4 tree that should take care of
> this issue for ext2/3/4.
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0- Ted
>
> ext2,ext3,ext4: don't inherit APPEND_FL or IMMUTABLE_FL for new inode=
s
>
> This doesn't make much sense, and it exposes a bug in the kernel wher=
e
> attempts to create a new file in an append-only directory using
> O_CREAT will fail (but still leave a zero-length file). =A0This was
> discovered when xfstests #79 was generalized so it could run on all
> file systems.
>

I also found this by checking xfstests 079 and wanted to fix it in a wa=
y not
changing the current behavior. Masking out EXTN_APPEND_FL from inherit =
bits
makes more sense.

I think I should resend the comment cleanup part.

Thanks!

Eryu Guan
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
