From: Autif Khan <autif.mlist@gmail.com>
Subject: Re: Filesystem state: clean with errors - what errors?
Date: Thu, 20 Jun 2013 19:01:53 -0400
Message-ID: <CADzUK1Lw641ythFjKP6wK-CKvUcLMFrkY7=oQQo9KmaqgZOvoQ@mail.gmail.com>
References: <CADzUK1K08XjYuz_Mrv6sF8e7-M9ToStfjN7e7s3v+2q9wX+-xQ@mail.gmail.com>
	<51ACEAEF.6040109@redhat.com>
	<CADzUK1KXvQbb+jUK=JpYLXD1S+-dCLnYRU8Dc+mPDf3b4ipU8A@mail.gmail.com>
	<51ACEFA8.8000907@redhat.com>
	<CADzUK1JvWW=YkS2e1gZM=Zt3SDKbhLhqH0_i_UnVLhBY51r2Nw@mail.gmail.com>
	<51ACF922.2050306@redhat.com>
	<CADzUK1JyZA=2+yn7K30K5te-cZTiS0RY9L8YYKn+Dr1JxhHOtQ@mail.gmail.com>
	<CADzUK1+fVXBWjuhEJpQp3skSkxxa7oM=KKM370LacVAyqY0TeQ@mail.gmail.com>
	<20130604134938.GC23132@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ea0-f173.google.com ([209.85.215.173]:57935 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965356Ab3FTXBz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Jun 2013 19:01:55 -0400
Received: by mail-ea0-f173.google.com with SMTP id g15so4308546eak.4
        for <linux-ext4@vger.kernel.org>; Thu, 20 Jun 2013 16:01:53 -0700 (PDT)
In-Reply-To: <20130604134938.GC23132@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I am happy to report that upgrading from 1.42 to 1.42.7 has resolved
most of the issues. There is still one vendor where we are getting
corruption and we will avoid that vendor. We are small fish.

Thanks a lot to everyone that helped - specifically Eric, Ted and DJW

On Tue, Jun 4, 2013 at 9:49 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> Hmm... what version of e2fsprogs are you using?  Is there any chance
> it's older than 1.42.4?  Hmmm, yes, you're using a positively ancient
> (and filled with bugs that have since been fixed e2fsprogs 1.42).
>
> I suspect you're getting hit bug a problem which we fixed in e2fsprogs
> 1.42.4 (and you *REALLY* want to upgrade to the latest released
> version of e2fsprogs):
>
>    Fixed e2fsck's handling of the journal's s_errno field.  E2fsck was
>    not properly propagating the journal's s_errno field to the superblock
>    field; it was not checking this field if the journal had already been
>    replayed, and if the journal *was* being replayed, the "error bit"
>    wasn't getting flushed out to disk.
>
> The kernel side fix for this particular issue (if this is what is
> going on) is:
>
> commit d796c52ef0b71a988364f6109aeb63d79c5b116b
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Sun Aug 5 19:04:57 2012 -0400
>
>     ext4: make sure the journal sb is written in ext4_clear_journal_err()
>
>     After we transfer set the EXT4_ERROR_FS bit in the file system
>     superblock, it's not enough to call jbd2_journal_clear_err() to clear
>     the error indication from journal superblock --- we need to call
>     jbd2_journal_update_sb_errno() as well.  Otherwise, when the root file
>     system is mounted read-only, the journal is replayed, and the error
>     indicator is transferred to the superblock --- but the s_errno field
>     in the jbd2 superblock is left set (since although we cleared it in
>     memory, we never flushed it out to disk).
>
>     This can end up confusing e2fsck.  We should make e2fsck more robust
>     in this case, but the kernel shouldn't be leaving things in this
>     confused state, either.
>
>     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
>     Cc: stable@kernel.org
>
> ... which first appeared in the 3.6 kernel, and which for some reason
> was never backported to the 3.2 stable series.
>
> Regards,
>
>                                                 - Ted
