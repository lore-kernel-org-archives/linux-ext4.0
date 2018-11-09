Return-Path: <SRS0=UyHz=NU=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:32900 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727955AbeKJCYG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 9 Nov 2018 21:24:06 -0500
Date: Fri, 9 Nov 2018 11:42:42 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Vasily Averin <vvs@virtuozzo.com>
Cc: linux-ext4@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] ext4: missing !bh check in ext4_xattr_inode_write()
Message-ID: <20181109164242.GA21078@thunk.org>
References: <20181108145429.GE22459@thunk.org>
 <55574e0e-01a9-3cad-34ab-251e340fb78e@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55574e0e-01a9-3cad-34ab-251e340fb78e@virtuozzo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 09, 2018 at 08:49:48AM +0300, Vasily Averin wrote:
> According to Ted Ts'o ext4_getblk() called in ext4_xattr_inode_write()
> should not return bh = NULL
> 
> The only time that bh could be NULL, then, would be in the case of
> something really going wrong; a programming error elsewhere (perhaps a
> wild pointer dereference) or I/O error causing on-disk file system
> corruption (although that would be highly unlikely given that we had
> *just* allocated the blocks and so the metadata blocks in question
> probably would still be in the cache).
> 
> Fixes e50e5129f384 ("ext4: xattr-in-inode support")
> Cc: stable@kernel.org # 4.13
> 
> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>

Thanks, applied.

						- Ted
