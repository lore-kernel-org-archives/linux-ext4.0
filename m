From: Theodore Tso <tytso@mit.edu>
Subject: Re: EXT4: kernel BUG at fs/jbd2/commit.c:533!
Date: Wed, 2 Sep 2009 18:30:11 -0400
Message-ID: <20090902223011.GA30497@mit.edu>
References: <4A9E5496.8050909@in.ibm.com> <20090902120958.GA16415@mit.edu> <20090902210737.GV4197@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sachin Sant <sachinp@in.ibm.com>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:42752 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753261AbZIBWaM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Sep 2009 18:30:12 -0400
Content-Disposition: inline
In-Reply-To: <20090902210737.GV4197@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 02, 2009 at 03:07:37PM -0600, Andreas Dilger wrote:
> 
> Given the nature of the test being run (fsstress) it seems entirely
> possible that there is some transaction which doesn't reserve enough
> credits for the operation in some rare corner case?

That's possible, although we're running fsstress in the XFSQA tests.

Sanchin, what are the parameters used when you ran fsstress, and how
big is the partition in question?  How many CPU's are in the PowerPC
system in question?

Thanks,

						- Ted
