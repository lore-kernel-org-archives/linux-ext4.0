From: Kailas Joshi <kailas.joshi@gmail.com>
Subject: Re: Help on Implementation of EXT3 type Ordered Mode in EXT4
Date: Fri, 12 Feb 2010 08:52:15 +0530
Message-ID: <38f6fb7d1002111922i4ae6131w6b5cce79344efc63@mail.gmail.com>
References: <loom.20100204T064311-880@post.gmane.org>
	 <20100209160522.GE15318@atrey.karlin.mff.cuni.cz>
	 <20100209174145.GU4494@thunk.org>
	 <38f6fb7d1002102301x278c3ddt153f570dd1423074@mail.gmail.com>
	 <38f6fb7d1002102332v3482ef49xb2afd5931c5eb2ad@mail.gmail.com>
	 <20100211195624.GM739@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Jiaying Zhang <jiayingz@google.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f172.google.com ([209.85.222.172]:33558 "EHLO
	mail-pz0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab0BLDWP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Feb 2010 22:22:15 -0500
Received: by pzk2 with SMTP id 2so1544574pzk.21
        for <linux-ext4@vger.kernel.org>; Thu, 11 Feb 2010 19:22:15 -0800 (PST)
In-Reply-To: <20100211195624.GM739@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12 February 2010 01:26,  <tytso@mit.edu> wrote:
> I've mostly given up on trying to get alloc_on_commit work, for two
> reasons.
>
> The first is that one of the reasons why you might be closing the
> transaction is if there's not enough space left in the journal. =A0Bu=
t
> if we you going to a large number of data allocations at commit time,
> there's no guaratee that there will be space in the journal for all o=
f
> the metadata blocks that might have to be modified in order to make
> the block allocations.
Won't this get fixed by performing early reservations as mentioned in
my scheme? We are reserving required credits in the path of write
system call and these will be kept reserved until transaction commit.
So, the journal space for allocation at commit will be guaranteed.

>
> The second problem with this scheme is a performance problem; while
> you are doing handling delayed allocation blocks, you have to do this
> while the journal is still locked, using magic handles that are
> allowed to be created while the journal is locked. =A0That adds all
> sorts of complexity, and that seems to what you are thinking about
> doing. =A0The problem though is that while this is going on, all othe=
r
> file system activity has to be blocked. =A0So this will cause all sor=
ts
> of processes to become suspended waiting for the all of the allocatio=
n
> activity to complete, which may require bitmap allocation blocks to b=
e
> read into disk, etc.
Sorry, I didn't understand why processes need to be suspended.
In my scheme, I am issuing magic handle only after locking the current
transaction. AFAIK after the transaction is locked, it can receive the
block journaling requests for already created handles(in our case, for
already reserved journal space), and the new concurrent requests for
journal_start() will go to the new current transaction. Since, the
credits for locked transaction are fixed (by means of early
reservations) we can know whether journal has enough space for the new
journal_start(). So, as long as journal has enough space available,
new processes need now be stalled.

Please correct me if this is wrong.


> The trade off for all of these problems is that it allows you to dela=
y
> the block allocation for only 5 seconds. =A0The question is, is this
> worth it, compared with simply mounting the file system with
> nodelalloc? =A0It may be all of this complexity doesn't produce enoug=
h
> of a performance gain over simply using nodelalloc.
I agree. The performance gain might not be good enough compared to
'nodelalloc'. However, our goal is providing data consistency
equivalent to Journal mode at low cost. So, we are interested in
comparing performance of alloc_on_commit (and our technique) with
performance of Journal mode.

Thanks & Regards,
Kailas
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
