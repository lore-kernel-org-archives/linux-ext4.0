From: Dave Chinner <david@fromorbit.com>
Subject: Re: Reporting project quota usage?
Date: Thu, 17 Mar 2016 12:31:56 +1100
Message-ID: <20160317013156.GH11812@dastard>
References: <20160316052906.GA23610@thunk.org>
 <A21F30FD-8207-473D-860A-F1B2118D35C0@dilger.ca>
 <20160317004847.GG23593@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>, Li Xi <pkuelelixi@gmail.com>,
	Jan Kara <jack@suse.cz>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:33039 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751802AbcCQBvf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Mar 2016 21:51:35 -0400
Content-Disposition: inline
In-Reply-To: <20160317004847.GG23593@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 16, 2016 at 08:48:47PM -0400, Theodore Ts'o wrote:
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
> want to submit for merging)

I posted a patch to do it, but I haven't had a chance to fix the
problems Eric noticed because other stuff happened.

You're welcome to fix it up and repost it:

http://oss.sgi.com/archives/xfs/2016-02/msg00109.html

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
