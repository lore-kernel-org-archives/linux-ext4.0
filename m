Return-Path: <SRS0=UtPy=NO=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33626 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726430AbeKDFkb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 4 Nov 2018 01:40:31 -0400
Date: Sat, 3 Nov 2018 16:28:06 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Vasily Averin <vvs@virtuozzo.com>
Cc: linux-ext4@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-kernel@vger.kernel.org,
        Yongqiang Yang <xiaoqiangnk@gmail.com>,
        Yongqiang Yang <yangyongqiang01@baidu.com>
Subject: Re: [PATCH v2 02/11] ext4 resize: missing brelse() after errors in
 set_flexbg_block_bitmap()
Message-ID: <20181103202806.GF28850@thunk.org>
References: <cover.1540935522.git.vvs@virtuozzo.com>
 <de9191d6-1cb1-6725-f378-b886c9cd06d0@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de9191d6-1cb1-6725-f378-b886c9cd06d0@virtuozzo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 31, 2018 at 12:57:45AM +0300, Vasily Averin wrote:
> Fixes 33afdcc5402d ("ext4: add a function which sets up group blocks ...") # 3.3
> 
> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>

Thanks, applied.  I adjusted the patch summary:

    ext4: add missing brelse() in set_flexbg_block_bitmap()'s error path

Also please note that properly Fixes should have a colon, and to add
Cc: stable@kernel.org to trailer to make sure they get backported:
    
    Fixes: 33afdcc5402d ("ext4: add a function which sets up group blocks ...")
    Cc: stable@kernel.org # 3.3

						- Ted
