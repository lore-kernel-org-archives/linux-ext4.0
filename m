Return-Path: <SRS0=XuXQ=NS=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49352 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727561AbeKHBdk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 7 Nov 2018 20:33:40 -0500
Date: Wed, 7 Nov 2018 11:02:40 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Vasily Averin <vvs@virtuozzo.com>
Cc: linux-ext4@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] ext4: lost brelse in ext4_xattr_get_block()
Message-ID: <20181107160240.GE9919@thunk.org>
References: <cover.1541011937.git.vvs@virtuozzo.com>
 <42b953ae-72de-4196-09b3-dbac68af9c85@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42b953ae-72de-4196-09b3-dbac68af9c85@virtuozzo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 31, 2018 at 10:12:43PM +0300, Vasily Averin wrote:
> Fixes dec214d00e0d ("ext4: xattr inode deduplication") # 4.13
> 
> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>

Thanks, applied.  I used the description line:

    ext4: fix buffer leak in ext4_xattr_get_block() on error path

    	      	     	     			    - Ted
						    
