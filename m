From: Jan Kara <jack@suse.cz>
Subject: Re: REGRESSION: [PATCH 04/12] ext4: Disable merging of
 uninitialized extents
Date: Thu, 14 Feb 2013 22:32:50 +0100
Message-ID: <20130214213250.GA4887@quack.suse.cz>
References: <1358510446-19174-1-git-send-email-jack@suse.cz>
 <1358510446-19174-5-git-send-email-jack@suse.cz>
 <20130209171015.GC8091@thunk.org>
 <20130214161116.GB31269@quack.suse.cz>
 <20130214190555.GA6641@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Dmitry Monakhov <dmonakhov@openvz.org>,
	linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57320 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932601Ab3BNVcx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Feb 2013 16:32:53 -0500
Content-Disposition: inline
In-Reply-To: <20130214190555.GA6641@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 14-02-13 14:05:55, Ted Tso wrote:
> On Thu, Feb 14, 2013 at 05:11:16PM +0100, Jan Kara wrote:
> >   OK, so I've debugged this. It wasn't actually that hard. The problem is
> > that mpage_da_map_and_submit() prepares extent with e.g. 256 blocks but
> > later we submit a shorter bio e.g. because it cannot carry that many pages.
> > So ->end_io is called only for first 128 blocks or so. I spotted this
> > problem already before, just it didn't come up when Ted sent me this bug
> > report.
> 
> So can we get a corruption without these patches, but it was a lot
> harder to hit that case before?
  When the bio is shorter we just need to split the unwritten extent when
processing end_io callback. That is properly handled after Dmitry's fixes
so corruption can happen only when we are close to ENOSPC and the split
fails. Now we started seeing the split is happening because one of the
patches added the warning that the split from end_io is happening...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
