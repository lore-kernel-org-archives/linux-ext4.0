From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: Don't allow quota mount options when quota
 feature enabled
Date: Mon, 25 Feb 2013 19:39:43 -0500
Message-ID: <20130226003943.GC7007@thunk.org>
References: <1361835369-19850-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49917 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010Ab3BZAjq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Feb 2013 19:39:46 -0500
Content-Disposition: inline
In-Reply-To: <1361835369-19850-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 26, 2013 at 12:36:08AM +0100, Jan Kara wrote:
> So far we silently ignored when quota mount options were set while quota
> feature was enabled. But this can create confusion in userspace when
> mount options are set but silently ignored and also creates opportunities
> for bugs when we don't properly test all quota types. Actually
> ext4_mark_dquot_dirty() forgets to test for quota feature so it was
> dependent on journaled quota options being set. OTOH ext4_orphan_cleanup()
> tries to enable journaled quota when quota options are specified which is
> wrong when quota feature is enabled.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

I've been using the quota mount options since it's the only way to
test the quota patches when using an older version of the quota
userspace package.

I can build a newer version of the userspace quota package for my own
use (since version 4.01 isn't in Debian Testing yet nor Ubuntu yet),
but we probably need to make sure we document that users may need to
build their own version of the quota package.

      	    		       	     - Ted
