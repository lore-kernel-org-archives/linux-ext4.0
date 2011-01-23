From: Manish Katiyar <mkatiyar@gmail.com>
Subject: Re: [PATCH 1/3] jbd2 : Make jbd2 transaction handle allocation to
 return errors and handle them gracefully.
Date: Sat, 22 Jan 2011 21:53:40 -0800
Message-ID: <AANLkTi=XeH7a_i4T6jT8LvwZrJfU58Fr8+Oi0d0hbxrd@mail.gmail.com>
References: <AANLkTi=o-rcsbY1gOExGyWdQ41m7KWpJ7=UzX4306m=t@mail.gmail.com> <20110123054049.GC3237@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, ext4 <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:40319 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab1AWFyD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 23 Jan 2011 00:54:03 -0500
Received: by qyk12 with SMTP id 12so3370128qyk.19
        for <linux-ext4@vger.kernel.org>; Sat, 22 Jan 2011 21:54:02 -0800 (PST)
In-Reply-To: <20110123054049.GC3237@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jan 22, 2011 at 9:40 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Sat, Jan 22, 2011 at 07:32:44PM -0800, Manish Katiyar wrote:
>> =A0Hi Jan,
>>
>> This is the follow up from https://lkml.org/lkml/2011/1/17/154
>> Following patches make jbd2 to use GFP_KERNEL for transaction
>> allocation if the caller can handle the errors. Following is the lis=
t
>> of functions that I updated to pass the new flag. Also below is the
>> list of functions which still have the old behavior and pass the old
>> flags (either because they can't deal with errors, or I wasn't too
>> sure so I did conservatively). Appreciate your feedback. The other
>> callers of jbd2_journal_start() are from ocfs2, they still pass the
>> old flag.
>
> Hmm, I wonder if it would be better to use
>
> jbd2_journal_start(...)
>
> and
>
> jbd2_journal_start_nofail(...)
>
> The tradeoff is that long-term, the code is more readable (as opposed
> to having people look up what a random "true" or "false" value means)=
=2E
> But short-term, while it will make the patch smaller, it also makes
> the patch harder audit, since we need to look at all of the places
> where we _haven't_ made a change to make sure those call sites can
> tolerate an error return.

Yes, a new interface is better but wasn't too sure. If the reviewers
feel that is the way to go I can redo. Infact if
this version makes review easier, then once these changes look ok and
agreed, I can submit an updated version with these
changes applied using the new interface. Will that make sense ?

--=20
Thanks -
Manish
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
