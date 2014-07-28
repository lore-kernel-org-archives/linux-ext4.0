From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 08/18] e2fsck: fix the various checksum error messages
Date: Mon, 28 Jul 2014 00:57:21 -0700
Message-ID: <20140728075721.GL8628@birch.djwong.org>
References: <20140726003339.28334.54447.stgit@birch.djwong.org>
 <20140726003428.28334.68886.stgit@birch.djwong.org>
 <20140726210953.GQ6725@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17529 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaG1H50 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Jul 2014 03:57:26 -0400
Content-Disposition: inline
In-Reply-To: <20140726210953.GQ6725@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jul 26, 2014 at 05:09:53PM -0400, Theodore Ts'o wrote:
> On Fri, Jul 25, 2014 at 05:34:28PM -0700, Darrick J. Wong wrote:
> > Make the "EA block passes checks but fails checksum" message less
> > strange, and make the other checksum error messages actually print a
> > period at the end of the sentence.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Applied (with some slight adjustments since I haven't pulled in the
> previous patch pending discussion).  I note that there was no need to
> adjust any of the expected messages in the e2fsprogs regression tests.
> 
> This indicates that we don't have enough (well, any) regression tests
> covering the metadata checksum feature.  :-(

That's what the metadata checksum test script was supposed to be about.  I'm
not sure if it's actually getting through to anyone -- Google doesn't seem to
have any links to it.

It's a big script that takes a bunch of mke2fs flags and runs through a bunch
of corruption detection tests to see if the running kernel and e2fsck notice.
The nice thing about the script is that it can cycle through a lot of different
features, block sizes, etc. pretty quickly, which seems difficult to do with
the plain 'make check' tests.

I could look into turning them into a bunch of ext4 xfstests.

--D
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
