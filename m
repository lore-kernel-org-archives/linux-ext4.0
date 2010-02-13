From: Kailas Joshi <kailas.joshi@gmail.com>
Subject: Re: Help on Implementation of EXT3 type Ordered Mode in EXT4
Date: Sat, 13 Feb 2010 14:13:17 +0530
Message-ID: <38f6fb7d1002130043s54e61e74jcc3297aeeac294b0@mail.gmail.com>
References: <loom.20100204T064311-880@post.gmane.org>
	 <20100209160522.GE15318@atrey.karlin.mff.cuni.cz>
	 <20100209174145.GU4494@thunk.org>
	 <38f6fb7d1002102301x278c3ddt153f570dd1423074@mail.gmail.com>
	 <38f6fb7d1002102332v3482ef49xb2afd5931c5eb2ad@mail.gmail.com>
	 <20100211195624.GM739@thunk.org>
	 <38f6fb7d1002111922i4ae6131w6b5cce79344efc63@mail.gmail.com>
	 <20100212200726.GD5337@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Jiaying Zhang <jiayingz@google.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-px0-f191.google.com ([209.85.216.191]:48847 "EHLO
	mail-px0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886Ab0BMInS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 13 Feb 2010 03:43:18 -0500
Received: by pxi29 with SMTP id 29so2003210pxi.1
        for <linux-ext4@vger.kernel.org>; Sat, 13 Feb 2010 00:43:17 -0800 (PST)
In-Reply-To: <20100212200726.GD5337@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 13 February 2010 01:37,  <tytso@mit.edu> wrote:
> On Fri, Feb 12, 2010 at 08:52:15AM +0530, Kailas Joshi wrote:
>> Won't this get fixed by performing early reservations as mentioned i=
n
>> my scheme? We are reserving required credits in the path of write
>> system call and these will be kept reserved until transaction commit=
=2E
>> So, the journal space for allocation at commit will be guaranteed.
>
> Yes, if you account for these separately. =A0One challenge is
> over-estimating the needed credits will be tricky. =A0If we go down t=
his
> path, be sure that the bonnie style write(fd, &ch, 1) in a tight loop
> doesn't end up reserving a separate set of credits for each write
> system call to the same block. =A0(It can be done; if the DA block is
> already instantiated, you can assume that credits have already been
> reserved.)
Okay

>> Sorry, I didn't understand why processes need to be suspended.
>> In my scheme, I am issuing magic handle only after locking the curre=
nt
>> transaction. =A0AFAIK after the transaction is locked, it can receiv=
e the
>> block journaling requests for already created handles(in our case, f=
or
>> already reserved journal space), and the new concurrent requests for
>> journal_start() will go to the new current transaction. Since, the
>> credits for locked transaction are fixed (by means of early
>> reservations) we can know whether journal has enough space for the n=
ew
>> journal_start(). So, as long as journal has enough space available,
>> new processes need now be stalled.
>
> But while you are modifying blocks that need to go into the journal
> via the locked (old) transaction, it's not safe to start a new
> transaction and start issuing handles against the new transaction.
>
> Just to give one example, suppose we need to update the extent
> allocation tree for an inode in the locked/committing transaction as
> the delayed allocation blocks are being resolved --- and in another
> process, that inode is getting truncated or unlinked, which also need=
s
> to modify the extent allocation tree? =A0Hilarty ensues, unless you u=
se
> a block all attempts to create a new handle (practically speaking, by
> blocking all attempts to start a new transaction), until this new
> delayed allocation resolution phase which you have proposed is
> complete.
Okay. So, basically process stalling is unavoidable as we cannot
modify a buffer data in past transaction after it has been modified in
current transaction.
Can we restrict the scope for this blocking? Blocking on
journal_start() will block all processes even though they are
operating on mutually exclusive sets of metadata buffers. Can we
restrict this blocking to allocation/deallocation paths by blocking in
get_write_access() on specific cases(some condition on buffer)? This
way, since all files will use commit-time allocation, very few(sync
and direct-io mode) file operations will be stalled.

I am not sure whether this is feasible or not. Please let me know more =
on this.

Thanks & Regards,
Kailas
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
