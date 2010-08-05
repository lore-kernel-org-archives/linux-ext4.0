From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 1/3] Add ioctl FITRIM.
Date: Thu, 5 Aug 2010 09:47:16 -0600
Message-ID: <54658239-0690-45BB-9CBD-5B1975E4DEF0@dilger.ca>
References: <1280929475-12823-1-git-send-email-lczerner@redhat.com> <8762zq8lxv.fsf@dmon-lap.sw.ru> <alpine.LFD.2.00.1008041704420.2932@localhost> <AANLkTikmNCLSuc--k=k4mFSGhgn82Q1n1-66SYnGJH-5@mail.gmail.com> <20100805002839.GD2901@thunk.org>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Greg Freemyer <greg.freemyer@gmail.com>,
	Lukas Czerner <lczerner@redhat.com>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	linux-ext4@vger.kernel.org, jmoyer@redhat.com, rwheeler@redhat.com,
	eshishki@redhat.com, sandeen@redhat.com, jack@suse.cz,
	Mark Lord <kernel@teksavvy.com>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:46792 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758190Ab0HEPrX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Aug 2010 11:47:23 -0400
In-Reply-To: <20100805002839.GD2901@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-08-04, at 18:28, Ted Ts'o wrote:
> On Wed, Aug 04, 2010 at 11:26:56AM -0400, Greg Freemyer wrote:
>> If true, a way to control the progress from userspace is important.
>> 
>> If in general it is only going to take a few seconds for a full FITRIM
>> to run, it is much less important, but I suppose the the RT project
>> might find even that problematic.
> 
> Even if it without the RT project, if disk activity is slowed or
> completely stopped for a few seconds, I can think of plenty of
> workloads where this would be totally unacceptable.  Suppose you are
> running a web site; it doesn't really matter whether it is at Google,
> Facebook, Twitter, etc.  If this means that one or more web pages get
> stalled by "a few seconds" while the FITRIM is going on, this is
> generally not considered acceptable.  Even if it slows down the server
> by 30-50%, for some sites this would also be quite unacceptable.
> 
> This is a hard problem to solve, though, especially if there is an
> insistence to solve it in a fs-independent fashion.  I could imagine
> doing this at work, by doing things one block group at a time, and
> then I could measure, for our specific hardware, how badly disk
> performance would get hit, and for how long, and then the userspace
> daemon could control how many block groups to do per unit time.
> But this would be of necessity ext2/3/4 specific....

I think "blockgroup at a time" is simply the extN way of "range of blocks at a time".  Having an API that is requesting "trim free blocks from [M,N]" is a generic enough interface to apply to any filesystem.  If there is some way to query the "efficient trim increment size" (i.e. block group for extN, allocation group for xfs, ??? for btrfs) then userspace could do it that way, or simply pick some fraction of the filesystem and use a nice power-of-two value and hope it works out.

> So I'm not sure what to suggest here.  Maybe the answer is we can have
> a fs-independent ioctl for desktop workloads, and one which gives more
> fine-grained control for those who need it?  That seems ugly, but it
> might be the best compromise.

No, too ugly.

Cheers, Andreas





