Return-Path: <SRS0=hSPz=NR=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46112 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725951AbeKGHb5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 7 Nov 2018 02:31:57 -0500
Date: Tue, 6 Nov 2018 17:04:33 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Vasily Averin <vvs@virtuozzo.com>
Cc: linux-ext4@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-kernel@vger.kernel.org, Dmitry Monakhov <dmonakhov@gmail.com>
Subject: Re: [PATCH v2 08/11] ext4: lost brelse in ext4_orphan_add()
Message-ID: <20181106220433.GG2570@thunk.org>
References: <cover.1540935522.git.vvs@virtuozzo.com>
 <c747413b-f5e1-d3e0-650b-e3749a98d59d@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c747413b-f5e1-d3e0-650b-e3749a98d59d@virtuozzo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 31, 2018 at 12:58:31AM +0300, Vasily Averin wrote:
> iloc.bh os taken in ext4_reserve_inode_write().
> If (dirty == true) it is released in ext4_mark_iloc_dirty(),
> however it is not released in (dirty == false) case.
> 
> Fixes d745a8c20c1f ("ext4: reduce contention on s_orphan_lock")
> however iloc.bh count balance was broken earlier by
> Fixes 6e3617e579e0 ("ext4: Handle non empty on-disk orphan link") #2.6.34
> 
> cc: Dmitry Monakhov <dmonakhov@gmail.com>
> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>

Thanks, applied.  I fixed up the commit description and Fixes/Cc
trailers.  I used the one-line description:

    ext4: avoid buffer leak in ext4_orphan_add() after prior errors

  	       	       			       - Ted
