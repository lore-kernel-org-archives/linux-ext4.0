From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/4] fs: Prevent doing FALLOC_FL_ZERO_RANGE on append
 only file
Date: Sat, 12 Apr 2014 08:19:35 -0700
Message-ID: <20140412151935.GA18047@infradead.org>
References: <1397242665-2183-1-git-send-email-lczerner@redhat.com>
 <1397242665-2183-2-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1397242665-2183-2-git-send-email-lczerner@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Apr 11, 2014 at 08:57:43PM +0200, Lukas Czerner wrote:
>  	/*
> -	 * It's not possible to punch hole or perform collapse range
> -	 * on append only file
> +	 * It's not possible to punch hole, perform collapse range
> +	 * or zero range on append only file
>  	 */
> -	if (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_COLLAPSE_RANGE)
> +	if (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_COLLAPSE_RANGE |
> +		    FALLOC_FL_ZERO_RANGE)

Might be better to make this a negative test fo the operation that is
allowed on an appen only file.  That's also much better future proof.

