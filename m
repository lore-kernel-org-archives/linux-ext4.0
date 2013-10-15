From: Jan Kara <jack@suse.cz>
Subject: Re: 3.10.10: quota problems
Date: Tue, 15 Oct 2013 17:53:34 +0200
Message-ID: <20131015155334.GG12428@quack.suse.cz>
References: <21080.35061.164482.975014@fisica.ufpr.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Carlos Carvalho <carlos@fisica.ufpr.br>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53787 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758028Ab3JOPxh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Oct 2013 11:53:37 -0400
Content-Disposition: inline
In-Reply-To: <21080.35061.164482.975014@fisica.ufpr.br>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 11-10-13 20:25:41, Carlos Carvalho wrote:
> There are two problems. First, on a new filesystem with
> tune2fs -Q usrquota and grpquota was working fine until a power
> failure switched the machine off. On reboot all files seem normal
> but quota -v showed no limits neither usage...
> 
> I ran fsck and it said the fs was clean. Then I ran fsck -f and
> 
> Pass 5: Checking group summary information
> [QUOTA WARNING] Usage inconsistent for ID 577:actual (12847804416, 308767) != expected (12868194304, 308543)
> [QUOTA WARNING] Usage inconsistent for ID 541:actual (186360393728, 11089) != expected (186340204544, 11085)
> 
> ... etc until
> 
> Update quota info for quota type 0<y>? yes
> 
> then some more of
> 
> [QUOTA WARNING] Usage inconsistent for ID 500:actual (192918523904, 20725) != expected (192897576960, 20671)
> 
> until
> 
> Update quota info for quota type 1<y>? yes
> 
> /dev/md3: ***** FILE SYSTEM WAS MODIFIED *****
> 
> After remounting and running quota on usage for some users were back
> but not limits. For other users even usage is lost.
> 
> This is with 3.10.10, e2fsprogs 1.42.8 (Debian) and mount options
> rw,nosuid,nodev,commit=30,stripe=768,data=ordered,inode_readahead_blks=64
> 
> This was the first unclean shutdown of this machine after more than 6
> months of usage. The new quota method looks fragile... Is there
> something I can do get limits and usage back?
  No idea here, sorry. I will try to reproduce the problem and see what I
can find. I'd just note that userspace support of hidden quotas in
e2fsprogs is still experimental and Ted pointed out a few problems in it.
Among others I think limits are not properly transferred from old to new
quota file during fsck... But it still doesn't explain why the limits got
lost after the crash. Didn't quotacheck create visible quota files after
the crash or something like that?

> --------------------------------------------------
> 
> The second problem is on an old filesystem with the old quota system,
> also with kernel 3.10.10 but another machine. Compilation is different
> because this one is 32bit, the other is 64bit. mount options are
> 
> defaults,strictatime,nobarrier,nosuid,nodev,commit=30,inode_readahead_blks=64,usrjquota=aquota.user,grpjquota=aquota.group,jqfmt=vfsv1
> 
> The problem here is that after removing lots of users in a row
> repquota -v shows many entries of removed users in numerical form, like
> 
> #42       --      32       0       0              1     0     0       
  OK, so we still think there is one file with 32KB allocated to the user.
Strange. Isn't it possible there is still some (unlinked) directory
existing which is pwd of some process or something like that? Because
accounting problems in number of used inodes are rather unlikely (that code
is really straightforward).

> However all files of the removed users have been deleted and their
> quota set to zero with setquota, so there should be no such entries.
> After umounting and running quotacheck these entries effectively
> disappear. This problem has already happened several times years ago
> and had been fixed, but has resurfaced...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
