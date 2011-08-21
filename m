From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4_rename should dirty dir_bh with the correct
 directory
Date: Sun, 21 Aug 2011 14:15:47 -0400
Message-ID: <20110821181547.GB19498@thunk.org>
References: <20110817033544.GO20655@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52091 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292Ab1HUSP7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Aug 2011 14:15:59 -0400
Content-Disposition: inline
In-Reply-To: <20110817033544.GO20655@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 16, 2011 at 08:35:44PM -0700, Darrick J. Wong wrote:
> When ext4_rename performs a directory rename (move), dir_bh is a buffer that is
> modified to update the '..' link in the directory being moved (old_inode).
> However, ext4_handle_dirty_metadata is called with the old parent directory
> inode (old_dir) and dir_bh, which is incorrect because dir_bh does not belong
> to the parent inode.  Fix this error.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Added to the ext4 tree, thanks.

						- Ted
