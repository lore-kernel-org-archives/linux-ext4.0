From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: fix freeing bitmap in allocation error path
Date: Wed, 25 May 2011 19:30:45 -0400
Message-ID: <20110525233045.GF9520@thunk.org>
References: <1300702421-4774-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:37480 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752889Ab1EYXas (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 May 2011 19:30:48 -0400
Content-Disposition: inline
In-Reply-To: <1300702421-4774-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 21, 2011 at 11:13:41AM +0100, Lukas Czerner wrote:
> In ext2fs_alloc_generic_bmap() error path, when new bitmap allocation
> fails ext2fs_generic_bitmap should be freed, however in current state it
> first frees ext2fs_generic_bitmap and then
> ext2fs_generic_bitmap->description which is wrong. This commit fix the
> free ordering.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

This was actually pulled into e2fsprogs a while back, but it looks
like I forgot to send an e-mail ack (or mark it as accepted in
patchwork).  So I'm fixing that oversight now.

						- Ted
