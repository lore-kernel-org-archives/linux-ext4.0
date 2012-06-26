From: Fredrick <fjohnber@zoho.com>
Subject: Re: ext4_fallocate
Date: Tue, 26 Jun 2012 11:06:02 -0700
Message-ID: <4FE9FA0A.8010708@zoho.com>
References: <4FE8086F.4070506@zoho.com> <20120625085159.GA18931@gmail.com> <20120625191744.GB9688@thunk.org> <4FE9B57F.4030704@redhat.com> <20120626173050.GA6745@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ric Wheeler <rwheeler@redhat.com>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger@dilger.ca>, wenqing.lz@taobao.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sender1.zohomail.com ([72.5.230.103]:43399 "EHLO
	sender1.zohomail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758849Ab2FZSIF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Jun 2012 14:08:05 -0400
In-Reply-To: <20120626173050.GA6745@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 06/26/2012 10:30 AM, Theodore Ts'o wrote:
> On Tue, Jun 26, 2012 at 09:13:35AM -0400, Ric Wheeler wrote:
>>
>> Has anyone made progress digging into the performance impact of
>> running without this patch? We should definitely see if there is
>> some low hanging fruit there, especially given that XFS does not
>> seem to suffer such a huge hit.
>


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
>

Even our workload is same as above. Our programs write a chunk
and do fysnc for robustness. This happens repeatedly
on the file as the program pushes more data on the disk.


> One other thing which we *have* seen is that we need to do a better
> job with extent merging; if you run without this patch, and you run
> with fio in AIO mode where you are doing tons and tons of random
> writes into uninitialized space, you can end up fragmenting the extent
> tree very badly.   So fixing this would certainly help.
>
>> Opening this security exposure is still something that is clearly a
>> hack and best avoided if we can fix the root cause :)
>
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
>

I can see the performance degradation on SSDs too, though the percentage
is less compared to SATA.

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

Sailing the same boat. :)

> 						- Ted
>

-Fredrick

