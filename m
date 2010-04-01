From: Jan Kara <jack@suse.cz>
Subject: Re: quota reservation fixes for -stable?
Date: Thu, 1 Apr 2010 10:23:35 +0200
Message-ID: <20100401082334.GD3322@quack.suse.cz>
References: <4BB36BEC.2000207@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>, Dmitry Monakhov <dmonakhov@openvz.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:38212 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753979Ab0DAIX0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 Apr 2010 04:23:26 -0400
Content-Disposition: inline
In-Reply-To: <4BB36BEC.2000207@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 31-03-10 10:36:12, Eric Sandeen wrote:
> I think we should get the following commits to -stable:
> 
> 0a5a9c725512461d19397490f3adf29931dca1f2 quota: Fix warning when a delayed write happens before quota is enabled
> c469070aea5a0ada45a836937c776fd3083dae2b quota: manage reserved space when quota is not active [v2]
  They are already queued for 2.6.33 and 2.6.32 stable trees. I sent
them to Greg last week or so.

> without these, we're just racking up the score on kerneloops:
> 
> http://www.kerneloops.org/searchweek.php?search=dquot_claim_space
> 
> (I think this is a #1 all-time high for a kerneloops count ;)
> 
> Pretty sure the 2 commits above can be backported w/o other
> dependencies, but maybe Jan & Dmitry can confirm.
> 
> I dug into this a little; at least on stock .32 Fedora, it's really
> only hitting on a few files, but seems to hit every time they're written:
> /var/log/messages, audit.log, etc - things that likely were written
> prior to quota being enabled.  Perhaps this is a Fedora initscripts
> bug... 
> 
> But check this out, with a modified .32 kernel with the above 2 commints,
> and a change that reports which inodes were modified:
> 
> VFS (sda12): inode(s) 1064 
> VFS (sda12): Writes happened before quota was turned on thus quota information is probably inconsistent. Please run quotacheck(8).
> 
> # find /etc -inum 1064
> /etc/mtab
  Ah, I'm testing quotas on non-root fs so I was wondering how come people
hit the warning so often. Now I understand :) For root filesystem on ext4
we don't have a chance to not see this warning. That being said the warning
is pretty useless for ordinary users so I guess we should just hide it
behind #ifdef __DQUOT_PARANOIA and use it for debugging purposes only.
  If noone objects soon, I'll do the change.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
