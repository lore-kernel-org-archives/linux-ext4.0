From: Theodore Tso <tytso@mit.edu>
Subject: Re: Question on block group allocation
Date: Wed, 29 Apr 2009 17:20:43 -0400
Message-ID: <20090429212043.GB24749@mit.edu>
References: <6601abe90904230941x5cdd590ck2d51410326df2fc5@mail.gmail.com> <20090423190817.GN3209@webber.adilger.int> <6601abe90904231502y393155dbrf8913b728c704320@mail.gmail.com> <20090427021411.GA9059@mit.edu> <6601abe90904262229w602e17d8s51ceae05c2895ce5@mail.gmail.com> <20090427224052.GC22104@mit.edu> <20090429191646.GF14264@mit.edu> <6601abe90904291138r6e24c04dj4b2efcdba22bf84@mail.gmail.com> <20090429193744.GA17797@mit.edu> <6601abe90904291321u3f13d8b0p88b9a9eba5bc03a1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:47399 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754963AbZD2VUy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Apr 2009 17:20:54 -0400
Content-Disposition: inline
In-Reply-To: <6601abe90904291321u3f13d8b0p88b9a9eba5bc03a1@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 29, 2009 at 01:21:09PM -0700, Curt Wohlgemuth wrote:
> 
> Hmm, I thought I attached the output from "e2fsck -E fragcheck"; yes,
> I did: one simple line:
> 
>         /dev/hdm3: clean, 14/45760512 files, 7608255/183010471 blocks

Sorry, I should have been more explicit.   You need to do

"e2fsck -f -E fragcheck", and you will get a *heck* of a lot more than
a single line.  :-)

> And actually, I created the files sequentially:
> 
> dd if=/dev/zero of=$MNT_PT/4g bs=1G count=4
> dd if=/dev/zero of=$MNT_PT/4g-2 bs=1G count=4
> dd if=/dev/zero of=$MNT_PT/10g bs=1G count=10

Really?  Hmm, I wouldn't have expected that.  So now I'd really love
to see the fragcheck results (both with and without the patch), and/or
the results of debugfs stat'ing all three files, both with and without
the patch.

Thanks,

						- Ted
