From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] ext4: dynamical adjust the length of zero-out chunk
Date: Mon, 13 Aug 2012 17:35:47 -0400
Message-ID: <20120813213547.GH32484@thunk.org>
References: <1342075703-4537-1-git-send-email-wenqing.lz@taobao.com>
 <4FFEE402.7090601@redhat.com>
 <7B794B69-EF6C-4279-83D7-EA47E35CD54C@dilger.ca>
 <20120813032243.GB13072@thunk.org>
 <20120813173224.GF9117@lenny.home.zabbo.net>
 <20120813184053.GE32484@thunk.org>
 <20120813194902.GG9117@lenny.home.zabbo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	Zheng Liu <wenqing.lz@taobao.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Zheng Liu <gnehzuil.liu@gmail.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Zach Brown <zab@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44514 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752122Ab2HMVf7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Aug 2012 17:35:59 -0400
Content-Disposition: inline
In-Reply-To: <20120813194902.GG9117@lenny.home.zabbo.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 13, 2012 at 12:49:02PM -0700, Zach Brown wrote:
> 
> Indeed.  fio to the rescue.
> 
> I remember Christoph saying something about 64k somewhat recently?  But,
> helpfully, I can't recall the details :).

So here are some quick fio numbers, using a modern 5400rpm 2.5" disk,
using 8192 samples doing random writes at different sizes:

4k     min=0.099 , max=69.980 , avg=1.95249
8k     min=0.112 , max=71.393 , avg=2.39577
16k    min=0.123 , max=79.951 , avg=3.29693
32k    min=0.190 , max=75.846 , avg=3.57158
64k    min=0.305 , max=71.386 , avg=4.43218
128k   min=0.554 , max=77.925 , avg=6.40304
256k   min=1     , max=68     , avg=10.21

If we take into account that a random write into a fallocate'd file
will need to update the extent tree, this is the time that it would
take to do a 4k random write if we are also using a more aggressive
max zero-out length (plus the extent tree block update):

        zerooout +
        4k metadata update
           (ms)
4k         3.90
8k         4.35
16k        5.25
32k        5.52
64k        6.38
128k       8.36
256k      12.16

So I can see going to 64k, but unless we're really concerned about
extent fragmentation, I don't think larger values make a whole lot of
sense, especially if we are concerned about lowering latency
variability when writing into freshly fallocate'd space.  And if the
concern is extent fragmentation, we may be better off fixing our
extent tree manipulation code so we are better at merging adjacent
extent tree blocks instead.

						- Ted
