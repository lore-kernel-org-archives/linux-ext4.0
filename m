From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: ext4_trim_fs() load buddy only when it is needed
Date: Tue, 24 May 2011 18:18:18 -0400
Message-ID: <20110524221818.GH26055@thunk.org>
References: <1303144351-15614-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:37030 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757506Ab1EXWS1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 May 2011 18:18:27 -0400
Content-Disposition: inline
In-Reply-To: <1303144351-15614-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 18, 2011 at 06:32:31PM +0200, Lukas Czerner wrote:
> Currently we are loading buddy ext4_mb_load_buddy() for every block
> group we are going through in ext4_trim_fs() in many cases just to find
> out that there is not enough space to be bothered with. As Amir Goldstein
> suggested we can use bb_free information directly from ext4_group_info.
> 
> This commit removes ext4_mb_load_buddy() from ext4_trim_fs() and rather
> get the ext4_group_info via ext4_get_group_info() and use the bb_free
> information directly from that. This avoids unnecessary call to load
> buddy in the case the group does not have enough free space to trim.
> Loading buddy is now moved to ext4_trim_all_free().
> 
> Tested by me with xfstests 251.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

I just added this patch to the ext4 tree.  Apologies for not noticing
it earlier.  I had to make a few adjustments to make the patch apply,
but nothing major.

						- Ted
