From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] test: add f_mke2fs_baddisk v2
Date: Mon, 30 Jan 2017 17:18:17 -0500
Message-ID: <20170130221817.pwgv6q67a2clumjx@thunk.org>
References: <1481122518-19021-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42830 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753069AbdA3WS3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 30 Jan 2017 17:18:29 -0500
Content-Disposition: inline
In-Reply-To: <1481122518-19021-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 07, 2016 at 06:55:17PM +0400, Dmitry Monakhov wrote:
> Check what mke2fs will return non zero error on broken device.
> 
> changes since: v1
>  - skip test if dm-error is not available.
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

I applied this a while ago, but forgot to ack it.  Thanks, applied.

  	       	       	    	- Ted
