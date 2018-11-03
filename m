Return-Path: <SRS0=UtPy=NO=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33594 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726691AbeKDFc3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 4 Nov 2018 01:32:29 -0400
Date: Sat, 3 Nov 2018 16:20:02 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Vasily Averin <vvs@virtuozzo.com>
Cc: linux-ext4@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-kernel@vger.kernel.org,
        Yongqiang Yang <xiaoqiangnk@gmail.com>,
        Yongqiang Yang <yangyongqiang01@baidu.com>
Subject: Re: [PATCH v2 01/11] ext4 resise: extra brelse in
 setup_new_flex_group_blocks()
Message-ID: <20181103202002.GE28850@thunk.org>
References: <cover.1540935522.git.vvs@virtuozzo.com>
 <37de5906-2d76-461a-ff92-b6fcc775b408@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37de5906-2d76-461a-ff92-b6fcc775b408@virtuozzo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 31, 2018 at 12:57:37AM +0300, Vasily Averin wrote:
> currently bh is set to NULL only during first iteration of for cycle,
> then this pointer is not cleared after end of using.
> Therefore rollback after errors can lead to extra brelse(bh) call,
> decrements bh counter and later trigger an unexpected warning in __brelse()
> 
> Patch moves brelse() calls in body of cycle to exclude requirement of
> brelse() call in rollback.
> 
> Fixes 33afdcc5402d ("ext4: add a function which sets up group blocks ...") # 3.3+
> 
> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>

Thanks, applied.  I addjusted the patch summary to read:

    ext4: avoid potential extra brelse in setup_new_flex_group_blocks()

(Note that resise should have been spelled as "resize", by the way.)


						- Ted
