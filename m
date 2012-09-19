From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC][PATCH 2/8 v2] ext4: add operations on extent status tree
Date: Wed, 19 Sep 2012 14:41:14 -0400
Message-ID: <20120919184114.GC28470@thunk.org>
References: <1345615545-26133-1-git-send-email-wenqing.lz@taobao.com>
 <1345615545-26133-3-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Lukas Czerner <lczerner@redhat.com>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Allison Henderson <achender@linux.vnet.ibm.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:51576 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756812Ab2ISSlX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Sep 2012 14:41:23 -0400
Content-Disposition: inline
In-Reply-To: <1345615545-26133-3-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 22, 2012 at 02:05:39PM +0800, Zheng Liu wrote:
> + * Extents status encompass delayed extents and extent locks

I've looked over this patch set, and as near as I can tell, we aren't
(yet) using the extents status structure to do extent-level locking.
I could imagine using that in the future so we aren't using i_data_sem
to lock out the entire tree, so block allocations could happen in
parallel, but that's not here yet.

Is there something I'm missing, or was something else meant by "extent
locks" here?

Thanks,

						- Ted
