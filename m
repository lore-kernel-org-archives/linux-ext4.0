From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] fix type of "offset" in ext4_io_end
Date: Fri, 29 Jan 2010 15:21:15 -0500
Message-ID: <20100129202115.GC2209@localhost.localdomain>
References: <4B6327C4.4000100@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Giel de Nijs <giel@vectorwise.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752823Ab0A2UVS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 Jan 2010 15:21:18 -0500
Content-Disposition: inline
In-Reply-To: <4B6327C4.4000100@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 29, 2010 at 12:24:04PM -0600, Eric Sandeen wrote:
> The "offset" member in ext4_io_end holds bytes, not
> blocks, so ext4_lblk_t is wrong - and too small (u32)
> 
> This caused the testcase "Possible ext4 data corruption
> with large files and async I/O" sent by Giel to fail when it
> wrapped around to 0.
> 
> Also fix up the type of arguments to
> ext4_convert_unwritten_extents(), it gets ssize_t from
> ext4_end_aio_dio_nolock() and ext4_ext_direct_IO()
> 
> Reported-by: Giel de Nijs <giel@vectorwise.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  

Reviewed-by: Josef Bacik <josef@redhat.com>
