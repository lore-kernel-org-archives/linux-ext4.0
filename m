From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: Eric Whitney's ext4 scaling data
Date: Thu, 28 Mar 2013 12:49:05 +0800
Message-ID: <20130328044905.GA5863@gmail.com>
References: <nsxhajyzu6n.fsf@closure.thunk.org>
 <20130327033322.GB9887@gmail.com>
 <20130327033554.GE5861@thunk.org>
 <20130327072101.GA10346@gmail.com>
 <20130327151011.GD14900@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eric Whitney <enwlinux@gmail.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:51951 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440Ab3C1EdZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Mar 2013 00:33:25 -0400
Received: by mail-pd0-f169.google.com with SMTP id 10so1352511pdc.14
        for <linux-ext4@vger.kernel.org>; Wed, 27 Mar 2013 21:33:25 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20130327151011.GD14900@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[add Eric into cc list]

On Wed, Mar 27, 2013 at 11:10:11AM -0400, Theodore Ts'o wrote:
> On Wed, Mar 27, 2013 at 03:21:02PM +0800, Zheng Liu wrote:
> > 
> > The key issue that we add test case into xfstests is that we need to
> > handle some filesystem-specific feature.  Just like we had discussed
> > with Dave, what is an extent?  IMHO now xfstests gets more compliated
> > because it needs to handle this problem. e.g. punch hole for
> > indirect-based file in ext4.
> 
> Yes, that means among other things the test framework needs to keep
> track of which file system features was being used when we run a
> particular test, as well as the hardware configuration.
> 
> I suspect that what this means is that we're better off trying to
> create a new test framework that does what we want, and automates as
> much of this as possible.

Yes, that means that we need to create a new wheel to do this work.
That is why I want to discuss with other folks because this is not a
small project.

> 
> It would probably be a good idea to bring in Eric Whitney into this
> discussion, since he has a huge amount of expertise about what sort of
> things need to be done in order to get good results.  He was doing a
> number of things by hand, including re-running the tests multiple
> times to make sure the results were stable.  I could imagine that if
> the framework could keep track of what the standard deviation was for
> a particular test, it could try to do this automatically, and then we
> could also throw up a flag if the average result hadn't changed, but
> the standard deviation had increased, since that might be an
> indication that some change had caused a lot more variability.

Average and standard deviation is a very important data for a
performance test framework.  Some performance regressions only causes a
very subtle impact.  This means that we need to run a test case serveral
times, and count average and standard deviation besides throughput,
IOPS, latency, etc....

> 
> (Note by the way that one of the things that is going to be critically
> important for companies using ext4 for web backends is not just the
> average throughput, which is what FFSB mostly tests, but also 99.99%
> percentile latency.  And sometimes the best workloads which show this
> will only be mixed workloads, when under memory pressure.  For
> example, consider the recent "page eviction from the buddy cache"
> e-mail.  That's something which might result in only a slight increase
> for average throughput numbers, but could have a much more profound
> impact on 99.9% latency numbers, especially if while we are reading in
> a bitmap block, we are holding some lock or preventing a journal
> commit from closing.)

Definitely, the latency is very important for us.  At Taobao, most apps
are latency-sensitive.  They expect a stable latency that is provided by
file system.  They can accept that we only provide a stable but high
latency on every writes (e.g. 100ms, quite big :-)) because the designer
will consider this factor.  However, they hate that we provide a small
but unstable latency (e.g. 3ms on 99% writes, and 500ms on 1% write).

Regards,
                                                - Zheng
