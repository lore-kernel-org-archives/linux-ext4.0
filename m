From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: remove a wrong BUG_ON in
 ext4_ext_convert_to_initialized
Date: Tue, 13 Dec 2011 22:33:15 -0500
Message-ID: <20111214033315.GE6276@thunk.org>
References: <1323235287-29806-1-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, achender@linux.vnet.ibm.com,
	hughd@google.com
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33221 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754048Ab1LNDdU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 Dec 2011 22:33:20 -0500
Content-Disposition: inline
In-Reply-To: <1323235287-29806-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 07, 2011 at 01:21:26PM +0800, Yongqiang Yang wrote:
> If a file is fallocated on a hole, map->m_lblk + map->m_len may be greater
> than ee_block + ee_len.
> 
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>

Thanks, applied.

					- Ted
