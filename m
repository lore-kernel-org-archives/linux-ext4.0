From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: remove mb_groups before tearing buddy_cache
Date: Fri, 1 Jun 2012 00:09:33 -0400
Message-ID: <20120601040933.GE7897@thunk.org>
References: <20120529233422.12259.959.stgit@dungbeetle.mtv.corp.google.com>
 <20120529233614.12259.28652.stgit@dungbeetle.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Ts'o <tytso@google.com>, linux-ext4@vger.kernel.org
To: Salman Qazi <sqazi@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46891 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742Ab2FAEJf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 Jun 2012 00:09:35 -0400
Content-Disposition: inline
In-Reply-To: <20120529233614.12259.28652.stgit@dungbeetle.mtv.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 29, 2012 at 04:36:14PM -0700, Salman Qazi wrote:
> We can't have references held on pages in the s_buddy_cache while we are
> trying to truncate its pages and put the inode.  All the pages must be
> gone before we reach clear_inode.  This can only be gauranteed if we
> can prevent new users from grabbing references to s_buddy_cache's pages.
> 
> The original bug can be reproduced and the bug fix can be verified by:
> 
> while true; do mount -t ext4 /dev/ram0 /export/hda3/ram0; \
> 	umount /export/hda3/ram0; done &
> 
> while true; do cat /proc/fs/ext4/ram0/mb_groups; done
> 
> Signed-off-by: Salman Qazi <sqazi@google.com>

Applied, thanks.

						- Ted
