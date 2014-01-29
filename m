From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: FAST paper on ffsck
Date: Wed, 29 Jan 2014 14:40:22 -0500
Message-ID: <20140129194022.GC30419@thunk.org>
References: <20131209180149.GA6096@thunk.org>
 <20140129185741.GA8798@birch.djwong.org>
 <CAG5DWogJ5SiBfpK6k-_4gB-Roea-F+KWTnDm8xRF1Sf-vmOFFw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	"open list:EXT4 FILE SYSTEM" <linux-ext4@vger.kernel.org>
To: Azat Khuzhin <a3at.mail@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52562 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040AbaA2TkZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Jan 2014 14:40:25 -0500
Content-Disposition: inline
In-Reply-To: <CAG5DWogJ5SiBfpK6k-_4gB-Roea-F+KWTnDm8xRF1Sf-vmOFFw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 29, 2014 at 11:21:07PM +0400, Azat Khuzhin wrote:
> 
> Workload: there are _many_ files that don't deleted, append/full
> rewrite/create only, lifetime 1-2 years:
> 
>      8988871 inodes used (2.09%, out of 429817856)
>      1012499 non-contiguous files (1.7%)
>         2039 non-contiguous directories (0.0%)
>              # of inodes with ind/dind/tind blocks: 0/0/0
>              Extent depth histogram: 8616444/372389/30
> # about 99% blocks in use wrong information, I shrinked fs before
> this, to minimal size


Shrinking the file system is known to result in really horrible
fragmentation.  Part of this is because resize2fs has a really stupid
block allocator, but if you're going to shrink the file system to
minimal size the results can be truly catastrophic from a file
fragmentation point of view.  (Imagine my horror when I was told that
Fedora was creating bootable CD-ROM's by creating a large file system
image, and then using resize2fs -M to shink it to minimal size.  Not
only would the file layout be definitely non-optimal, but worse,
CD-ROM drives are not know for fast seek times!)

We can probably make resize2fs smarter in the case where we are
shrinking the file system slightly (say, to make room for LVM /thinp
metadata when coverting a whole disk file system to one which is being
managed via LVM).  But I'm not sure it's ever going to be worth it
making resize2fs -M generate an optimal, minimally fragmented file
system image.

       	      	      	       	    	 - Ted
