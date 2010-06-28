From: tytso@mit.edu
Subject: Re: lifetime_write_kbytes isn't preserved during unclean shutdown
Date: Mon, 28 Jun 2010 15:57:39 -0400
Message-ID: <20100628195739.GB6094@thunk.org>
References: <4C2782A7.7040301@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Nebojsa Trpkovic <trx.lists@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:43191 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577Ab0F1T5m (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jun 2010 15:57:42 -0400
Content-Disposition: inline
In-Reply-To: <4C2782A7.7040301@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jun 27, 2010 at 06:56:07PM +0200, Nebojsa Trpkovic wrote:
> I've noticed that lifetime_write_kbytes isn't preserved during unclean
> shutdown.

Yes, right now we are only updating the superblock's lifetime write
kbytes at unmount time.  It should be possible to do a better job; but
I don't want to increase writes to the disk just to keep the
s_lifetime value up-to-date.  So what we should probably do is update
it when we are going to be updating the superblock anyway (i.e., when
we update the orphaned inode linked list) and maybe on some periodic
basis (say once an hour) otherwise.

Thanks for reporting this.  I'll put it on my backlog queue, unless
someone beats me to submitting a patch....

					- Ted
