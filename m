From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 2/4]ext4: Replace BUG_ON() with ext4_error() in
	move_extents.c
Date: Wed, 16 Sep 2009 14:18:05 -0400
Message-ID: <20090916181805.GD15451@mit.edu>
References: <4AADFC0F.9010205@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:37818 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437AbZIPSSE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Sep 2009 14:18:04 -0400
Content-Disposition: inline
In-Reply-To: <4AADFC0F.9010205@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 14, 2009 at 05:17:19PM +0900, Akira Fujita wrote:
> ext4: Replace BUG_ON() with ext4_error() in move_extents.c
> 
> From: Akira Fujita <a-fujita@rs.jp.nec.com>
> 
> Replace BUG_ON calls with a call to ext4_error()
> to print an error message if EXT4_IOC_MOVE_EXT failed
> with some kind of reasons. This will help to debug.
> Ted pointed this out, thanks.
> 
> Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>

Applied, thanks.

					- Ted
