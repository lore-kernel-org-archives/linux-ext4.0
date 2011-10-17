From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Check extent overflow with the right range.
Date: Mon, 17 Oct 2011 10:16:05 -0400
Message-ID: <20111017141605.GA25017@thunk.org>
References: <20111017081036.GN30887@longonot.mountain>
 <1318841128-4540-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, dan.carpenter@oracle.com
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:34008 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167Ab1JQOQJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Oct 2011 10:16:09 -0400
Content-Disposition: inline
In-Reply-To: <1318841128-4540-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 17, 2011 at 04:45:28PM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> In 4fd30c033, we move the range check before we change ix to avoid the memory stamp.
> But actually we should check against the EXT_MAX_INDEX, not EXT_LAST_INDEX.
> 
> So this patch revert the old patch and adds a new check before we setting ix.
> 
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
> ---
> Ted, since 4fd30c033 is in your dev branch, I am fine to integrate these 2 patches to one.


Hi Tao,

I have integrated this with the the existing patch in dev branch (since
it isn't in the master branch yet, and hence hasn't been locked down).

I'm wondering though how you originally ran into this case, though.
If there is no more room in the tree node, we should have never
entered ext4_ext_extent_index() in the first place.  Was this a
theoretical concern or did you actually see this happen.  And if so,
was it due to a file system corruption, or another bug someplace else.

Thanks,

						- Ted
