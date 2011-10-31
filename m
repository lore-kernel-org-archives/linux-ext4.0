From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [patch 2/2] jbd2: use gfp_t instead of int
Date: Mon, 31 Oct 2011 13:53:36 -0400
Message-ID: <20111031175336.GG16825@thunk.org>
References: <20110826092036.GN5975@shale.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "open list:JOURNALLING LAYER..." <linux-ext4@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44568 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754087Ab1JaRxj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 Oct 2011 13:53:39 -0400
Content-Disposition: inline
In-Reply-To: <20110826092036.GN5975@shale.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 26, 2011 at 12:20:37PM +0300, Dan Carpenter wrote:
> This silences some Sparse warnings:
> fs/jbd2/transaction.c:135:69: warning: incorrect type in argument 2 (different base types)
> fs/jbd2/transaction.c:135:69:    expected restricted gfp_t [usertype] flags
> fs/jbd2/transaction.c:135:69:    got int [signed] gfp_mask
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

This has been merged into the ext4 tree (a while ago, actually, but it
looks like I forgot to send an e-mail ack).

					- Ted
