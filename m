From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: let mpage_submit_io works well when
 blocksize < pagesize
Date: Tue, 13 Dec 2011 22:05:45 -0500
Message-ID: <20111214030545.GC6276@thunk.org>
References: <1322039726-3587-1-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, achender@linux.vnet.ibm.com
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:39692 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754441Ab1LNDFu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 Dec 2011 22:05:50 -0500
Content-Disposition: inline
In-Reply-To: <1322039726-3587-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 23, 2011 at 05:15:25PM +0800, Yongqiang Yang wrote:
> If there is a unwritten but clean buffer in a page and there is a dirty buffer
> after the buffer, then mpage_submit_io does not write the dirty buffer out.
> As a result, da_writepages loops forever.
> 
> This patch fixes the problem by checking dirty flag.
> 
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>

Thanks, applied.

						- Ted
