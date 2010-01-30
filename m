From: tytso@mit.edu
Subject: Re: [PATCH V2] fix type of "offset" in ext4_io_end
Date: Sat, 30 Jan 2010 12:34:58 -0500
Message-ID: <20100130173458.GB788@thunk.org>
References: <4B6327C4.4000100@redhat.com>
 <4B6344E7.9050503@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Giel de Nijs <giel@vectorwise.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:46440 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946Ab0A3RfC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 30 Jan 2010 12:35:02 -0500
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

This looks important enough (and low risk enough) to push to Linus
before the next merge window.   Comments?

						- Ted
