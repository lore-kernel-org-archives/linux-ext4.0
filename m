From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Release of e2fsprogs 1.43.5
Date: Thu, 10 Aug 2017 10:37:13 -0700
Message-ID: <20170810173713.GA4458@magnolia>
References: <20170805163409.y5ifkldbmwzy4hge@thunk.org>
 <552dd796-7ba5-6a10-b9fd-0d1a2aa07041@redhat.com>
 <20170810173044.GA16896@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sandeen@redhat.com, linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26339 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753175AbdHJRhV (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Aug 2017 13:37:21 -0400
Content-Disposition: inline
In-Reply-To: <20170810173044.GA16896@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 10, 2017 at 01:30:44PM -0400, Eric Whitney wrote:
> * Eric Sandeen <esandeen@redhat.com>:
> > On 8/5/17 9:34 AM, Theodore Ts'o wrote:
> > > I've released e2fsprogs 1.43.5 in all of the usual places; it's tagged
> > > in the git trees on git.kernel.org, github, and sourceforge, and
> > > available for download at:
> > > 
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/v1.43.5
> > > 
> > > and
> > > 
> > > http://prdownloads.sourceforge.net/e2fsprogs/e2fsprogs-1.43.5.tar.gz
> > > 
> > > The release notes for 1.43.5 can be found below.
> > 
> > I'm getting test failures in rawhide with this, FWIW; on i686
> > and arm:
> > 
> > 336 tests succeeded	3 tests failed
> > Tests failed: f_del_dup_quota f_quota f_quota_extent_opt 
> > 
> > Haven't dug into this yet (failures are on ephemeral build root
> > on a build host), but has anyone else seen problems?
> > 
> 
> Yes - I can reproduce these failures on Debian Jessie on 32 bit x86, as can
> Ted.
> 
> Reverting "libext2fs: fix compile errors/warnings" (a850bc56e0aa) resolves
> the problem for me.  In particular, undoing the format string changes in
> scan_dquots_callback() fixes the failures.  I think we need to use %lld as
> dqb_curspace and dqb_curinodes are __le64,

lib/support/quotaio.h does:

  typedef int64_t qsize_t;

  struct util_dqblk {
	...
	qsize_t dqb_curinodes;
	...
	qsize_t dqb_curspace;
	...
  };

and if they're int64_t then you could use PRId64.

--D

> as addressed in "e2fsck: fix type mismatches in quota warning message"
> (f09669fc6889).
> 
> Eric
