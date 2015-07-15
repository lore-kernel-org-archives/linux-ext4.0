From: Nikolay Borisov <n.borisov@siteground.com>
Subject: Re: [PATCH 0/3] Remove ext3 filesystem driver
Date: Wed, 15 Jul 2015 14:02:56 +0300
Message-ID: <55A63DE0.9010902@kyup.com>
References: <1436955987-7305-1-git-send-email-jack@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jens Axboe <axboe@kernel.dk>, Ted Tso <tytso@mit.edu>
To: Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1436955987-7305-1-git-send-email-jack@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



On 07/15/2015 01:26 PM, Jan Kara wrote:
>   Hello,
> 
>   so I have created this patch set which removes ext3 driver (and some related support
> code) from the kernel. See changelog of patch 2/3 for more details. If noone objects,
> I will queue the series in my tree for the next merge window.

Did you accidentally miss patch 2/3 ?

> 
> Jens, are you OK with me merging patch 3/3 or do you want me to send it to you once
> the first two patches get merged?
> 
> Ted, this also touches ext4 driver so that it always handles ext3 filesystems so ack
> from you would be nice.
> 
> 									Honza
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
