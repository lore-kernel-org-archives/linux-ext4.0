From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] ext4: Don't allow quota mount options when quota
 feature enabled
Date: Tue, 26 Feb 2013 14:18:22 +0100
Message-ID: <20130226131822.GA3359@quack.suse.cz>
References: <1361835369-19850-1-git-send-email-jack@suse.cz>
 <20130226003943.GC7007@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41674 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756759Ab3BZNSZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Feb 2013 08:18:25 -0500
Content-Disposition: inline
In-Reply-To: <20130226003943.GC7007@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 25-02-13 19:39:43, Ted Tso wrote:
> On Tue, Feb 26, 2013 at 12:36:08AM +0100, Jan Kara wrote:
> > So far we silently ignored when quota mount options were set while quota
> > feature was enabled. But this can create confusion in userspace when
> > mount options are set but silently ignored and also creates opportunities
> > for bugs when we don't properly test all quota types. Actually
> > ext4_mark_dquot_dirty() forgets to test for quota feature so it was
> > dependent on journaled quota options being set. OTOH ext4_orphan_cleanup()
> > tries to enable journaled quota when quota options are specified which is
> > wrong when quota feature is enabled.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> I've been using the quota mount options since it's the only way to
> test the quota patches when using an older version of the quota
> userspace package.
  Yeah, I know it's useful at moments to be able to use quota mount options
even with quota feature. But older quota tools behave strangely with quota
feature anyway at times so for production use I'd suggest at least version
4.01 anyway. That's why I decided forcing quota mount options off with
quota feature because that's going to cause the least confusion long term
IMHO.

> I can build a newer version of the userspace quota package for my own
> use (since version 4.01 isn't in Debian Testing yet nor Ubuntu yet),
> but we probably need to make sure we document that users may need to
> build their own version of the quota package.
  True, I guess adding that to mke2fs manpage would be appropriate?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
