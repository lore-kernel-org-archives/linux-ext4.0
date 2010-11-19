From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: Add EXT4_IOC_TRIM ioctl to handle batched
 discard
Date: Fri, 19 Nov 2010 11:19:29 -0500
Message-ID: <20101119161929.GI10039@thunk.org>
References: <1290065809-3976-1-git-send-email-lczerner@redhat.com>
 <1290065809-3976-2-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, hch@infradead.org,
	sandeen@redhat.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1290065809-3976-2-git-send-email-lczerner@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Nov 18, 2010 at 08:36:49AM +0100, Lukas Czerner wrote:
> @@ -541,6 +541,7 @@ struct ext4_new_group_data {
>   /* note ioctl 11 reserved for filesystem-independent FIEMAP ioctl */
>  #define EXT4_IOC_ALLOC_DA_BLKS		_IO('f', 12)
>  #define EXT4_IOC_MOVE_EXT		_IOWR('f', 15, struct move_extent)
> +#define EXT4_IOC_TRIM			FITRIM

If we're going to keep FITRIM defined in include/fs.h, then we should
just dispatch off of FITRIM below, and not define EXT4_IOC_TRIM.

> +	case EXT4_IOC_TRIM:
> +	{

Agreed?

There's no point making this look like an EXT4-specific interface; if
other file systems want to implement FITRIM as an ioctl, they are free
to do so.

						- Ted
