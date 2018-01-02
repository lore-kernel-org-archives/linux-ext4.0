From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 04/12] ext2: drop unneeded newline
Date: Tue, 2 Jan 2018 14:42:30 +0100
Message-ID: <20180102134230.GA30307@quack2.suse.cz>
References: <1514386305-7402-1-git-send-email-Julia.Lawall@lip6.fr>
 <1514386305-7402-5-git-send-email-Julia.Lawall@lip6.fr>
 <20171228043042.GB30269@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Julia Lawall <Julia.Lawall@lip6.fr>, Jan Kara <jack@suse.com>,
        kernel-janitors@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50017 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751495AbeABNmd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 2 Jan 2018 08:42:33 -0500
Content-Disposition: inline
In-Reply-To: <20171228043042.GB30269@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 27-12-17 23:30:42, Ted Tso wrote:
> On Wed, Dec 27, 2017 at 03:51:37PM +0100, Julia Lawall wrote:
> > ext2_msg prints a newline at the end of the message string, so the message
> > string does not need to include a newline explicitly.  Done using
> > Coccinelle.
> > 
> > Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Reviewed-by: Theodore Ts'o <tytso@mit.edu>

Thanks. I've picked up the patch to my tree.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
