From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Dirty ext4 blocks system startup
Date: Tue, 8 Apr 2014 11:28:26 -0400
Message-ID: <20140408152826.GA31558@thunk.org>
References: <1459400.cqhC1n3S74@f209>
 <20140407124820.GB8468@thunk.org>
 <2164274.jmlex94sWc@web.de>
 <1452787.GTL29L0o32@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Markus <M4rkusXXL@web.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51670 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756369AbaDHP2c (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Apr 2014 11:28:32 -0400
Content-Disposition: inline
In-Reply-To: <1452787.GTL29L0o32@web.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 08, 2014 at 04:25:08PM +0200, Markus wrote:
> 
> So I think that fs is now fine again.

Great, I'm glad you were able to recover your data.

> 
> But still, e2fsck should not be trapped in an endless loop.

I agree, it's been on my todo list to fix, one way or another.

  	      	      	      - Ted
