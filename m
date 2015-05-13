From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Htree concept
Date: Wed, 13 May 2015 17:18:54 -0400
Message-ID: <20150513211854.GA25272@thunk.org>
References: <mivr40$2lj$1@ger.gmane.org>
 <55537BF7.8000602@redhat.com>
 <mj019e$f8f$1@ger.gmane.org>
 <mj0250$tvl$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "U.Mutlu" <for-gmane@mutluit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34760 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753375AbbEMVS5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 May 2015 17:18:57 -0400
Content-Disposition: inline
In-Reply-To: <mj0250$tvl$1@ger.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 13, 2015 at 07:37:36PM +0200, U.Mutlu wrote:
> I think I slowly grasp how HTree works: it keeps a (rb/avl tree)
> b*tree-db (I guess it stores it on disk) of the hashes (as keys).

The reason for using hashes is it keeps the fanout of the tree very
high, which in turn keeps the depth of the tree very short.  This
means that we can do search a very large directory using at most three
disk reads (two levels of internal node, where each node can store up
to 340 hashes plus pointers the next level of the tree, plus a
directory leaf block).

> In contrast to that here my idea: keep the hdr blocks (ie. where the
> dir/file names are) always in a sorted order. Then a bsearch should be doable.
> This would eliminate the need for any b*tree-db usage.

The problem with using a binary search is (a) it's more expensive to
search each disk read divides the search space in half (in contrast,
in the best case using htree, the first disk read can divide the
search space by factor of 340), and (b) insertions are very expensive;
suppose you have a 400 megabyte directory, and you need to insert a
filename into the very beginning of the list.  You will have to
performance 800 megabytes of I/O to make room for directory entry, if
you want to keep all of the directory entries sorted.

Cheers,

					- Ted
