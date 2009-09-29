From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Question on fallocate/ftruncate sequence
Date: Tue, 29 Sep 2009 14:55:28 -0500
Message-ID: <4AC26630.6030509@redhat.com>
References: <1248389165.17459.3.camel@bobble.smo.corp.google.com>	 <5df78e1d0908281740w7bc0f283x5004ca5b231b3af5@mail.gmail.com>	 <20090830025250.GA25768@mit.edu>	 <5df78e1d0908311240s3205b4bcrb65b2552b4ed579c@mail.gmail.com>	 <20090831215612.GG4197@webber.adilger.int>	 <5df78e1d0908311633k1f16a096t701e0cdab54b174c@mail.gmail.com>	 <20090902084134.GO4197@webber.adilger.int>	 <5df78e1d0909022220m1152b313o92f6cb7cc8858298@mail.gmail.com>	 <5df78e1d0909232227y2cb52abew827d7732a3bc9040@mail.gmail.com>	 <4AC25CCB.8050805@redhat.com> <5df78e1d0909291238q44bbf9e8q98205ffa9b6b2518@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>, Theodore Tso <tytso@mit.edu>,
	Frank Mayhar <fmayhar@google.com>,
	Curt Wohlgemuth <curtw@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Jiaying Zhang <jiayingz@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61811 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754035AbZI2Tzb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Sep 2009 15:55:31 -0400
In-Reply-To: <5df78e1d0909291238q44bbf9e8q98205ffa9b6b2518@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jiaying Zhang wrote:
> On Tue, Sep 29, 2009 at 12:15 PM, Eric Sandeen <sandeen@redhat.com> wrote:
>> Jiaying Zhang wrote:
>>> Sorry for taking so long to finish this. Here is the new patch based on
>>> Andreas's suggestions. Now the patch clears the EXT4_EOFBLOCKS_FL
>>> flag when we allocate beyond the maximum allocated block. I also
>>> made the EOFBLOCKS flag user visible and added the handling
>>> in ext4_ioctl as Andrea suggested.
>> I was testing this a bit in xfstests, with test 083 (recently I sent a
>> patch to the xfs list to let that test run on generic filesystems) which
>> runs fsstress on a small-ish 100M fs, and that fsstress does space
>> preallocation (on newer kernels, where the older xfs ioctls are hooked
>> up to do_fallocate in a generic fashion).
> 
> Does the fsstress use fallocate with KEEP_SIZE?

Effectively, yes.   It uses the compatible xfs ioctls, which calls
do_fallocate with KEEP_SIZE.

>> I'm actually seeing more corruption w/ this patch than without it,
>> though I don't yet see why.  I'll double check that it applied properly,
>> since this was against 2.6.30.5....
> 
> Do you want me to port my changes to the latest ext4 git tree?
> I should have done so at the beginning.

Sure :)

>> Also it strikes me as a little odd to allow clearing of the EOF Flag
>> from userspace, and the subsequent discarding of the blocks past EOF.
>>
>> Doesn't truncating to i_size do exactly the same thing, in a more
>> portable way?  Why make a new interface unique to ext4?
> 
> As Andreas suggested, I think the main purpose is to allow users
> to scan for any files with EOF flag with the getflag ioctl. We may
> not allow users to clear it with the setflag ioctl but just rely on
> the truncate interface, but supporting the setflag ioctl interface
> doesn't seem to do any harm.

I like the idea of being able to find them, but adding the clearing
interface seems redundant to me.  All filesystems would need to
implement this, and I don't see that we gain anything.

Thanks,
-Eric

> Jiaying
