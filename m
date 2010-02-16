From: Kailas Joshi <kailas.joshi@gmail.com>
Subject: Re: Help on Implementation of EXT3 type Ordered Mode in EXT4
Date: Tue, 16 Feb 2010 15:40:22 +0530
Message-ID: <38f6fb7d1002160210x6dc86fb5o82825e7677c07994@mail.gmail.com>
References: <loom.20100204T064311-880@post.gmane.org>
	 <20100209160522.GE15318@atrey.karlin.mff.cuni.cz>
	 <20100209174145.GU4494@thunk.org>
	 <38f6fb7d1002102301x278c3ddt153f570dd1423074@mail.gmail.com>
	 <38f6fb7d1002102332v3482ef49xb2afd5931c5eb2ad@mail.gmail.com>
	 <20100211195624.GM739@thunk.org>
	 <38f6fb7d1002111922i4ae6131w6b5cce79344efc63@mail.gmail.com>
	 <20100212200726.GD5337@thunk.org>
	 <38f6fb7d1002130043s54e61e74jcc3297aeeac294b0@mail.gmail.com>
	 <20100215150021.GE3434@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org,
	Jiaying Zhang <jiayingz@google.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f187.google.com ([209.85.222.187]:44106 "EHLO
	mail-pz0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932476Ab0BPKKW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Feb 2010 05:10:22 -0500
Received: by pzk17 with SMTP id 17so4883477pzk.4
        for <linux-ext4@vger.kernel.org>; Tue, 16 Feb 2010 02:10:22 -0800 (PST)
In-Reply-To: <20100215150021.GE3434@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 15 February 2010 20:30, Jan Kara <jack@suse.cz> wrote:
> On Sat 13-02-10 14:13:17, Kailas Joshi wrote:
>> On 13 February 2010 01:37, =A0<tytso@mit.edu> wrote:
>> > On Fri, Feb 12, 2010 at 08:52:15AM +0530, Kailas Joshi wrote:
>> >> Sorry, I didn't understand why processes need to be suspended.
>> >> In my scheme, I am issuing magic handle only after locking the cu=
rrent
>> >> transaction. =A0AFAIK after the transaction is locked, it can rec=
eive the
>> >> block journaling requests for already created handles(in our case=
, for
>> >> already reserved journal space), and the new concurrent requests =
for
>> >> journal_start() will go to the new current transaction. Since, th=
e
>> >> credits for locked transaction are fixed (by means of early
>> >> reservations) we can know whether journal has enough space for th=
e new
>> >> journal_start(). So, as long as journal has enough space availabl=
e,
>> >> new processes need now be stalled.
>> >
>> > But while you are modifying blocks that need to go into the journa=
l
>> > via the locked (old) transaction, it's not safe to start a new
>> > transaction and start issuing handles against the new transaction.
>> >
>> > Just to give one example, suppose we need to update the extent
>> > allocation tree for an inode in the locked/committing transaction =
as
>> > the delayed allocation blocks are being resolved --- and in anothe=
r
>> > process, that inode is getting truncated or unlinked, which also n=
eeds
>> > to modify the extent allocation tree? =A0Hilarty ensues, unless yo=
u use
>> > a block all attempts to create a new handle (practically speaking,=
 by
>> > blocking all attempts to start a new transaction), until this new
>> > delayed allocation resolution phase which you have proposed is
>> > complete.
>> Okay. So, basically process stalling is unavoidable as we cannot
>> modify a buffer data in past transaction after it has been modified =
in
>> current transaction.
>> Can we restrict the scope for this blocking? Blocking on
>> journal_start() will block all processes even though they are
>> operating on mutually exclusive sets of metadata buffers. Can we
>> restrict this blocking to allocation/deallocation paths by blocking =
in
>> get_write_access() on specific cases(some condition on buffer)? This
>> way, since all files will use commit-time allocation, very few(sync
>> and direct-io mode) file operations will be stalled.
> =A0I doubt blocking at buffer-level would be enough. I think that the
> journalling layer just does not have enough information for such deci=
sions.
> It could be feasible to block on per-inode basis but you'd still have=
 to
> give a good thought to modification of filesystem global structures l=
ike
> bitmaps, superblock, or inode blocks.
Okay. So, blocking at buffer level will not be easy as global
structures shared among inodes will need modifications(for example,
changing access time for a file in inode block).

One last doubt, while looking at the code, I saw that journal_start()
always stalls all file operations while currently running transaction
is in LOCKED state. Only when the current transaction moves to FLUSH,
the new transaction is created and the stalled operations continue. Is
this interpretation correct?
If yes, why this stalling does not have significant negative impact on
performance of file operations? Also, if it does not have, will
stalling for delayed block allocation really have such significant
negative impact?

Please reply.

Thanks & Regards,
Kailas
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
