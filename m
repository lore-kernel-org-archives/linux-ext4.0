From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH-e2fsprogs] Allow tune2fs -I if only one group per flex
Date: Mon, 2 Mar 2009 07:40:19 -0500
Message-ID: <20090302124019.GK6973@mit.edu>
References: <1235982560-7725-1-git-send-email-bergwolf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Peng Tao <bergwolf@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:44775 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699AbZCBMkY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Mar 2009 07:40:24 -0500
Content-Disposition: inline
In-Reply-To: <1235982560-7725-1-git-send-email-bergwolf@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 02, 2009 at 04:29:20PM +0800, Peng Tao wrote:
> This can be caused by tune2fs -O flex_bg.
> And tune2fs -I should work okay for such partitions.

It will *probably* work, but again, it would be better to check to
make sure it really was caused by an accidental "tune2fs -O flex_bg".

     	     	    	       	     - Ted
