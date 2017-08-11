From: Eric Whitney <enwlinux@gmail.com>
Subject: Re: Release of e2fsprogs 1.43.5
Date: Fri, 11 Aug 2017 17:23:10 -0400
Message-ID: <20170811212310.GA19995@localhost.localdomain>
References: <20170805163409.y5ifkldbmwzy4hge@thunk.org>
 <552dd796-7ba5-6a10-b9fd-0d1a2aa07041@redhat.com>
 <20170810173044.GA16896@localhost.localdomain>
 <20170810173713.GA4458@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Whitney <enwlinux@gmail.com>, sandeen@redhat.com,
        linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:36277 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753533AbdHKVTR (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Aug 2017 17:19:17 -0400
Received: by mail-qt0-f194.google.com with SMTP id c15so4830933qta.3
        for <linux-ext4@vger.kernel.org>; Fri, 11 Aug 2017 14:19:17 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170810173713.GA4458@magnolia>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Darrick J. Wong <darrick.wong@oracle.com>:
> On Thu, Aug 10, 2017 at 01:30:44PM -0400, Eric Whitney wrote:
> > * Eric Sandeen <esandeen@redhat.com>:
> > > On 8/5/17 9:34 AM, Theodore Ts'o wrote:
> > > > I've released e2fsprogs 1.43.5 in all of the usual places; it's tagged
> > > > in the git trees on git.kernel.org, github, and sourceforge, and
> > > > available for download at:
> > > > 
> > > > ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/v1.43.5
> > > > 
> > > > and
> > > > 
> > > > http://prdownloads.sourceforge.net/e2fsprogs/e2fsprogs-1.43.5.tar.gz
> > > > 
> > > > The release notes for 1.43.5 can be found below.
> > > 
> > > I'm getting test failures in rawhide with this, FWIW; on i686
> > > and arm:
> > > 
> > > 336 tests succeeded	3 tests failed
> > > Tests failed: f_del_dup_quota f_quota f_quota_extent_opt 
> > > 
> > > Haven't dug into this yet (failures are on ephemeral build root
> > > on a build host), but has anyone else seen problems?
> > > 
> > 
> > Yes - I can reproduce these failures on Debian Jessie on 32 bit x86, as can
> > Ted.
> > 
> > Reverting "libext2fs: fix compile errors/warnings" (a850bc56e0aa) resolves
> > the problem for me.  In particular, undoing the format string changes in
> > scan_dquots_callback() fixes the failures.  I think we need to use %lld as
> > dqb_curspace and dqb_curinodes are __le64,
> 
> lib/support/quotaio.h does:
> 
>   typedef int64_t qsize_t;
> 
>   struct util_dqblk {
> 	...
> 	qsize_t dqb_curinodes;
> 	...
> 	qsize_t dqb_curspace;
> 	...
>   };
> 
> and if they're int64_t then you could use PRId64.
> 
> --D

My mistake - I grepped the wrong declarations of dqb_curinodes/dqb_curspace to
determine type.  They're indeed int64_t in this case.

Eric
