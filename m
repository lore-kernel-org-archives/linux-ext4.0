From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fall back to vmalloc() for large allocations
Date: Mon, 18 Jul 2011 07:36:23 -0400
Message-ID: <20110718113623.GF14869@thunk.org>
References: <1310506846-25843-1-git-send-email-adilger@whamcloud.com>
 <20110718012556.GJ2717@thunk.org>
 <A8CDAA23-61C6-4823-ADB1-7D36CBAFC025@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Yu Jian <yujian@whamcloud.com>
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43948 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128Ab1GRLgZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Jul 2011 07:36:25 -0400
Content-Disposition: inline
In-Reply-To: <A8CDAA23-61C6-4823-ADB1-7D36CBAFC025@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jul 17, 2011 at 11:12:34PM -0600, Andreas Dilger wrote:
> 
> Yu Jian wrote it with help from me, and I made some modifications afterward,
> so I put both of our names down.

OK, I just wanted to know who I should credit as the author in Git.
If you think it should be Yu Jian, could you put in a From: Yu Jian
line?  If you think you made sufficient modifications that you think
it's mainly your code, that's fine.  I just wasn't sure which would
have been more correct, and whether you might have just forgotten an
explicit From: header or not.  Just want to give credit where credit
is due!  :-)

I'm going to mark this patch as "revisions requested" in patchworkand
want for you to send out a broken out patch series.

Many thanks!!

					- Ted
