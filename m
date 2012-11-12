From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: e2fsck extremly slow after: EXT4-fs.. ext4_check_descriptors:
 Checksum for group .. failed
Date: Mon, 12 Nov 2012 11:16:46 -0500
Message-ID: <20121112161646.GF4895@thunk.org>
References: <CACDumsQsF4JoqygHT+8wQKz-=zuMPjTccrK1mnHnAZsf36O_Cg@mail.gmail.com>
 <20121109000156.GQ19977@thunk.org>
 <CACDumsTj9S2eLNG+zNFY_9ZCZdKGDVVz5SF2BqapS3JvvYP8AA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "kaefert@gmail.com" <kaefert@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60670 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753687Ab2KLQQt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Nov 2012 11:16:49 -0500
Content-Disposition: inline
In-Reply-To: <CACDumsTj9S2eLNG+zNFY_9ZCZdKGDVVz5SF2BqapS3JvvYP8AA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 11, 2012 at 07:14:40PM +0100, kaefert@gmail.com wrote:
> 
> So it took several days, but after running it manually it finished to
> run after a few days. However, It doesn't seem to get the filesystem
> in a truely clean state, although it doesn't print an error (at least
> not at the end), because I've ran e2fsck again on the same partition
> and it found errors again. Here's the output of the last run that
> completed:

You said this is an external USB drive, right?  How big is it?  If
it's affordable, something I would suggest doing is to make image copy
(i.e., using dd or dd_rescue) to another external USB drive, just to
rule out hardware issues.

The Pass 1B/1C/1D errors, particularly if you are seeing the exact
same pattern after running a full e2fsck -fy run, makes me suspicious
that inode table blocks are getting written to the wrong location on
disk --- and whether this is caused by the storage device failing in
some strange way.

Also, can you save the output of e2fsck to a file?  Direct the output
to a log file, so I can look at it.  There are patterns of the
"millions of entries of the same pattern" which you've elided which
can be a hint.  Also, can you disable the German translation to make
it easier for me to investigate?

Thanks,

						- Ted
