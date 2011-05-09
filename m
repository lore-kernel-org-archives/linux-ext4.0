From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: [PATCH v2 1/5] ext4: move ext4_add_groupblocks() to mballoc.c
Date: Mon, 9 May 2011 19:01:21 +0300
Message-ID: <BANLkTin1RxqaxZFvQP7M7hyLcg0q-KpP1g@mail.gmail.com>
References: <1300985893-4371-1-git-send-email-amir73il@users.sourceforge.net>
	<1300985893-4371-2-git-send-email-amir73il@users.sourceforge.net>
	<20110509145453.GB19811@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:47433 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904Ab1EIQBY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 May 2011 12:01:24 -0400
Received: by ewy4 with SMTP id 4so1583906ewy.19
        for <linux-ext4@vger.kernel.org>; Mon, 09 May 2011 09:01:22 -0700 (PDT)
In-Reply-To: <20110509145453.GB19811@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 9, 2011 at 5:54 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Thu, Mar 24, 2011 at 06:58:09PM +0200, amir73il@users.sourceforge.=
net wrote:
>> From: Amir Goldstein <amir73il@users.sf.net>
>>
>> In preparation for the next patch, the function ext4_add_groupblocks=
()
>> is moved to mballoc.c, where it could use some static functions.
>>
>> I also fixed a checkpatch warning and replaced obsolete get_undo_acc=
ess
>> for bitmap with get_write_access.
>>
>> Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
>
> Please don't move code and make changes in one patch. =A0#1, it's har=
d
> to review changes that happened in the middle of code movement. =A0#2=
,
> if there has been any changes in the source function caused by other
> patches, I can't regenerate a patch by simply redoing the function
> move --- I have to reverse engineer the change that happened under th=
e
> cover of code movement, regnerate the patch, and then redo the change=
=2E
>

Sorry for the trouble. At least I (sort of) documented the change in th=
e commit
description, so I hope it wasn't too hard to reverse engineer...
=46ixing the checkpatch error I just kind of felt obligated to do, chan=
ging
get_undo_access to get_write_access in this patch was just me being laz=
y.


> I've split this into two patches, one which is just a simple code
> movement (note that I also moved the function declaration in ext4.h s=
o
> it function is listed under the correct .c file), and the second whic=
h
> changed the use of ext4_journal_get_undo_access to
> ext4_journal_get_write_access. =A0Since this was also the last use of
> ext4_journal_get_undo_access(), I also removed the now-unneeded code
> in ext4_jbd2.[ch].
>

Thanks. FYI, in one of the snapshot patches this get_write_access insta=
nce is
replaced with get_bitmap_access (which calls a different snapshot hook)=
=2E
That patch also removes the get_undo_access function, but now you beat
me to it :-)

=46YI2, the snapshot patches are waiting in my outbox for me to push se=
nd.
When running xfstests I caught a hang in test 225 with 1K blocksize
(all other tests were fine),
so I asked Yongqiang to take a look at it because his patch (6d9c85) ha=
d fixed
a problem in test 225. He just said that the hang was caused by a bug
in his patch
and that the hang happen with tytso/master branch and that he is
working on a fix,
so I may just go a head and send out the snapshot patches anyway.



> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0- Ted
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
