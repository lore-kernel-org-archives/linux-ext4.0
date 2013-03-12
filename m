From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: use atomic64_t for the per-flexbg free_clusters
 count
Date: Tue, 12 Mar 2013 09:45:19 -0400
Message-ID: <20130312134519.GK18595@thunk.org>
References: <1363059885-29942-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52847 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204Ab3CLNpV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Mar 2013 09:45:21 -0400
Content-Disposition: inline
In-Reply-To: <1363059885-29942-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 11, 2013 at 11:44:44PM -0400, Theodore Ts'o wrote:
> A user who was using a 8TB+ file system and with a very large flexbg
> size (> 65536) could cause the atomic_t used in the struct flex_groups
> to overflow.  This was detected by PaX security patchset:
> 
> http://forums.grsecurity.net/viewtopic.php?f=3&t=3289&p=12551#p12551
> 
> Fix this by using an atomic64_t for struct orlav_stats's
> free_clusters.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

I should note that this bug was apparently introduced by commit
9f24e4208f7e, so it's been around for a while (since 2.6.30).
Fortunately it's a pretty rare corner case...

						- Ted
