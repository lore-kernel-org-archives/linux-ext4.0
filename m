From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: let ext4_discard_partial_buffers handle
 pages without buffers correctly
Date: Tue, 13 Dec 2011 22:05:58 -0500
Message-ID: <20111214030558.GD6276@thunk.org>
References: <1322039726-3587-1-git-send-email-xiaoqiangnk@gmail.com>
 <1322039726-3587-2-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, achender@linux.vnet.ibm.com
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:39696 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754032Ab1LNDGA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 Dec 2011 22:06:00 -0500
Content-Disposition: inline
In-Reply-To: <1322039726-3587-2-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 23, 2011 at 05:15:26PM +0800, Yongqiang Yang wrote:
> If a page has been read to memory and never been written, it has no buffers,
> but we should handle the page in truncate or punch hole.
> 
> Vfs code of writing operations has handled holes correctly, so this patch removes
> the code handling hole in writing operations.
> 
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>

Thanks, applied.

						- Ted
