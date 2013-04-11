From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 1/2 v2] ext4: move ext4_ind_migrate() into migrate.c
Date: Thu, 11 Apr 2013 17:15:49 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1304111714450.10609@dhcp-1-230.brq.redhat.com>
References: <1365506687-9216-1-git-send-email-lczerner@redhat.com> <20130411035826.GA18878@thunk.org> <alpine.LFD.2.00.1304111013191.10609@dhcp-1-230.brq.redhat.com> <20130411145620.GC8609@thunk.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-2049327705-1365693352=:10609"
Cc: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org, gnehzuil.liu@gmail.com
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60096 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932840Ab3DKPP5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Apr 2013 11:15:57 -0400
In-Reply-To: <20130411145620.GC8609@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-2049327705-1365693352=:10609
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Thu, 11 Apr 2013, Theodore Ts'o wrote:

> Date: Thu, 11 Apr 2013 10:56:20 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: linux-ext4@vger.kernel.org, gnehzuil.liu@gmail.com
> Subject: Re: [PATCH 1/2 v2] ext4: move ext4_ind_migrate() into migrate.c
> 
> On Thu, Apr 11, 2013 at 10:18:16AM +0200, Lukáš Czerner wrote:
> > Thanks, but Dmitry is right, the check should be before the
> > journal_start() call.
> 
> Whoops!  I'm not sure how I screwed that up.  Thanks for catching
> that, Dmitry!
> 
> > I am not sure how much work will it be for you, but would it be
> > possible to resend patch to the list when you change it ? Just to
> > make sure we do not get unnecessary problems.
> 
> Yes, I'll try to do that in the future.  Here's the revised patch....
> 

Thanks! Now it looks ok.

-Lukas

>      	      	    	    	- Ted
> 
> commit 3b296c66fe6f9a6ed44b0b83f4f2ae87d8874af6
> Author: Lukas Czerner <lczerner@redhat.com>
> Date:   Thu Apr 11 10:54:46 2013 -0400
> 
>     ext4: do not convert to indirect with bigalloc enabled
>     
>     With bigalloc feature enabled we do not support indirect addressing at all
>     so we have to prevent extent addressing to indirect addressing
>     conversion in this case. The problem has been introduced with the commit
>     "ext4: support simple conversion of extent-mapped inodes to use i_blocks"
>     
>     Signed-off-by: Lukas Czerner <lczerner@redhat.com>
>     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> 
> diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
> index d129a4d..49e8bdf 100644
> --- a/fs/ext4/migrate.c
> +++ b/fs/ext4/migrate.c
> @@ -625,6 +625,10 @@ int ext4_ind_migrate(struct inode *inode)
>  	    (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
>  		return -EINVAL;
>  
> +	if (EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
> +				       EXT4_FEATURE_RO_COMPAT_BIGALLOC))
> +		return -EOPNOTSUPP;
> +
>  	handle = ext4_journal_start(inode, EXT4_HT_MIGRATE, 1);
>  	if (IS_ERR(handle))
>  		return PTR_ERR(handle);
> 
--8323328-2049327705-1365693352=:10609--
