Return-Path: <SRS0=hSPz=NR=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46280 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727315AbeKGIR2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 7 Nov 2018 03:17:28 -0500
Date: Tue, 6 Nov 2018 17:49:54 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Vasily Averin <vvs@virtuozzo.com>
Cc: linux-ext4@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 10/11] ext4: remove useless brelse call in
 ext4_xattr_inode_update_ref()
Message-ID: <20181106224954.GI2570@thunk.org>
References: <cover.1540935522.git.vvs@virtuozzo.com>
 <fb87bcc2-5e4a-34ba-a063-3f43e9de976c@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb87bcc2-5e4a-34ba-a063-3f43e9de976c@virtuozzo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 31, 2018 at 12:58:46AM +0300, Vasily Averin wrote:
> brelse(iloc.bh) is useless here, it is always called with iloc.bh = NULL
> 
> Fixes dec214d00e0d ("ext4: xattr inode deduplication") # 4.13
> cc: Tahsin Erdogan <tahsin@google.com>
> 
> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>

Applied.  I droppped the "Fixes" since it's really not needed for
stable kernel; this is really more of a cleanup.  I used the commit
description:

    ext4: remove unneeded brelse call in ext4_xattr_inode_update_ref()

    	  	 	  	      - Ted
