From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/6] ext4: move inode indepth shrink logic to didicated
 function
Date: Tue, 25 Oct 2011 04:01:35 -0400
Message-ID: <20111025080135.GA31921@thunk.org>
References: <1319144939-28801-1-git-send-email-dmonakhov@openvz.org>
 <1319144939-28801-3-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, achender@linux.vnet.ibm.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:51607 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753780Ab1JYIBo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Oct 2011 04:01:44 -0400
Content-Disposition: inline
In-Reply-To: <1319144939-28801-3-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 21, 2011 at 01:08:55AM +0400, Dmitry Monakhov wrote:
> - add ext4_ext_try_shrink helper
> - ext4_mark_inode_dirty() called externally in order to allow
>   caller to butch several inode updates in to one mark_dirty call.
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

This patch is broken in two ways:

1) It drops the absolutely necessary calls to ext4_ext_get_access()
    and ext4_ext_dirty().  If you don't do this you will get file
    system corruptions.

2) Some of the callers to the new ext4_ext_try_shrink() helper depends
   on it return 0 or 1 depending on whether the tree was shrunk, but
   others assumed that it would return an error code.  Which is OK,
   since the error codes should be negative, but that means it's
   critical that the callers check to see whether return code is
   really an error before returning it.

Since this is just a cleanup, I'm going to skip this for now.  Dmitry,
could you fix this up and resubmit?   Thanks!!

						- Ted
