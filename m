From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH v2] xfstests:Make 225 compare map and fiemap at each
	block.
Date: Thu, 19 May 2011 14:19:16 -0400
Message-ID: <20110519181916.GC18123@dhcp231-156.rdu.redhat.com>
References: <1305789665-32743-1-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: josef@redhat.com, sandeen@redhat.com, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62098 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933638Ab1ESSFj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 May 2011 14:05:39 -0400
Content-Disposition: inline
In-Reply-To: <1305789665-32743-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 19, 2011 at 03:21:05PM +0800, Yongqiang Yang wrote:
> Due to my carelessness, I induced a ugly patch to ext4's fiemap, but
> 225 could not find it.  So I looked into the 225 and could not figure out
> logic in compare_map_and_fiemap(), which seemed to mix extents with
> blocks.  Then I made 225 compare map and fiemap at each block, the new
> 225 can find another bug in ext4 with 1k block.
> 
> The new 225 works well on ext3, ext4 and xfs with both 1K and 4K block.
> 
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>

Reviewed-by: Josef Bacik <josef@redhat.com>

Thanks,

Josef
