From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: ext4_fallocate
Date: Tue, 26 Jun 2012 14:21:24 -0400
Message-ID: <4FE9FDA4.60509@redhat.com>
References: <4FE8086F.4070506@zoho.com> <20120625085159.GA18931@gmail.com> <20120625191744.GB9688@thunk.org> <4FE9B57F.4030704@redhat.com> <20120626173050.GA6745@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Fredrick <fjohnber@zoho.com>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger@dilger.ca>, wenqing.lz@taobao.com
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7469 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758816Ab2FZSUj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Jun 2012 14:20:39 -0400
In-Reply-To: <20120626173050.GA6745@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 06/26/2012 01:30 PM, Theodore Ts'o wrote:
> On Tue, Jun 26, 2012 at 09:13:35AM -0400, Ric Wheeler wrote:
>> Has anyone made progress digging into the performance impact of
>> running without this patch? We should definitely see if there is
>> some low hanging fruit there, especially given that XFS does not
>> seem to suffer such a huge hit.
> I just haven't had time, sorry.  It's so much easier to run with the
> patch.  :-)
>
> Part of the problem certainly caused by the fact that ext4 is using
> physical block journaling instead of logical journalling.  But we see
> the problem in no-journal mode as well.  I think part of the problem
> is simply that many of the workloads where people are doing this, they
> also care about robustness after power failures, and if you are doing
> random writes into uninitialized space, with fsyncs in-between, you
> are basically guaranteed a 2x expansion in the number of writes you
> need to do to the system.

It would be interesting to see if simply not doing the preallocation would be 
easier and safer. Better yet, figure out how to leverage trim commands to safely 
allow us to preallocate and not expose other users' data (and not have to mark 
the extents as allocated but not written).

If we did that, we would have the performance boost without the security hole.

>
> One other thing which we *have* seen is that we need to do a better
> job with extent merging; if you run without this patch, and you run
> with fio in AIO mode where you are doing tons and tons of random
> writes into uninitialized space, you can end up fragmenting the extent
> tree very badly.   So fixing this would certainly help.

Definitely sounds like something worth fixing.

>
>> Opening this security exposure is still something that is clearly a
>> hack and best avoided if we can fix the root cause :)
> See Linus's recent rant about how security arguments made by
> theoreticians very often end up getting trumped by practical matters.
> If you are running a daemon, whether it is a user-mode cluster file
> system, or a database server, where it is (a) fundamentally trusted,
> and (b) doing its own user-space checksuming and its own guarantees to
> never return uninitialized data, even if we fix all potential
> problems, we *still* can be reducing the number of random writes ---
> and on a fully loaded system, we're guaranteed to be seek-constrained,
> so each random write to update fs metadata means that you're burning
> 0.5% of your 200 seeks/second on your 3TB disk (where previously you
> had half a dozen 500gig disks each with 200 seeks/second).

This is not a theory guy worry. I would not use any server/web service that 
knowingly enabled this hack in a multi-user machine and would not enable it for 
any enterprise customers.

This is a real world, hard promise that we will let other users see your data in 
a trivial way (with your patch, only if they have the capability set).

>
> I agree with you that it would be nice to look into this further, and
> optimizing our extent merging is definitely on the hot list of
> perofrmance improvements to look at.  But people who are using ext4 as
> back-end database servers or cluster file system servers and who are
> interested in wringing out every last percentage of performace are
> going to be interested in this technique, no matter what we do.  If
> you have Sagans and Sagans of servers all over the world, even a tenth
> of a percentage point performance improvement can easily translate
> into big dollars.
>
> 						- Ted

We should be very, very careful not to strip away the usefulness of file system 
just to cater to some users. You could deliver the same performance safely in a 
few ways I think:

* fully allocate the file (by actually writing the data once in large IO's)
* don't preallocate and write with large enough IO's to populate the file (you 
can tweak this by doing something like allocation of largish chunks on first 
write to  a region)
* fix our preallocation to use discard (trim) primitives (note you can also use 
"WRITE_SAME" to init regions of blocks, but that can be quite slow)

ric


