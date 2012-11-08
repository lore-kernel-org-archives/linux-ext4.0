From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2 v2] ext4: add a variable to record the value of
 map->m_flags in tracepoint
Date: Thu, 8 Nov 2012 14:34:45 -0500
Message-ID: <20121108193445.GI19977@thunk.org>
References: <1350390934-3101-1-git-send-email-wenqing.lz@taobao.com>
 <1350390934-3101-2-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60080 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757143Ab2KHWLC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Nov 2012 17:11:02 -0500
Content-Disposition: inline
In-Reply-To: <1350390934-3101-2-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 16, 2012 at 08:35:34PM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> When we use trace_ext4_ext/ind_map_blocks_exit, we will print the value of
> map->m_flags in order that we can understand what currently status is.
> 
> CC: Lukas Czerner <lczerner@redhat.com>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>

Applied, thanks.

					- Ted
