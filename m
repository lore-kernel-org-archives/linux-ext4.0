From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix some warnings from sparse check introduced by
 COLLAPSE_RANGE patches
Date: Sat, 12 Apr 2014 13:23:52 -0400
Message-ID: <20140412172352.GH13837@thunk.org>
References: <1397294178-20383-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Namjae Jeon <namjae.jeon@samsung.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53256 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752800AbaDLRYB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 12 Apr 2014 13:24:01 -0400
Content-Disposition: inline
In-Reply-To: <1397294178-20383-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Apr 12, 2014 at 05:16:18PM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> This commit tries to fix some byte order issues that is found by sparse
> check.
> 
> $ make M=fs/ext4 C=2 CF=-D__CHECK_ENDIAN__
> ...
>   CHECK   fs/ext4/extents.c
> fs/ext4/extents.c:5232:41: warning: restricted __le32 degrades to integer
> fs/ext4/extents.c:5236:52: warning: bad assignment (-=) to restricted __le32
> fs/ext4/extents.c:5258:45: warning: bad assignment (-=) to restricted __le32
> fs/ext4/extents.c:5303:28: warning: restricted __le32 degrades to integer
> fs/ext4/extents.c:5318:18: warning: incorrect type in assignment (different base types)
> fs/ext4/extents.c:5318:18:    expected unsigned int [unsigned] [usertype] ex_start
> fs/ext4/extents.c:5318:18:    got restricted __le32 [usertype] ee_block
> fs/ext4/extents.c:5319:24: warning: restricted __le32 degrades to integer
> fs/ext4/extents.c:5334:31: warning: incorrect type in assignment (different base types)
> ...
> 
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> Cc: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>

Thanks, queued for the 3.15 bugfix push.

						- Ted
