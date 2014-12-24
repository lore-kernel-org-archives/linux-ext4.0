From: alex chen <alex.chen@huawei.com>
Subject: Re: [PATCH] ext4: Forbid journal_async_commit in data=ordered mode
Date: Wed, 24 Dec 2014 15:31:54 +0800
Message-ID: <549A6BEA.1050302@huawei.com>
References: <1416930975-13676-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([119.145.14.64]:1734 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbaLXHdf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Dec 2014 02:33:35 -0500
In-Reply-To: <1416930975-13676-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2014/11/25 23:56, Jan Kara wrote:
> Option journal_async_commit breaks gurantees of data=ordered mode as it
> sends only a single cache flush after writing a transaction commit
> block. Thus even though the transaction including the commit block is
> fully stored on persistent storage, file data may still linger in drives
> caches and will be lost on power failure. Since all checksums match on
> journal recovery, we replay the transaction thus possibly exposing stale
> user data.
> 

Hi Jan Kara,
I have two questions:
1. Is the scenario you mentioned above based on local disks, in which
data will be lost along with the host upon power failure?
2. If we use LUNs from IPSAN, I think the scenario you mentioned above
will not happen, because data on ipsan LUN will not be lost as it is
not affected by the host, and IPSAN LUNs are prevented from power
failure, and have mechanisms to guarantee data duration, Am I right?

Thank you.
Alex

> To fix this data exposure issue, remove the possibility to use
> journal_async_commit in data=ordered mode.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/super.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index b53c243a142b..c62445cb01ca 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1701,6 +1701,12 @@ static int parse_options(char *options, struct super_block *sb,
>  			return 0;
>  		}
>  	}
> +	if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_ORDERED_DATA &&
> +	    test_opt(sb, JOURNAL_ASYNC_COMMIT)) {
> +		ext4_msg(sb, KERN_ERR, "can't mount with journal_async_commit "
> +			 "in data=ordered mode");
> +		return 0;
> +	}
>  	return 1;
>  }
>  
> 

