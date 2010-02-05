From: tytso@mit.edu
Subject: Re: [PATCH V2] fix type of "offset" in ext4_io_end
Date: Fri, 5 Feb 2010 08:37:51 -0500
Message-ID: <20100205133751.GO25885@thunk.org>
References: <4B6327C4.4000100@redhat.com>
 <4B6344E7.9050503@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>, fmayhar@google.com,
	Giel de Nijs <giel@vectorwise.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:53591 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756001Ab0BENhy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Feb 2010 08:37:54 -0500
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

So I was going to submit this patch to Linus, but the last two times
I've run xfsqa ("xfsqa -g quick" and "xfsqa -g auto"), test #126 has
failed.  If I run the test stand-alone, it passes.  It's a bit of a
head-scratcher.  I'm currently backing out the patch and trying to do
an xfsqa -g auto run to make sure this was something that had crept in
before applying this patch, so this may very well not be this patch
--- I certainly can't see anything wrong with it.  But I thought I
would give a heads up....

      	     	       	       	      	   	- Ted
