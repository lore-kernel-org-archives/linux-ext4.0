From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 6/8] xfs: Use generic writers counter instead of m_active_trans
 counter
Date: Fri, 03 Feb 2012 20:42:56 -0600
Message-ID: <4F2C9B30.1030902@sandeen.net>
References: <1327091686-23177-1-git-send-email-jack@suse.cz> <1327091686-23177-7-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
	Surbhi Palande <csurbhi@gmail.com>,
	Kamal Mostafa <kamal@canonical.com>,
	Christoph Hellwig <hch@infradead.org>,
	LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:38884 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783Ab2BDCm7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Feb 2012 21:42:59 -0500
In-Reply-To: <1327091686-23177-7-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 1/20/12 2:34 PM, Jan Kara wrote:
> m_active_trans counter is racy wrt filesystem freezing. The patch replaces it
> with generic counter of running transactions which is properly synchronized
> with filesystem freezing. Things are a bit more complex because we need to log
> a dummy transaction and free block counters after the filesystem is frozen so
> we need to pass information to _xfs_trans_alloc() whether the transaction is
> part of filesystem freezing or not.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---

...

>  xfs_trans_t *
>  _xfs_trans_alloc(
>  	xfs_mount_t	*mp,
>  	uint		type,
> -	uint		memflags)
> +	uint		memflags,
> +	bool		freezing)
>  {
>  	xfs_trans_t	*tp;
>  
> -	atomic_inc(&mp->m_active_trans);
> -
> +	if (!freezing)
> +		sb_start_write(mp->m_super, SB_FREEZE_TRANS);
> +	else
> +		WARN_ON(xfs_test_for_freeze(mp) != SB_FREEZE_TRANS);

Hm this could be an issue because for both the umount path and the 
freeze / xfs_quiesce_attr path, we call xfs_log_sbcount which sends
"true" for freezing and we'll trip up here because we won't be
in SB_FREEZE_TRANS during umount.

I think we have to push the flag all the way up to xfs_log_sbcount
callers?

-Eric
