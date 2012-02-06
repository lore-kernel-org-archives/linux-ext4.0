From: Jan Kara <jack@suse.cz>
Subject: Re: 3.2.2: edquota: WARNING - /dev/md2: cannot change current
 block allocation
Date: Mon, 6 Feb 2012 17:10:12 +0100
Message-ID: <20120206161012.GG6890@quack.suse.cz>
References: <20267.692.189880.355136@fisica.ufpr.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Carlos Carvalho <carlos@fisica.ufpr.br>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49915 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755353Ab2BFQKO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 6 Feb 2012 11:10:14 -0500
Content-Disposition: inline
In-Reply-To: <20267.692.189880.355136@fisica.ufpr.br>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 02-02-12 19:40:04, Carlos Carvalho wrote:
> When I tried to increase the quota of a user (postgres) I got this
> edquota warning. The output of quota still showed the * indicating the
> limit and the user couldn't allocate more disk. After a reboot (to
> 3.2.1) and quotacheck I had to use edquota again, and then it accepted
> the increase and unblocked the allocations.
> 
> This is the output of mount|grep /dev/md2:
> /dev/md2 on /home type ext4 (rw,relatime,user_xattr,acl,barrier=0,stripe=128,data=ordered,inode_readahead_blks=64,jqfmt=vfsv1,usrjquota=aquota.user,grpjquota=aquota.group)
> 
> How can this be?
  Well, the message suggests that you edited actual block usage of user and
not his limit. That's why edquota complained and didn't change anything...
So it's nothing related to kernel nor a bug ;).

  As a side note, I always found edquota(8) error prone and I think
setquota(8) is a better tool to do what I need. But I guess it depends on
one's taste.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
