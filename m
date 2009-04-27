From: Theodore Tso <tytso@mit.edu>
Subject: Re: Question on block group allocation
Date: Mon, 27 Apr 2009 06:42:21 -0400
Message-ID: <20090427104221.GB9059@mit.edu>
References: <6601abe90904230941x5cdd590ck2d51410326df2fc5@mail.gmail.com> <20090423190817.GN3209@webber.adilger.int> <6601abe90904231502y393155dbrf8913b728c704320@mail.gmail.com> <20090427021411.GA9059@mit.edu> <6601abe90904262229w602e17d8s51ceae05c2895ce5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:56548 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752079AbZD0Km3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Apr 2009 06:42:29 -0400
Content-Disposition: inline
In-Reply-To: <6601abe90904262229w602e17d8s51ceae05c2895ce5@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Apr 26, 2009 at 11:29:39PM -0600, Curt Wohlgemuth wrote:
> 
> The random read throughput on the 10GB file went from ~16 MB/s to ~22
> MB/s after Andreas' patch; the total fragmentation of the file was
> much lower than before his patch.
> 
> However, the number of extents went up by quite a bit (I don't have
> the debugfs output in front of me at the moment, sorry).  It seemed
> that no extent crossed a block group; I didn't have time to see if
> Andreas' patch disabled flex BGs or not, as to what was going on.

Try running e2fsck with the "-E fragcheck" option, and then capture
e2fsck's stdout.  It will help with the grunt work of doing the
analysis, in terms of displaying the details of all of the files which
are discontiguous.

						- Ted
