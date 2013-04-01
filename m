From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2 v3] ext4: introduce ext4_get_group_number()
Date: Sun, 31 Mar 2013 21:24:17 -0400
Message-ID: <20130401012417.GB3494@thunk.org>
References: <1364398541-4114-1-git-send-email-lczerner@redhat.com>
 <1364398541-4114-2-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57601 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754570Ab3DABYT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 31 Mar 2013 21:24:19 -0400
Content-Disposition: inline
In-Reply-To: <1364398541-4114-2-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 27, 2013 at 04:35:41PM +0100, Lukas Czerner wrote:
> Currently on many places in ext4 we're using
> ext4_get_group_no_and_offset() even though we're only interested in
> knowing the block group of the particular block, not the offset within
> the block group so we can use more efficient way to compute block group.
> 
> This patch introduces ext4_get_group_number() which computes block group
> for a given block much more efficiently. Use this function instead of
> ext4_get_group_no_and_offset() everywhere where we're only interested in
> knowing the block group.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Thanks, applied.

					- Ted
