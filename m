From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfstest: fsstress add EXT2_IOC_{SET,GET}FLAGS
 operations
Date: Sun, 18 Sep 2011 16:03:00 -0400
Message-ID: <20110918200300.GB14899@infradead.org>
References: <1316357699-22692-1-git-send-email-dmonakhov@openvz.org>
 <1316357699-22692-2-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:56119
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932273Ab1IRUDC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 18 Sep 2011 16:03:02 -0400
Content-Disposition: inline
In-Reply-To: <1316357699-22692-2-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Sep 18, 2011 at 06:54:59PM +0400, Dmitry Monakhov wrote:
> Add two new operations:
> - getattr: ioctl(fd, EXT2_IOC_GETFLAGS, &fl)
> - setattr: ioctl(fd, EXT2_IOC_SETFLAGS, &random_flags)
> By default IOC_SET_SETFLAGS has zero probability because
> it may produce inodes with APPEND or IMMUTABLE flags which
> are not deletable by default. Let's assumes that one who
> enable it knows how to delete such inodes.
> For example like follows:
> find $TEST_PATH -exec chattr -i -a {} \;
> rm -rf $TEST_PATH

In general I like this, but:

 - please provide a testcase actually using this new feature, and
 - please don't require e2fsprogs just for the ioctl subcommands,
   and use the FS_IOC_GET/SETFLAGS names provided by recent kernels
   in fs.h instead.  You might still need an ifdef for old kernels,
   like src/t_immutable.c does.  In fact it might be a good idea
   to just provide the values for them if they aren't present in
   a header shared by fsstress and t_immutable.c

