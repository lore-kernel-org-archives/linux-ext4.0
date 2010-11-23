From: Nick Piggin <npiggin@kernel.dk>
Subject: Re: [patch] fs: fix deadlocks in writeback_if_idle
Date: Tue, 23 Nov 2010 21:11:49 +1100
Message-ID: <20101123101149.GB4232@amd>
References: <20101123100239.GA4232@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Al Viro <viro@ZenIV.linux.org.uk>, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Eric Sandeen <sandeen@redhat.com>,
	Theodore Ts'o <tytso@mit.edu>
To: Nick Piggin <npiggin@kernel.dk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:20925 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750724Ab0KWKLz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Nov 2010 05:11:55 -0500
Content-Disposition: inline
In-Reply-To: <20101123100239.GA4232@amd>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 23, 2010 at 09:02:39PM +1100, Nick Piggin wrote:
>  int writeback_inodes_sb_if_idle(struct super_block *sb)
>  {
>  	if (!writeback_in_progress(sb->s_bdi)) {
> -		down_read(&sb->s_umount);
> -		writeback_inodes_sb(sb);
> -		up_read(&sb->s_umount);
> +		bdi_start_writeback(sb->s_bdi, get_nr_dirty_pages());
>  		return 1;
> -	} else
> -		return 0;
> +	}
> +	return 0;
>  }
>  EXPORT_SYMBOL(writeback_inodes_sb_if_idle);
>  
> @@ -1172,17 +1173,18 @@ EXPORT_SYMBOL(writeback_inodes_sb_if_idl
>   *
>   * Invoke writeback_inodes_sb if no writeback is currently underway.
>   * Returns 1 if writeback was started, 0 if not.
> + *
> + * Even if 1 is returned, writeback may not be started if memory allocation
> + * fails. This function makes no guarantees about anything.
>   */
>  int writeback_inodes_sb_nr_if_idle(struct super_block *sb,
>  				   unsigned long nr)
>  {
>  	if (!writeback_in_progress(sb->s_bdi)) {
> -		down_read(&sb->s_umount);
> -		writeback_inodes_sb_nr(sb, nr);
> -		up_read(&sb->s_umount);
> +		bdi_start_writeback(sb->s_bdi, nr);
>  		return 1;
> -	} else
> -		return 0;
> +	}
> +	return 0;
>  }

So I changed btrfs's function too -- I don't think it's too sane to take
s_umount inside a function that advertises itself to be freely called by
filesystems and not having anything of its locking rules documented.

The issue of writeback_inodes_sb being synchronous so far as it has to
wait until the work has been dequeued is another subtlety. That is a
funny interface though, really. It has 3 callers, sync, quota, and
ubifs. From a quick look, quota and ubifs seem to think it is some kind
of synchronous writeout API. It also really sucks that it can get
deadlocked behind an unrelated item in a workqueue. I think it should
just get converted over to the async-submission style as well.
