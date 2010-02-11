From: Kailas Joshi <kailas.joshi@gmail.com>
Subject: Re: Help on Implementation of EXT3 type Ordered Mode in EXT4
Date: Thu, 11 Feb 2010 13:02:15 +0530
Message-ID: <38f6fb7d1002102332v3482ef49xb2afd5931c5eb2ad@mail.gmail.com>
References: <loom.20100204T064311-880@post.gmane.org>
	 <20100209160522.GE15318@atrey.karlin.mff.cuni.cz>
	 <20100209174145.GU4494@thunk.org>
	 <38f6fb7d1002102301x278c3ddt153f570dd1423074@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, Jan Kara <jack@suse.cz>,
	Jiaying Zhang <jiayingz@google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-px0-f184.google.com ([209.85.216.184]:39668 "EHLO
	mail-px0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab0BKHcQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Feb 2010 02:32:16 -0500
Received: by pxi14 with SMTP id 14so629125pxi.20
        for <linux-ext4@vger.kernel.org>; Wed, 10 Feb 2010 23:32:15 -0800 (PST)
In-Reply-To: <38f6fb7d1002102301x278c3ddt153f570dd1423074@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11 February 2010 12:31, Kailas Joshi <kailas.joshi@gmail.com> wrote:
>
> On 9 February 2010 23:11, <tytso@mit.edu> wrote:
>>
>> On Tue, Feb 09, 2010 at 05:05:22PM +0100, Jan Kara wrote:
>> > =A0 Hi,
>> >
>> > > I recently found that in EXT4 with delayed block the Ordered mod=
e does not
>> > > bahave same as in EXT3.
>> > > I found a patch for this at http://lwn.net/Articles/324023/, but=
 it has some
>> > > journal block estimation problem resulting into deadlock.
>> > >
>> > > I would like to know if it has been solved.
>> > > If not, is it possible to solve it? What are the complexities in=
volved?
>> >
>> > It has not been solved. The problem is that to commit data on
>> > transaction commit (which is what data=3Dordered mode has historic=
ally
>> > done), you have to allocate space for these blocks. But that
>> > allocation needs to modify a filesystem and thus journal more
>> > blocks... And that is tricky - we would have to reserve space in t=
he
>> > current transaction for allocation of delayed data. =A0So it gets =
a
>> > bit messy...
>>
>> The dioread_nolock patches from Jiaying, which are currently in the
>> unstable portion of the tree, is a partial solution to the
>> data=3Dordered problem, although it solves it in a slightly differen=
t
>> way.
>>
>> As a side effect of trying to avoid locking on the direct I/O read
>> path, on the buffered I/O write path it changes things so the extent
>> tree is first changed so the blocks are allocated with the "extent
>> uninitialized" bit, and then only after the blocks hit the disk, via
>> the bh completion callback, do we set the extent so that it is marke=
d
>> as containing initialized data.
>>
>> As a result, if you crash before the extent tree is updated, when yo=
u
>> read from the file, you will get all zero's, instead of the data, th=
us
>> preventing the security leak.
>>
>> It does mean that fsync() is slightly slower, since we now have to
>> flush the data blocks out, wait for the completion handler to fire a=
nd
>> update the extent in the same jbd2 transaction, and only then wait f=
or
>> the barrier in the jbd2 transaction. =A0(And in fact, I'm not sure
>> fsync() is completely working correctly in the current patch in the
>> unstable patch stream, and there aren't race conditions where the
>> extent tree update slips into the next transaction.) =A0But it does
>> solve the problem.
>>
>> The other downside with this solution is that it only works for file=
s
>> that are extent-mapped, and if you do this with a converted ext3 fil=
e
>> system, and there are files that are still mapped using
>> direct/indirect blocks, when you change the mount option to be
>> data=3Dwriteback,dioread_nolock, the block allocating writes to thes=
e
>> legacy files could result in data getting exposed after a crash.
>>
>> Depending on the workload the upside is that by using data=3Dwriteba=
ck
>> instead of data=3Dordered could far outweigh the downside of needing=
 to
>> do an extra block I/O queue flush before the fsync, since it reduces
>> the number of entangled writes to only the metadata blocks, where
>> previously the entagled write problem affected metadata blocks plus
>> all freshly allocated blocks.
>>
>> Kalias, this is something that I plan to look in the near future; if
>> you are interested in helping to benchmark and characterize this
>> solution, I'd be very interested in working with you. =A0Can you tel=
l me
>> a little more about your use case and requirements?
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0- Ted
>

Jan and Ted, thank you very much for detailed replies.

We are assessing the use of copy-on-write technique to provide data
level consistency in EXT3/EXT4. We have implemented this in EXT3 by
using the Ordered mode of operation. Benchmark results for IOZone and
Postmark are quiet good. We could get the consistency equivalent to
Journal mode with the overhead almost same as Ordered mode. However,
there are few cases(for example, file rewrite) where performance of
Journal mode is better than our technique. We think that in EXT4, with
the support for delayed block allocation and extents, these problems
can be removed.

However, Ordered mode with delayed block allocation in EXT4 does not
behave in the same way as in EXT3. It does not flush 'all' dirty
blocks to the disk as in EXT3. For implementing our technique in EXT4,
we need EXT3 style Ordered mode, that is
alloc_on_commit(http://lwn.net/Articles/324023/).

I understand that this is not required in EXT4 since the Ordered mode
is provided for security and not consistency. However, from the
discussions on blogs/post, it seems that developers expect Ordered
mode to provide (limited) data consistency as well.

Since the implementation of our technique heavily depends on EXT3
style Ordered mode, I would like to implement alloc_on_commit on EXT4.
I have designed following strategy to address credit reservation
problem in earlier patch. Please let me know your comments on it.

1. In Write path, the call to journal_start() for updating metadata
will reserve credits for delayed allocation also.
2. If the fs is mounted with alloc_on_commit, journal_stop() will not
return remaining credits to the journal (t_outstanding_credits will
not be changed).
3. In journal_commit() -
i. After LOCKing the current transaction, a new special handle will be
created by calling journal_start() with zero credits . Such a call to
journal_start() can be treated as a special case for creating handle
to use accumulated credits (in t_outstanding_credits) of currently
locked transaction.
ii. Before changing transaction state to FLUSH, callback will be used
to perform delayed block allocation for all inodes. This mechanism
will be same as in alloc_on_commit at http://lwn.net/Articles/324023/
, but it will be performed after changing the transaction to LOCKED
state. In the callback, specially created handle will passed to the
callback function and it will use that handle for performing delayed
block allocation.
iii. The special handle will be closed, outstanding credits for
transaction will be zeroed and the transaction flush will continue.

Regarding dioread_nolock work:
Ted, I am new in filesystem development. If this is fine and your
deadlines are not very critical, I will be very happy to work with you
on dioread_nolock even though its not directly related to our current
work. Please let me know more on this.

Thanks & Regards,
Kailas
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
