From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: Realign trace events structs to make it smaller
Date: Sun, 12 Aug 2012 22:29:44 -0400
Message-ID: <20120813022944.GC13080@thunk.org>
References: <1342631254-23891-1-git-send-email-anatol.pomozov@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
To: Anatol Pomozov <anatol.pomozov@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44310 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767Ab2HMC3u (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 12 Aug 2012 22:29:50 -0400
Content-Disposition: inline
In-Reply-To: <1342631254-23891-1-git-send-email-anatol.pomozov@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 18, 2012 at 10:07:33AM -0700, Anatol Pomozov wrote:
> Most hardware architectures require that data (including struct fields)
> have to be aligned in memory. To make it happen compiler inserts padding
> between struct fields if they are not aligned correctly.
> 
> Reorder fields to remove paddings and make structures denser. Making data
> smaller saves some memory that is very important for trace events.
> Tracing buffer has limited size and making objects smaller we can put more
> of them without overflowing the tracing buffer.
> 
> To find data struct holes I used 'pahole -H 1 -E -I vmlinux.o' from
> 'dwarves' package.
> 
> Signed-off-by: Anatol Pomozov <anatol.pomozov@gmail.com>

Thanks, applied.

						- Ted
