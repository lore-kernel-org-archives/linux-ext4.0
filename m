From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext3: Fix an overflow in ext3_trim_fs.
Date: Fri, 4 Mar 2011 00:40:47 +0100
Message-ID: <20110303234047.GA22494@quack.suse.cz>
References: <1299164317-6400-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>,
	Jan Kara <jack@suse.cz>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:55484 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758756Ab1CCXkt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 Mar 2011 18:40:49 -0500
Content-Disposition: inline
In-Reply-To: <1299164317-6400-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 03-03-11 22:58:37, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> In a bs=4096 volume, if we call FITRIM with the following parameter as
> fstrim_range(start = 102400, len = 134144000, minlen = 10240), with the
> following code:
> if (len >= EXT3_BLOCKS_PER_GROUP(sb))
>         len -= (EXT3_BLOCKS_PER_GROUP(sb) - first_block);
> else
>         last_block = first_block + len;
> 
> So if len < EXT3_BLOCKS_PER_GROUP while first_block + len >
> EXT3_BLOCKS_PER_GROUP, last_block will be set to an overflow value
> which exceeds EXT3_BLOCKS_PER_GROUP.
> 
> This patch fixes it and adjusts len and last_block accordingly.
  Thanks. Merged.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
