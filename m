From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/5] mballoc: code cleanup in mb_find_buddy()
Date: Thu, 24 Feb 2011 14:06:45 -0500
Message-ID: <20110224190645.GU2924@thunk.org>
References: <4D4E2958.2010705@coly.li>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Alex Tomas <alex@clusterfs.com>,
	Theodore Tso <tytso@google.com>
To: Coly Li <i@coly.li>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33057 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753409Ab1BXTGt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Feb 2011 14:06:49 -0500
Content-Disposition: inline
In-Reply-To: <4D4E2958.2010705@coly.li>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Feb 06, 2011 at 12:53:44PM +0800, Coly Li wrote:
> Current code calculate max no matter whether order is zero, it's
> unnecessary. This cleanup patch sets max to "1 << (e4b->bd_blkbits
> + 3)" only when order == 0.
> 
> Signed-off-by: Coly Li <bosong.ly@taobao.com>
> Cc: Alex Tomas <alex@clusterfs.com>
> Cc: Theodore Tso <tytso@google.com>

Added to the ext4 patch queue, thanks!

						- Ted
