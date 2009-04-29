From: Theodore Tso <tytso@mit.edu>
Subject: Re: Question on block group allocation
Date: Wed, 29 Apr 2009 15:37:44 -0400
Message-ID: <20090429193744.GA17797@mit.edu>
References: <20090427021411.GA9059@mit.edu> <6601abe90904262229w602e17d8s51ceae05c2895ce5@mail.gmail.com> <20090429191646.GF14264@mit.edu> <6601abe90904230941x5cdd590ck2d51410326df2fc5@mail.gmail.com> <20090423190817.GN3209@webber.adilger.int> <6601abe90904231502y393155dbrf8913b728c704320@mail.gmail.com> <20090427021411.GA9059@mit.edu> <6601abe90904262229w602e17d8s51ceae05c2895ce5@mail.gmail.com> <20090427224052.GC22104@mit.edu> <6601abe90904291138r6e24c04dj4b2efcdba22bf84@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:44869 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752867AbZD2Thx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Apr 2009 15:37:53 -0400
Content-Disposition: inline
In-Reply-To: <20090429191646.GF14264@mit.edu> <6601abe90904291138r6e24c04dj4b2efcdba22bf84@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 29, 2009 at 03:16:47PM -0400, Theodore Tso wrote:
> 
> When you have a chance, can you send out the details from your test run?
> 

Oops, sorry, our two e-mails overlapped.  Sorry, I didn't see your new
e-mail when I sent my ping-o-gram.

On Wed, Apr 29, 2009 at 11:38:49AM -0700, Curt Wohlgemuth wrote:
> 
> Okay, my phrasing was not as precise as it could have been.  What I
> meant by "total fragmentation" was simply that the range of physical
> blocks for the 10GB file was much lower with Andreas' patch:
> 
> Before patch:  8282112 - 103266303
> After patch: 271360 - 5074943
> 
> The number of extents is much larger.  See the attached debugfs output.

Ah, OK.  You didn't attach the "e2fsck -E fragcheck" output, but I'm
going to guess that the blocks for 10g, 4g, and 4g-2 ended up getting
interleaved, possibly because they were written in parallel, and not
one after each other?  Each of the extents in the "after" debugfs were
proximately 2k blocks (8 megabytes) in length, and are separated by a
largish cnumber of blocks.  

Now, if my theory that the files were written in an interleaved
fashion is correct, if it is also true that they will be read in an
interleaved pattern, the layout on disk might actually be the best
one.  If however they are going to be read sequentially, and you
really want them to be allocated contiguously, then if you know what
the final size of these files will be, then the probably the best
thing to do is to use the fallocate system call.

Does that make sense?

					- Ted
