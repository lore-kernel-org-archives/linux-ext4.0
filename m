From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: Re: [PATCH] ext3: prevent reread after write IO error v2
Date: Fri, 15 Jan 2010 19:38:38 +0900
Message-ID: <4B5045AE.9080604@hitachi.com>
References: <4B4EB5B9.4020809@hitachi.com> <4B4EDE5C.8040600@hitachi.com> <4B4EEE86.7080807@hitachi.com> <20100114141803.GB3146@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger@sun.com>,
	"Theodore Ts'o" <tytso@mit.edu>, Nick Piggin <npiggin@suse.de>,
	dle-develop@lists.sourceforge.net,
	Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail7.hitachi.co.jp ([133.145.228.42]:48466 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab0AOKit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Jan 2010 05:38:49 -0500
In-Reply-To: <20100114141803.GB3146@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan Kara wrote:

>>By the way, I think the right fix is to keep uptodate flag on write
>>error, but it gives a big impact.  We have to confirm whether
>>over 200 buffer_uptodate's are used for real uptodate check or write
>>error check.  For now, I adopt the quick-fix solution.
> 
>   Yes that needs to be solved. I also looked into it and it's too much work
> to do it in a one big sweep. But I think we could do the conversion
> filesystem by filesystem - see below.
>   Admittedly, I don't like your solution very much. It looks strange to
> check write_io_error when *reading* the buffer and I'm afraid we could
> introduce bugs e.g. by clearing write_io_error bit so that ext3_bread would
> then fail to detect the error condition or by some other code deciding to
> read the buffer from disk via other function than just ext3_bread. So I
> think it would be much better to set back uptodate flag shortly after the
> failed write or not clear it at all.
>   Now here's how I think we could achieve that without having to change all
> other filesystems: We could create a new superblock flag which would mean
> that "this filesystem handles write_io_error and doesn't want to clear
> uptodate flag". Filesystems with this capability would set this flag when
> calling get_sb_bdev. And if write IO fails we check this flag
> (via bh->b_bdev->bd_super->s_flags) and clear / not clear uptodate flag
> accordingly. What do you think?

Thanks for your comment!

Your suggestion is what I wanted to do ultimately, and it seems
to go well.  I'll send a rivised patch later.

Best regards,
-- 
Hidehiro Kawai
Hitachi, Systems Development Laboratory
Linux Technology Center

