Return-Path: <SRS0=hSPz=NR=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45934 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726514AbeKGGub (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 7 Nov 2018 01:50:31 -0500
Date: Tue, 6 Nov 2018 16:23:17 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Vasily Averin <vvs@virtuozzo.com>
Cc: linux-ext4@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 06/11] ext4 resize: lost resize_inode cleanup before
 retry in ext4_resize_fs()
Message-ID: <20181106212316.GE2570@thunk.org>
References: <cover.1540935522.git.vvs@virtuozzo.com>
 <85ecdd2d-e034-4b15-a872-f8399582b56a@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85ecdd2d-e034-4b15-a872-f8399582b56a@virtuozzo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 31, 2018 at 12:58:16AM +0300, Vasily Averin wrote:
> Fixes 1c6bd7173d66 ("ext4: convert file system to meta_bg if needed ...") # 3.7
> 
> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>

Thanks, applied.  I fixed up the commit description and Fixes/Cc
trailers.

						- Ted
