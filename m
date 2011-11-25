From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix race condition when loading block or inode
 bitmaps
Date: Fri, 25 Nov 2011 11:19:42 -0500
Message-ID: <20111125161942.GF5167@thunk.org>
References: <1322183300-12962-1-git-send-email-tytso@mit.edu>
 <4ECEFECE.2050900@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	stable@kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:51436 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754040Ab1KYQT6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Nov 2011 11:19:58 -0500
Content-Disposition: inline
In-Reply-To: <4ECEFECE.2050900@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 25, 2011 at 10:34:54AM +0800, Tao Ma wrote:
> Sorry, but I don't get your meaning here.
> In bitmap_uptodate, we check both the flag of BH_uptodate and
> BH_BITMAP_UPTODATE. And in your patch below, we just move the set of
> bitmap_uptodate after bh_uptodate. So I don't think the above scenario
> would ever happen. Could you please explain it in more detail?

Yes, you're right.  I didn't realize bitmap_uptodate() checked both
bits.  I had assumed it used the same convention as the other
functions that set/git bits in bh_state.

Rats, and I thought I had finally nailed the bug...

						- Ted
