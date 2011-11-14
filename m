From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3 04/11] e4defrag: Use e2p_get_fragscore() for
 decision of whether to defrag
Date: Mon, 14 Nov 2011 13:22:17 -0500
Message-ID: <20111114182217.GH7698@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@dilger.ca>
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53138 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755843Ab1KNSWW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Nov 2011 13:22:22 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 14, 2011 at 03:24:31PM +0900, Kazuya Mio wrote:
> This makes e4defrag use e2p_get_fragscore() to calculate fragmentation score.
> If the fragmentation score of the original file is non-zero and
> the fragmentation score of donor file is zero, e4defrag calls
> EXT4_IOC_MOVE_EXT ioctl. Because the fragmentation will get better in this case.
> 
> e4defrag uses 4096 as the threshold of fragmentation because the bigger
> threshold(<4096) has little effect on the performance from the following
> results of my experiment.

One of the things that has long bothered me about the whole
"fragmentation score" concept is that it's not clear to me how well it
works across different sized files.  For your experiment you used a
4GB fragmented file.  But does the threshold change if the file is
substantially smaller?  What if it is substantially larger?

I do like the change to tune2fs that removes printing the
fragmentation score, because I think it's highly misleading what it
means, especially when comparing two file's fragmentation score across
two different files which may be of significantly different size.

Perhaps we would be better off if we just simply called this "number
of discontiguous blocks?" and just left it at that?   Just a thought...

   		 	      	   	   - Ted
