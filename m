From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: more resize breakage
Date: Wed, 28 May 2014 23:00:48 -0700
Message-ID: <20140529060048.GB27499@birch.djwong.org>
References: <5386C41D.2090006@redhat.com>
 <20140529052733.GD17413@birch.djwong.org>
 <5386C5BF.7080202@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29848 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbaE2GAy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 29 May 2014 02:00:54 -0400
Content-Disposition: inline
In-Reply-To: <5386C5BF.7080202@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 29, 2014 at 12:29:35AM -0500, Eric Sandeen wrote:
> On 5/29/14, 12:27 AM, Darrick J. Wong wrote:
> > On Thu, May 29, 2014 at 12:22:37AM -0500, Eric Sandeen wrote:
> >> After considering how many resize2fs corruptions we've had, I decided to try to write a resize fuzzer which picks random parameters and sizes, and sees what happens with online & offline grow & offline shrink.  When I get it cleaner, I'll send it out to play with.
> >>
> >> But it is indeed finding resize issues; for example, with e2fsprogs git master & v3.15-rc3,
> 
> <snip>
> 
> >> Sad face.  :(
> > 
> > D'oh!
> > 
> > /me wonders, is offline grow any better?
> 
> Yes, offline passed.
> 
> > Also I "extended" fsfuzz to corrupt only metadata blocks and made the
> > kernel+e2fsck chew through all that crap.  The kernel survived, but e2fsck
> > seemed to die either failing to allocate blocks to resurrect the journal (bad
> > bbitmap) or because of that thing where calling block_iterate on an inline data
> > file makes e2fsck abort.
> > 
> > So, uh, ... long live the patchbomb? :(
> 
> yeah.  Maybe I (you?) should try my testcase w/ your latest patchbomb.  ;)

I think I only have patches out for review for e2fsprogs at the moment.  I've
not put my grubby hands on kernel code in a while.

--D
> 
> -Eric
> 
