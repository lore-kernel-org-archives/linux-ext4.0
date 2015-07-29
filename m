From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: Re: [PATCH 0/3] Remove ext3 filesystem driver
Date: Wed, 29 Jul 2015 15:20:06 +0300
Message-ID: <55B8C4F6.2050502@yandex-team.ru>
References: <1436955987-7305-1-git-send-email-jack@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
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

On 15.07.2015 13:26, Jan Kara wrote:
>    Hello,
>
>    so I have created this patch set which removes ext3 driver (and some related support
> code) from the kernel. See changelog of patch 2/3 for more details. If noone objects,
> I will queue the series in my tree for the next merge window.
>
> Jens, are you OK with me merging patch 3/3 or do you want me to send it to you once
> the first two patches get merged?
>
> Ted, this also touches ext4 driver so that it always handles ext3 filesystems so ack
> from you would be nice.
>
> 									Honza
>

This means some ext3-specific kludges in mm/ could be dropped.
Like page cleanup in try_to_free_buffers() and couple in vmscan.
