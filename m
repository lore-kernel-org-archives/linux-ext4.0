From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2 v2] ext4: print 'flags' in
 ext4_ext_handle_uninitialized_extents
Date: Thu, 8 Nov 2012 14:31:07 -0500
Message-ID: <20121108193107.GH19977@thunk.org>
References: <1350390934-3101-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60077 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757111Ab2KHWLC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Nov 2012 17:11:02 -0500
Content-Disposition: inline
In-Reply-To: <1350390934-3101-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 16, 2012 at 08:35:33PM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> In trace_ext4_ext_handle_uninitialized_extents we don't care about the value of
> map->m_flags because this value is probably 0, and we prefer to get the value of
> flags because we can know how to handle this extent in this function.
> 
> Reviewed-by: Lukas Czerner <lczerner@redhat.com>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>

Applied, thanks.

						- Ted
