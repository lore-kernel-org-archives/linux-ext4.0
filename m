From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: [PATCH 3/4] ext4: clone indirect.c file from inode.c
Date: Tue, 28 Jun 2011 10:02:45 +0300
Message-ID: <BANLkTimxd=5DF41cm19MEj0OMU0POha8jg@mail.gmail.com>
References: <1308649168-12543-1-git-send-email-amir73il@users.sourceforge.net>
	<1308649168-12543-4-git-send-email-amir73il@users.sourceforge.net>
	<20110627234156.GG2729@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40649 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756005Ab1F1HCs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Jun 2011 03:02:48 -0400
Received: by wyg8 with SMTP id 8so1538203wyg.19
        for <linux-ext4@vger.kernel.org>; Tue, 28 Jun 2011 00:02:45 -0700 (PDT)
In-Reply-To: <20110627234156.GG2729@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 28, 2011 at 2:41 AM, Ted Ts'o <tytso@mit.edu> wrote:
> On Tue, Jun 21, 2011 at 12:39:27PM +0300, amir73il@users.sourceforge.=
net wrote:
>> From: Amir Goldstein <amir73il@users.sf.net>
>>
>> The next patch is going to move ext4_ind_ functions to
>> indirect.c. First, we clone the file from inode.c and
>> only leave code that is going to be duplicated in both files.
>> This should keep the deleted lines count from inode.c in the next
>> patch the same as the added lines count to indirect.c.
>
> I really dislike cloning functions. =A0This becomes a maintenance
> headache, since bugs that get fixed in one file might not get
> propagated to another. =A0Since I need to manually move all of the
> functions to verify nothing else changed in patches that do massive
> code movement, I used the first two patches in your patch series, but
> replaced the last two patches in the patch series, and replaced it
> with the following:
>
> A) Move __ext4_check_blockref() to fs/ext4/block_validity.c and
> declare it extern.
>
> B) Move ext4_truncate_failed_write() and blocks_for_truncate() to a
> new function, fs/ext4/truncate.h.

Nice cleanups!

>
> C) Movement of indirect-related code to fs/ext4/indirect.c.
>

Hmm.. in my patch the deleted lines from inode.c matched
the added lines in indirect.c (-1 newline at end of file).
Your patch has:
 fs/ext4/indirect.c       | 1510 ++++++++++++++++++++++++++++++++++++++=
++++++++
 fs/ext4/inode.c          | 1486 --------------------------------------=
-------

This accounts for 28 lines added by header comment and includes in indi=
rect.c
-1 newline at end of file, so where did 3 more lines go?
I am guessing these are just deleted newlines, but have no way of knowi=
ng.
Have you made other (maybe checkpatch) changes while moving or just
removed 'static'
from function declarations?
I am asking just in case I get 'git blamed' for it some day ;-)

Cheers,
Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
