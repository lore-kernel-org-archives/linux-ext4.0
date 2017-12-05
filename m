From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] e2fsck: Fix access after free for dx_db structure
Date: Mon, 4 Dec 2017 22:11:32 -0500
Message-ID: <20171205031132.fzzhak5d3zgexwp3@thunk.org>
References: <20171104172218.79017-1-artem.blagodarenko@gmail.com>
 <E7D16B41-815E-4A97-9FF0-02BA3B46C892@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Artem Blagodarenko <artem.blagodarenko@gmail.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33400 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751852AbdLEDLe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 4 Dec 2017 22:11:34 -0500
Content-Disposition: inline
In-Reply-To: <E7D16B41-815E-4A97-9FF0-02BA3B46C892@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 05, 2017 at 10:49:55PM -0700, Andreas Dilger wrote:
> On Nov 4, 2017, at 11:22 AM, Artem Blagodarenko <artem.blagodarenko@gmail.com> wrote:
> > 
> > dx_db structure is freed after fixing of PR_2_HTREE_BAD_ROOT
> > problem. Next code block use this structure to unerstand if leaf
> > is beeng processed.
> > 
> > If dx_db is freed, then root block is being processed and if_leaf
> > need to be set to 0.
> > 
> > Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
> 
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>

Thanks, applied.

						- Ted
