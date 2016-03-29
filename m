From: Jan Kara <jack@suse.cz>
Subject: Re: GETNEXTQUOTA causes kernel crash if quota not enabled
Date: Tue, 29 Mar 2016 13:36:33 +0200
Message-ID: <20160329113633.GD12993@quack.suse.cz>
References: <20160328044339.GA15808@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52395 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756825AbcC2LgF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Mar 2016 07:36:05 -0400
Content-Disposition: inline
In-Reply-To: <20160328044339.GA15808@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 28-03-16 00:43:39, Ted Tso wrote:
> Hi Jan, this looks like a recent change that just landed in the quota
> tree.  The crash is in dquot_get_next_id() because
> sb_dqopt(sb)->ops[0] is NULL.
> 
> This looks like it was introduced in a fairly recent commit:
> be6257b251ce ("quota: Add support for ->get_nextdqblk() for VFS
> quota").
> 
> Please see reproduction below.  It can also be easily reproduced using
> "kvm-xfstests -c encrypt generic/244")

Thanks for report! Obviously we are missing a test whether quota is
actually enabled for the filesystem (the test generic/244 seems to be
somewhat buggy for VFS quota based filesystems). It was not written yet
when I was testing my changes and it never occured to me to run
Q_GENTEXTQUOTA against a filesystem with quotas disabled... I'll fix it up.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
