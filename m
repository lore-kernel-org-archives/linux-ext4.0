From: David Chinner <dgc@sgi.com>
Subject: Re: ext3 lockdep warning in 2.6.25-rc6
Date: Fri, 4 Apr 2008 13:14:17 +1000
Message-ID: <20080404031417.GE103491721@sgi.com>
References: <20080325182909.GD21732@atrey.karlin.mff.cuni.cz> <200804012123.m31LNY3T012962@agora.fsl.cs.sunysb.edu> <20080402081215.GA2716@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Erez Zadok <ezk@cs.sunysb.edu>, sct@redhat.com,
	akpm@linux-foundation.org, adilger@clusterfs.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from relay1.sgi.com ([192.48.171.29]:39181 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759086AbYDDDOt (ORCPT
	<rfc822;@relay.sgi.com:linux-ext4@vger.kernel.org>);
	Thu, 3 Apr 2008 23:14:49 -0400
Content-Disposition: inline
In-Reply-To: <20080402081215.GA2716@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 02, 2008 at 10:12:15AM +0200, Jan Kara wrote:
> On Tue 01-04-08 17:23:34, Erez Zadok wrote:
>  <snip>
<snip>
> > Jan, I'll be happy to test this, but I don't understand two things about
> > this patch:
> > 
> > 1. Is it safe to unlock and re-lock inode_lock temporarily within the loop?
> > 
> > 2. What's the motivation behind having the second toput_inode pointer?  It
> >    appears that the first iteration through the loop, toput_inode will be
> >    NULL, so we'll be iput'ing a NULL pointer (which is ok).  So you're
> >    trying to iput the previous inode pointer that the list iterated over,
> >    right?  Is that intended?
>   I'll try to explain the locking here:
> 1) We are not allowed to call into __invalidate_mapping_pages() with
> inode_lock held - that it the bug lockdep is complaining about. Moreover it
> leads to rather long waiting times for inode_lock (quite possibly several
> seconds).

When you have tens of millions of cached inodes, it can take somewhat
longer than a few seconds.... :/

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
