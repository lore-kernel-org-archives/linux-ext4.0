From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: A warning from 3.6+ with bigalloc and delalloc when running
 xfstest
Date: Tue, 9 Oct 2012 09:51:52 -0400
Message-ID: <20121009135152.GA29156@thunk.org>
References: <CANWLp03Kcp75CZPr6DubSExH9GhLUqaLf=xHvLiivprs=z2BvQ@mail.gmail.com>
 <20121009054820.GA8028@thunk.org>
 <20121009062931.GA29314@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54569 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755783Ab2JINwB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Oct 2012 09:52:01 -0400
Content-Disposition: inline
In-Reply-To: <20121009062931.GA29314@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 09, 2012 at 02:29:31PM +0800, Zheng Liu wrote:
> 
> OK, I see.  Thanks for the result.  It is very useful for me to
> understand whether or not my patches break something up.

... and indeed, this is a WARN_ON(1) which is present in the
3.5.0-07665-gf7da9cd kernel, so it's also not a regression.

It is indeed, something we need to fix, and it's part of the problem
where where the delayed allocation for bigalloc is completely screwed
up.  Part of the problem is when we write into a cluster which has not
yet been mapped in the extent tree, but which might (or might not)
have had other blocks in the cluster that have already been subject to
delayed allocation, we don't know whether to reserve clusters for the
purposes of doing the the delayed allocation accounting.  Fixing this
w/o the extent status tree means having to search the page cache and
for other pages in the cluster, which is not only painful, but tricky
from the perspective of lock ordering.

Unfortunately, I didn't notice this problem originally because I
hadn't been doing regular xfstests runs with bigalloc, and most of my
testing had been with direct I/O, where these issues didn't come up.

				- Ted
