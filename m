From: Jan Kara <jack@suse.cz>
Subject: Re: Reporting project quota usage?
Date: Fri, 18 Mar 2016 10:40:15 +0100
Message-ID: <20160318094015.GB7152@quack.suse.cz>
References: <20160316052906.GA23610@thunk.org>
 <A21F30FD-8207-473D-860A-F1B2118D35C0@dilger.ca>
 <20160317004847.GG23593@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>, Li Xi <pkuelelixi@gmail.com>,
	Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45278 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752771AbcCRJju (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Mar 2016 05:39:50 -0400
Content-Disposition: inline
In-Reply-To: <20160317004847.GG23593@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 16-03-16 20:48:47, Ted Tso wrote:
> On Wed, Mar 16, 2016 at 03:49:31PM -0600, Andreas Dilger wrote:
> > 
> > At one time I thought Dave was going to patch xfs_quota to try the quota
> > ioctls for "foreign" filesystems like ext4 that supported them, but I'm
> > not sure if that patch was landed, nor whether it has been released.
> > 
> > On the opposite front, Jan was updating the generic quota tools to support
> > the XFS ioctls that project quota is using?
> 
> It's quite possible I'm missing something, but it doesn't look like
> either has landed.  I've hacked xfs_quota (not anything that I would
> want to submit for merging) so I can report usage project quota stats,
> and to be able to set hard and soft limits.  But I was trying to
> figure out what we should be telling users who wanted to use Project
> Quota, but I'm pretty sure "pull down xfsprogs sources, and apply this
> hacky patch[1], and then when you use the tooll ignore a whole bunch
> of spurious warnings" is the right way to go.  :-)
> 
> I am also curious how Li Xi was testing the patches he sent me.

As Li Xi mentioned, he has a patch for quota-tools which implements the
project quota support but it needs some cleanup (you can check my reply to
email "[PATCH] Add project quota support" - it didn't go to any list but
you were CCed). Li Xi, do you have any idea when you can get to it?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
