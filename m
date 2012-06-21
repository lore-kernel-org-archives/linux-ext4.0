From: Norbert Preining <preining@logic.at>
Subject: Re: Ext4 slow on links
Date: Thu, 21 Jun 2012 15:55:34 +0900
Message-ID: <20120621065534.GA27665@gamma.logic.tuwien.ac.at>
References: <20120620002014.GA25471@gamma.logic.tuwien.ac.at> <20120620021912.GA26323@thunk.org> <20120620033831.GA2395@gamma.logic.tuwien.ac.at> <BA050E9A-2385-4FF9-B41A-3A25F3FF066A@redhat.com> <20120620051844.GA7829@gamma.logic.tuwien.ac.at> <4FE1D91B.8020707@redhat.com> <20120621022818.GD9669@gamma.logic.tuwien.ac.at> <4FE29DA7.40405@redhat.com> <20120621045004.GD18182@gamma.logic.tuwien.ac.at> <F2D9C6D0-92EC-46E1-B040-6E35F077E2E6@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, Ted Ts'o <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:37913 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755611Ab2FUGzl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Jun 2012 02:55:41 -0400
Content-Disposition: inline
In-Reply-To: <F2D9C6D0-92EC-46E1-B040-6E35F077E2E6@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mi, 20 Jun 2012, Andreas Dilger wrote:
> That's what the LD_PRELOAD library that Eric referenced does - you can
> load it for any application, and it will sort the dirents in inode order.

Yes, hmm, I tried it without success. 
I did:
	export LD_PRELOAD=/path/to/spd_readdir.so
	strace -o ... /usr/bin/texlua /usr/bin/mtxrun --generate
(the bad command) and I still see stats and getdents out of
inode order.

> It would definitely be better to do this in glibc, though we've also
> been discussing on occasion doing this inside ext4 for small directories.

I have now found the thread 
	 Large directories and poor order correlation  
from March 2011 on ext4-devel, interesting read. 

Anyway, as far as I can see I cannot do much but
	fsck -D
the filesystem and see if it gets better, right?

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
MARGATE (n.)
A margate is a particular kind of commissionaire who sees you every
day and is on cheerful Christian-name terms with you, then one day
refuses to let you in because you've forgotten your identify card.
			--- Douglas Adams, The Meaning of Liff
