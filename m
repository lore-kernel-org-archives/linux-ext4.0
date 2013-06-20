From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Only zero partial blocks in
 ext4_zero_partial_blocks()
Date: Thu, 20 Jun 2013 11:01:03 -0400
Message-ID: <20130620150103.GD28309@thunk.org>
References: <20130619234243.GE24587@thunk.org>
 <1371719673-3033-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:59798 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757593Ab3FTPBL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Jun 2013 11:01:11 -0400
Content-Disposition: inline
In-Reply-To: <1371719673-3033-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 20, 2013 at 11:14:33AM +0200, Lukas Czerner wrote:
> Currently if we pass range into ext4_zero_partial_blocks() which covers
> entire block we would attempt to zero it even though we should only zero
> unaligned part of the block.
> 
> Fix this by checking whether the range covers the whole block skip
> zeroing if so.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Applied, thanks.

						- Ted
