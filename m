From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: let ext4_bio_write_page handle EOF correctly
Date: Tue, 13 Dec 2011 22:33:26 -0500
Message-ID: <20111214033326.GF6276@thunk.org>
References: <1323235287-29806-1-git-send-email-xiaoqiangnk@gmail.com>
 <1323235287-29806-2-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, achender@linux.vnet.ibm.com,
	hughd@google.com
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33226 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754494Ab1LNDd2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 Dec 2011 22:33:28 -0500
Content-Disposition: inline
In-Reply-To: <1323235287-29806-2-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 07, 2011 at 01:21:27PM +0800, Yongqiang Yang wrote:
> We need to zero out part of a page which beyond EOF before setting uptodate,
> otherwise, mapread or write will see non-zero data beyond EOF.
> 
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>

Thanks, applied.

						- Ted
