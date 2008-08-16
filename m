From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH -v3] ext4: Fix small file fragmentation
Date: Sat, 16 Aug 2008 10:58:37 -0400
Message-ID: <20080816145837.GB12978@mit.edu>
References: <1218883460-11445-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:49019 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751885AbYHPPIX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 16 Aug 2008 11:08:23 -0400
Content-Disposition: inline
In-Reply-To: <1218883460-11445-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've tested v3 version of your patch, and it fixes it for me as well.

Using the "compilebench -i 10 -r 0" test, the number of fragmented
files went from 16352 (7.3%) to 32 (0.0%), and the bandwidth went up
by a tiny amount (32.93 MB/s to 33.12 MB/s) --- not enough for me to
be entirely sure that it's outside of measurement error, but I'll take
it.

I've added it to the patch queue.  It's behind mingming's DIO credit
patches, and your ext4_da_writepages rework, since the patch seems to
depend (at least syntatically) on the other patches.  I assume our
best strategy is to try to get those patches cleaned up and moved to
stable, so we can push the whole lot to Linux within the next few
days.

Thanks for working on this problem!

    	     	       	  	       	   - Ted
