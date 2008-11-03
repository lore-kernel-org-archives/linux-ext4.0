From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ext3: wait on all pending commits in ext3_sync_fs
Date: Mon, 3 Nov 2008 14:27:06 -0800
Message-ID: <20081103142706.92e3a2ae.akpm@linux-foundation.org>
References: <4908C951.2000309@redhat.com>
	<20081103184426.GA31894@ajones-laptop.nbttech.com>
	<20081103113318.35b0c266.akpm@linux-foundation.org>
	<20081103201428.GB30565@ajones-laptop.nbttech.com>
	<20081103123750.67c96224.akpm@linux-foundation.org>
	<20081103205854.GC30565@ajones-laptop.nbttech.com>
	<20081103131313.e9ae2f93.akpm@linux-foundation.org>
	<20081103211929.GA18117@mit.edu>
	<20081103132735.9e63a3d0.akpm@linux-foundation.org>
	<20081103220144.GD18117@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: ajones@riverbed.com, sandeen@redhat.com,
	linux-ext4@vger.kernel.org, sct@redhat.com,
	linux-kernel@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33373 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751760AbYKCW2M (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Nov 2008 17:28:12 -0500
In-Reply-To: <20081103220144.GD18117@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 3 Nov 2008 17:01:44 -0500
Theodore Tso <tytso@mit.edu> wrote:

>  static int ext4_sync_fs(struct super_block *sb, int wait)
>  {
> -	tid_t target;
> +	int ret;
>  
>  	trace_mark(ext4_sync_fs, "dev %s wait %d", sb->s_id, wait);
> -	sb->s_dirt = 0;
> -	if (jbd2_journal_start_commit(EXT4_SB(sb)->s_journal, &target)) {
> -		if (wait)
> -			jbd2_log_wait_commit(EXT4_SB(sb)->s_journal, target);
> -	}
> -	return 0;
> +	if (wait)
> +		ret = ext4_force_commit(sb);
> +	else
> +		ret = jbd2_journal_start_commit(EXT4_SB(sb)->s_journal, NULL);
> +	if (!ret)
> +		sb->s_dirt = 0;
> +	return ret;
>  }

It should clear s_dirt before doing the "i/o", methinks?

The usual pattern is

	foo->dirty = 0;
	do_io_on(foo);

because


	do_io_on(foo);
					modify(foo);
					foo->dirty = 1;
	foo->dirty = 0;

is racy.
