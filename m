From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext3: Use unsigned instead of int for type of
	blocksize in fs/ext3/namei.c
Date: Sat, 14 Feb 2009 21:46:15 -0500
Message-ID: <20090215024615.GB10706@mini-me.lan>
References: <4993CC9C.9040308@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Wei Yongjun <yjwei@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:60667 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777AbZBOFdM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 15 Feb 2009 00:33:12 -0500
Content-Disposition: inline
In-Reply-To: <4993CC9C.9040308@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 12, 2009 at 03:15:40PM +0800, Wei Yongjun wrote:
> Use unsigned instead of int for paramter which means blocksize.

Could you please also change size to blocksize, so it's more obvious
what the parameter to dx_make_map() and dx_pack_dirents(), and
resubmit an updated patch to Andrew?  That will make it much more
obvious what is going on.

I'll make the same changes to the patch destined for the ext4 tree myself.

Thanks, regards,

						- Ted
