From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/6] ext4: Do not clear EOFBLOCKS_FL too soon
Date: Tue, 25 Oct 2011 04:18:34 -0400
Message-ID: <20111025081834.GB31921@thunk.org>
References: <1319144939-28801-1-git-send-email-dmonakhov@openvz.org>
 <1319144939-28801-4-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, achender@linux.vnet.ibm.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33505 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753565Ab1JYISl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Oct 2011 04:18:41 -0400
Content-Disposition: inline
In-Reply-To: <1319144939-28801-4-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 21, 2011 at 01:08:56AM +0400, Dmitry Monakhov wrote:
> ext4_ext_insert_extent() may fail due to number of reasons (ENOSPC)
> so let's update eof flag only after extent was successfully inserted.
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

The problem with this patch is that if the check_eofblocks_fl() fails,
the patch jumps to out: and doesn't undo the block allocation and
extent tree manipulation.

I suspect a better way of solving this problem is to keep the existing
order, but to save the state of eofblocks flag, and if
ext4_ext_insert_extent() fails, to restore the state of the eofblocks
flag before jumping to the exit routine.

					- Ted
