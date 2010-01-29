From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH V2] fix type of "offset" in ext4_io_end
Date: Fri, 29 Jan 2010 15:32:04 -0500
Message-ID: <20100129203204.GE2209@localhost.localdomain>
References: <4B6327C4.4000100@redhat.com> <4B6344E7.9050503@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Giel de Nijs <giel@vectorwise.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30033 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753098Ab0A2UcU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 Jan 2010 15:32:20 -0500
Content-Disposition: inline
In-Reply-To: <4B6344E7.9050503@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 29, 2010 at 02:28:23PM -0600, Eric Sandeen wrote:
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
> V2: Post-review Josef spotted another size_t in ext4_end_aio_dio_nolock()
> 

Reviewed-by: Josef Back <josef@redhat.com>

probably should have said something before replying to the last email :).
Thanks,

Josef
