From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH 0/2] Fix aio completion vs unwritten extents
Date: Fri, 16 Jul 2010 02:30:07 -0400
Message-ID: <D4FBB738-1BAF-4100-BA6E-6CAC184BC30B@mit.edu>
References: <20100622122144.302857146@bombadil.infradead.org> <20100716060405.GA32712@infradead.org>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-5.MIT.EDU ([18.7.68.34]:64901 "EHLO
	dmz-mailsec-scanner-5.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935636Ab0GPGaU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Jul 2010 02:30:20 -0400
In-Reply-To: <20100716060405.GA32712@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Jul 16, 2010, at 2:04 AM, Christoph Hellwig wrote:

> Given that this still hasn't been picked up in any other tree would
> people mind if we push patches 1 and 2 through the XFS tree?
> 
> I some more changes that sit ontop of this, and it would make my
> life a lot easier.


Thanks for bringing this up.  I was going to ask if you had any changes
in patch1 of this series since I was about to put them into the ext4 tree
and I didn't want to have any merge conflicts (or have to force a tree
rewind/rebase) if it turned out if there had been some changes and
some other tree landed in Linus's tree first.

In other words, since we both have patches that depend on your
first patch, one easy way of handling things is that we both put them
into our respective fs trees, and as long as the patch doesn't change
git should do the right thing when Steve or Linus merges them into their
linux-next or linus trees, respectively.

Do you have any objections with this?

									- Ted

