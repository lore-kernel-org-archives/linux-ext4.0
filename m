From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/3] Remove ext3 filesystem driver
Date: Wed, 15 Jul 2015 08:47:49 -0600
Message-ID: <55A67295.3070509@kernel.dk>
References: <1436955987-7305-1-git-send-email-jack@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Ted Tso <tytso@mit.edu>
To: Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1436955987-7305-1-git-send-email-jack@suse.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 07/15/2015 04:26 AM, Jan Kara wrote:
>    Hello,
>
>    so I have created this patch set which removes ext3 driver (and some related support
> code) from the kernel. See changelog of patch 2/3 for more details. If noone objects,
> I will queue the series in my tree for the next merge window.
>
> Jens, are you OK with me merging patch 3/3 or do you want me to send it to you once
> the first two patches get merged?

You can merge that one, will be easier than splitting. Add my acked-by 
to the patch.


-- 
Jens Axboe

