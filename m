Return-Path: <SRS0=hSPz=NR=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46048 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726069AbeKGHU3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 7 Nov 2018 02:20:29 -0500
Date: Tue, 6 Nov 2018 16:53:09 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Vasily Averin <vvs@virtuozzo.com>
Cc: linux-ext4@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 07/11] ext4: lost put_bh in ext4_mark_iloc_dirty()
Message-ID: <20181106215309.GF2570@thunk.org>
References: <cover.1540935522.git.vvs@virtuozzo.com>
 <61d28461-8fdd-d614-8bde-844703936ac1@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61d28461-8fdd-d614-8bde-844703936ac1@virtuozzo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 31, 2018 at 12:58:24AM +0300, Vasily Averin wrote:
> ext4_mark_iloc_dirty() callers expect that it releases iloc->bh
> even if it returns an error.
> 
> Fixes 0db1ff222d40 ("ext4: add shutdown bit and check for it") # 4.11
> 
> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>

Thanks, applied.  I fixed up the commit description and Fixes/Cc
trailers.  I used the one-line description:

    ext4: avoid buffer leak on shutdown in ext4_mark_iloc_dirty()

    	  	       	       		- Ted
