From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 1/6] ext4: Add blocks added during resize to bitmap
Date: Sun, 2 Nov 2008 21:33:44 -0500
Message-ID: <20081103023344.GR8134@mit.edu>
References: <1225471859-19718-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, frederic.bohe@bull.net,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:45207 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754093AbYKCCeD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Nov 2008 21:34:03 -0500
Content-Disposition: inline
In-Reply-To: <1225471859-19718-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 31, 2008 at 10:20:54PM +0530, Aneesh Kumar K.V wrote:
> With this change new blocks added during resize
> are marked as free in the block bitmap and the
> group is flagged with EXT4_GROUP_INFO_NEED_INIT_BIT
> flag. This make sure when mballoc tries to allocate
> blocks from the new group we would reload the
> buddy information using the bitmap present in the disk.

My comment about why not use ext4_mb_free_blocks() still applies.
Also, if you're going to replace a patch, please put V2 (or Vn+1) in
the subject like.  I wasted time dealing with your earlier set of
three resize patches since I didn't realize they were replicated in
this six patch series.

Also, Patch 2 of 6 didn't apply as of 2.6.28-rc3.  I fixed it up in
the patch queue, but please check it.

Thanks!!

						- Ted
