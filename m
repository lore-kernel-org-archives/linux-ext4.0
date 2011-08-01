From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: get free blocks count of BLOCK_UNINIT groups
 from group desc directly
Date: Mon, 1 Aug 2011 07:20:15 -0400
Message-ID: <20110801112015.GB21388@thunk.org>
References: <1311168774-26378-1-git-send-email-xiaoqiangnk@gmail.com>
 <1311168774-26378-2-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56479 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751784Ab1HALUR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Aug 2011 07:20:17 -0400
Content-Disposition: inline
In-Reply-To: <1311168774-26378-2-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 20, 2011 at 09:32:53PM +0800, Yongqiang Yang wrote:
> This patch teaches ext4 to get free blocks count of BLOCK_UNINIT groups from
> group desc directly.
> 
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>

The reason why we weren't doing this is because older versions of
e2fsprogs I don't think set the free blocks count correctly.  Or at
least, I have a vague memory that this was the case.  I'll have to do
some code archeology before can be 100% sure this is safe to do.

Regards,                      	              	

					- Ted
