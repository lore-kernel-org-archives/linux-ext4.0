From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/6] ext4: cleanup ext4_ext_grow_indepth code
Date: Sat, 22 Oct 2011 01:27:26 -0400
Message-ID: <20111022052726.GE4196@thunk.org>
References: <1319144939-28801-1-git-send-email-dmonakhov@openvz.org>
 <1319144939-28801-2-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, achender@linux.vnet.ibm.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:51266 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751883Ab1JVHtR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 22 Oct 2011 03:49:17 -0400
Content-Disposition: inline
In-Reply-To: <1319144939-28801-2-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 21, 2011 at 01:08:54AM +0400, Dmitry Monakhov wrote:
> Currently code make an impression what grow procedure is very complicated
> and some mythical paths, blocks are involved. But in fact grow in depth
> it relatively simple procedure:
>  1) Just create new meta block and copy roots content to it
>  2) Convert root from extent to index if old depth == 0
>  3) update root block pointer
> 

Applied, thanks.

BTW: 

>  - Do not pass path parameter to new_meta_block() in order to
>    provoke allocation from inode's group because top-level block
>    should site closer to it's inode, but not to leaf data block.

This happens anyway, due to logic in mballoc; as a result the path
parameter in ext4_ext_new_meta_block() is really pointless, and should
be dropped.

						- Ted
