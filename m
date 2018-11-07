Return-Path: <SRS0=XuXQ=NS=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49418 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727372AbeKHBmi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 7 Nov 2018 20:42:38 -0500
Date: Wed, 7 Nov 2018 11:11:31 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Cc: Vasily Averin <vvs@virtuozzo.com>, linux-ext4@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-kernel@vger.kernel.org, Kalpak Shah <kalpak@clusterfs.com>
Subject: Re: [PATCH 6/7] ext4: lost brelse in ext4_xattr_move_to_block()
Message-ID: <20181107161131.GG9919@thunk.org>
References: <cover.1541011937.git.vvs@virtuozzo.com>
 <76da5ae3-274d-efa4-58bb-6cd280763a37@virtuozzo.com>
 <20181107135016.GE25758@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181107135016.GE25758@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 07, 2018 at 02:50:16PM +0100, Jan Kara wrote:
> On Wed 31-10-18 22:13:00, Vasily Averin wrote:
> > Fixes 3f2571c1f91f ("ext4: factor out xattr moving")
> > cc: Jan Kara <jack@suse.cz>
> > however issue was present in original ext4_expand_extra_isize_ea()
> > Fixes 6dd4ee7cab7e ("ext4: Expand extra_inodes space per ...") # 2.6.23
> > cc: Kalpak Shah <kalpak@clusterfs.com>
> > 
> > Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
> 
> Good catch. Thanks for the fix. The patch looks good. You can add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>

Thanks, applied.  I used the commit description:

    ext4: fix buffer leak in ext4_xattr_move_to_block() on error path

    	      	     	     - Ted
