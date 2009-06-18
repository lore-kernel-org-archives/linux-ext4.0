From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC][PATCH 1/3] Add EXT4_IOC_MOVE_EXT ioctl and related
	functions
Date: Wed, 17 Jun 2009 20:12:39 -0400
Message-ID: <20090618001239.GH7867@mit.edu>
References: <4A164EE8.1070903@rs.jp.nec.com> <20090613132148.GK24336@mit.edu> <4A36005B.6080101@rs.jp.nec.com> <4A388462.9070209@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:35295 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340AbZFRAMj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Jun 2009 20:12:39 -0400
Content-Disposition: inline
In-Reply-To: <4A388462.9070209@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 17, 2009 at 02:51:30PM +0900, Akira Fujita wrote:
> Hi Ted,
> 
> Theodore Tso wrote:
> > As a side note, the static functions in fs/ext4/move_extent.c really
> > don't need the ext4_mext prefix, since static functions don't have
> > namespace issues that require a consistent naming scheme.  (Sometimes
> > a shorter name can also be useful since it avoids needing to line wrap
> > function calls with a long list of parameters.)
> 
> This patch is for "online-defrag" in the ext4 patch queue,
> and changes are as follows:
> 
> - Remove unneeded function prefix (ext4_mext_ or ext4_)
>   in fs/ext4/move_extent.c to make function name shorter.
>   And change some name of functions.
> - Fix error handling issue.
> - Add some argument checks.
> 
> If this patch does not seem to have any problem,
> could you add this change to the ext4 patch queue?

Thanks for your patch; I've folded your improvements changes into the
online-defrag patch in the ext4 patch queue.

Best regards,

					- Ted
