From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fake direct I/O mode for data=journal
Date: Mon, 15 Aug 2011 14:03:11 -0400
Message-ID: <20110815180311.GC5948@thunk.org>
References: <1313374754-1958-1-git-send-email-tytso@mit.edu>
 <20110815115939.GA6971@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:58197 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790Ab1HOSDO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Aug 2011 14:03:14 -0400
Content-Disposition: inline
In-Reply-To: <20110815115939.GA6971@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 15, 2011 at 01:59:39PM +0200, Jan Kara wrote:
>   Why have you chosen to set O_DSYNC?

O_DSYNC was the closest thing to O_DIRECT, in that writes get forced
to disk after the write finished.  I did this fix a test failure
caused by missing direct I/O writes with a buffered read.  OTOH, there
is a performance cost in doing this since it will force a journal
commit after every write.  That's probably not acceptable.  Hmph.

>   Also what about reads? Mixing of buffered writes and direct IO reads will
> not work because filemap_write_and_write() does not write data block to the
> final location on disk but only to a journal.

Given that, we're probably better off forcing reads drop O_DIRECT as
well and drop O_DSYNC.

I'll change the patch and then give it a test.

     	    	      	       	       	 - Ted
