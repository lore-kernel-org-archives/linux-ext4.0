From: tytso@mit.edu
Subject: Re: [PATCH] ext4: Do not zeroout uninitialized extents beyond
 i_size
Date: Tue, 8 Jun 2010 17:46:51 -0400
Message-ID: <20100608214651.GA6529@thunk.org>
References: <1270833748-14381-1-git-send-email-dmonakhov@openvz.org>
 <87och49oly.fsf@linux.vnet.ibm.com>
 <871ve0qb59.fsf@openvz.org>
 <87d3whuus0.fsf@linux.vnet.ibm.com>
 <87mxvc1ppy.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:41481 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932163Ab0FHVq5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Jun 2010 17:46:57 -0400
Content-Disposition: inline
In-Reply-To: <87mxvc1ppy.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 03, 2010 at 12:32:09PM +0400, Dmitry Monakhov wrote:
> >
> > I thought this patch is going to reworked to use EOFBLOCKS_FL. But i see
> > Ted sent a pull request with the this patch. Did I miss something ?

I added it to the patch queue a week before you sent your comment that
we should rework this with EOFBLOCKS_FL, and I forgot to pull the
patch back.

> As far as i can see EXT4_EOFBLOCKS_FL flag is now allowed for
> uninitialized extents only in e2fslib. So we have to change e2fslib
> first and then revert the kernel zeroout restriction logic.

I think I'm missing something.  What change do you think is needed in
e2fsprogs?

						- Ted



