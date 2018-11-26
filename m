Return-Path: <SRS0=7vaa=OF=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53028 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726145AbeKZNuT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 26 Nov 2018 08:50:19 -0500
Date: Sun, 25 Nov 2018 21:57:35 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-ext4 <linux-ext4@vger.kernel.org>, Elana.Hashman@twosigma.com
Subject: Re: [PATCH] e2freefrag: fix free blocks count during live scan
Message-ID: <20181126025735.GB7904@thunk.org>
References: <20181108184431.GA27852@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181108184431.GA27852@magnolia>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 08, 2018 at 10:44:31AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In e2freefrag live scan mode, we take the free block count from the
> ondisk superblock.  This leads to screwy histogram percentages:
> 
> Extent Size Range :  Free extents   Free Blocks  Percent
>     4M...    8M-  :             5          8234    1.05%
>    64M...  128M-  :             2         52279    6.64%
>   512M... 1024M-  :             1        202752   25.74%
> 
> ...because there could be superblock updates in the journal that haven't
> yet been checkpointed.  The online scan is perfectly capable of tallying
> the free blocks on its own, so teach it do that and make a more accurate
> report.
> 
> Reported-by: Elana Hashman <Elana.Hashman@twosigma.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
