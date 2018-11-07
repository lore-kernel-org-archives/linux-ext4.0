Return-Path: <SRS0=XuXQ=NS=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49392 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727561AbeKHBj2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 7 Nov 2018 20:39:28 -0500
Date: Wed, 7 Nov 2018 11:08:26 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Vasily Averin <vvs@virtuozzo.com>
Cc: linux-ext4@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-kernel@vger.kernel.org, Tiger Yang <tiger.yang@oracle.com>
Subject: Re: [PATCH 5/7] ext4: bs.bh cleanup before re-using in
 ext4_xattr_block_find()
Message-ID: <20181107160826.GF9919@thunk.org>
References: <cover.1541011937.git.vvs@virtuozzo.com>
 <1a83ea26-a159-490a-1e07-e7c8f187672a@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a83ea26-a159-490a-1e07-e7c8f187672a@virtuozzo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 31, 2018 at 10:12:52PM +0300, Vasily Averin wrote:
> bs.bh was taken in previous ext4_xattr_block_find() call,
> it should be released before re-using
> 
> Fixes 7e01c8e5420b ("ext3/4: fix uninitialized bs in ...") # 2.6.26
> cc: Tiger Yang <tiger.yang@oracle.com>
> 
> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>

Thanks, applied.  I used the commit description:

    ext4: release bs.bh before re-using in ext4_xattr_block_find()

    	  	  	       		   - Ted
