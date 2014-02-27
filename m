From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_io: add fzero command for zeroing range via fallocate
Date: Thu, 27 Feb 2014 16:01:50 +1100
Message-ID: <20140227050150.GI29907@dastard>
References: <1393355733-12099-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	xfs@oss.sgi.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:56035 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751646AbaB0FCI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 27 Feb 2014 00:02:08 -0500
Content-Disposition: inline
In-Reply-To: <1393355733-12099-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 25, 2014 at 08:15:33PM +0100, Lukas Czerner wrote:
> Add fzero command which zeroes a range of the file using
> fallocate FALLOC_FL_ZERO_RANGE flag.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Looks ok, but...

> @@ -312,7 +342,17 @@ prealloc_init(void)
>  	fcollapse_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
>  	fcollapse_cmd.args = _("off len");
>  	fcollapse_cmd.oneline =
> -	_("de-allocates space and eliminates the hole by shifting extents");
> +		_("de-allocates space and eliminates the hole by shifting extents");
>  	add_command(&fcollapse_cmd);

I'll drop this change because it pushes the line beyond 80
characters....

Otherwise,

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
