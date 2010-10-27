From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] Fix compile error in ext4_fallocate()
Date: Wed, 27 Oct 2010 16:33:15 -0400
Message-ID: <20101027203315.GE3194@thunk.org>
References: <4C872506.6040505@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 <linux-ext4@vger.kernel.org>
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:50732 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904Ab0J0UdR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Oct 2010 16:33:17 -0400
Content-Disposition: inline
In-Reply-To: <4C872506.6040505@sx.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 08, 2010 at 02:54:14PM +0900, Kazuya Mio wrote:
> Hi,
> 
> When I compiled 2.6.36-rc3 kernel with EXT4FS_DEBUG definition, I got the
> following compile error.

I've applied this fix to the ext4 patch queue.  Many thanks for the patch!!

     	     	      	     	  	- Ted
