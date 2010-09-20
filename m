From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] mke2fs: make "invalid blocks count" error more clear
Date: Mon, 20 Sep 2010 09:26:31 -0400
Message-ID: <20100920132631.GF3554@thunk.org>
References: <4C64402C.3050205@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:34564 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756272Ab0ITN0d (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Sep 2010 09:26:33 -0400
Content-Disposition: inline
In-Reply-To: <4C64402C.3050205@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 12, 2010 at 02:40:44PM -0400, Eric Sandeen wrote:
> Mistakes on the commandline can lead to odd error messages:
> 
> # mke2fs -t ext4 -E stride=128 stripe-width=512 /dev/sda1
> mke2fs: invalid blocks count - /dev/sda1
> 
> Making it a bit more explicit is more obvious:
> 
> mke2fs: invalid blocks count '/dev/sda1' on device 'stripe-width=512'
> 
> (hint, the mistake was no comma separation for -E)
> 
> Reported-by: Adam Huffman <bloch@verdurin.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied to the e2fsprogs maint branch, thanks!!

					- Ted
