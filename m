From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Try to prepend extent to the existing one
Date: Mon, 1 Apr 2013 11:01:11 -0400
Message-ID: <20130401150111.GB4731@thunk.org>
References: <1363698818-15760-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57799 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758434Ab3DAPBO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Apr 2013 11:01:14 -0400
Content-Disposition: inline
In-Reply-To: <1363698818-15760-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 19, 2013 at 02:13:38PM +0100, Lukas Czerner wrote:
> Currently when inserting extent in ext4_ext_insert_extent() we would
> only try to to see if we can append new extent to the found extent. If
> we can not, then we proceed with adding new extent into the extent tree,
> but then possibly merging it back again.
> 
> We can avoid this situation by trying to append and prepend new extent
> to the existing ones. However since the new extent can be on either
> sides of the existing extent, we have to pick the right extent to try to
> append/prepend to.
> 
> This patch adds the conditions to pick the right extent to
> append/prepend to and adds the actual prepending condition as well. This
> will also eliminate the need to use "reserved" block for possibly
> growing extent tree.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Thanks, added to the dev branch for testing.

					- Ted
