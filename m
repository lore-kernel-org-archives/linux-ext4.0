From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH V3] resize2fs: clear uninit BG if allocating from new
 group
Date: Sun, 6 Mar 2016 21:51:52 -0500
Message-ID: <20160307025152.GG30238@thunk.org>
References: <55FB41CA.8010003@redhat.com>
 <5697ECEB.3020408@redhat.com>
 <5697F69E.4090404@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38650 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341AbcCGCv4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 6 Mar 2016 21:51:56 -0500
Content-Disposition: inline
In-Reply-To: <5697F69E.4090404@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 14, 2016 at 01:27:26PM -0600, Eric Sandeen wrote:
> If resize2fs_get_alloc_block() allocates from a BLOCK_UNINIT
> group, nothing clears the UNINIT flag, so it is skipped when we
> go to write out modified bitmaps.  This leads to post-resize2fs
> e2fsck errors; used blocks in UNINIT groups, not marked in the
> block bitmap.  This was seen on r_ext4_small_bg.
> 
> This patch uses clear_block_uninit() to clear the flag,
> and my problem goes away.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks, applied.  Apologies for the delay.

							- Ted
