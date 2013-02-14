From: Jan Kara <jack@suse.cz>
Subject: Re: REGRESSION: [PATCH 04/12] ext4: Disable merging of
 uninitialized extents
Date: Thu, 14 Feb 2013 11:47:34 +0100
Message-ID: <20130214104734.GA605@quack.suse.cz>
References: <1358510446-19174-1-git-send-email-jack@suse.cz>
 <1358510446-19174-5-git-send-email-jack@suse.cz>
 <20130209171015.GC8091@thunk.org>
 <20130212215832.GA25984@quack.suse.cz>
 <20130213045759.GE2614@thunk.org>
 <87ehgku11r.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57535 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752757Ab3BNKrh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Feb 2013 05:47:37 -0500
Content-Disposition: inline
In-Reply-To: <87ehgku11r.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 13-02-13 11:26:40, Dmitry Monakhov wrote:
> On Tue, 12 Feb 2013 23:57:59 -0500, Theodore Ts'o <tytso@mit.edu> wrote:
> > On Tue, Feb 12, 2013 at 10:58:32PM +0100, Jan Kara wrote:
> > >   The third patch is a fix which shouldn't cause any issues. So you can
> > > take just that one and leave the other two aside until we are able to
> > > resolve the issue.
> > 
> > I thought the third patch depending on the first two?  Certainly it
> > doesn't apply cleanly without the first two patches...
> My patch fix old issue, but i've prepared it on top of Jan's patches
> only for simplicity. I'll send new version which not depend on his
> patches today.
> Over-all Jan's statment that split should not happen inside end_io
> and it is clear sing of a bug is absolutely right decision.
> This helps us to spot several hidden issues (number is still unknown)
> so may be it is reasonable to split first patch in two parts:
> 1) disable uninitialized extents merging itself.
> 2) Print warning if split is required inside end_io(so only warning will
> be printed, but w/o data corruption)
> 3) Get rid of extent split machinery from end_io (because it is not
> longer valid situation)
> 
> (1) and (2) should be accepted ASAP and will help us to spot and fix
> other hidden issues. And we fix all related issues it will be safe
> to apply (3)'rd one.
> I'll send patches soon.
  I agree with this plan, I just think the warnings are currently too easy
to trigger (just random AIO DIO writing seems to trigger them with
dioread_nolock) so as Ted said we'll probably have to hide them under
EXT4_DEBUG or something like that. I'll try to debug the current problem
while you prepare the patches :).

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
