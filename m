From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: missing trace_ext4_ext_map_blocks_exit after
 calling ext4_ext_handle_uninitialized_extents
Date: Thu, 8 Nov 2012 14:50:06 -0500
Message-ID: <20121108195006.GJ19977@thunk.org>
References: <1350372696-18013-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60112 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757134Ab2KHWVD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Nov 2012 17:21:03 -0500
Content-Disposition: inline
In-Reply-To: <1350372696-18013-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 16, 2012 at 03:31:36PM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> When ext4_ext_handle_uninitialized_extents is called, we will directly return
> from ext4_ext_map_blocks.  The trace point of trace_ext4_ext_map_blocks_exit
> isn't called, and the user doesn't see any result.  This patch tries to fix this
> problem.
> 
> Meanwhile in ext4_ext_handle_uninitialized_extents it returns errors or the
> number of allocated blocks.  So 'ret' variable can be removed due to previously
> modifications.
> 
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>

Applied, thanks.

					- Ted
