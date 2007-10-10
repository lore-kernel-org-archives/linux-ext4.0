From: Jan Kara <jack@ucw.cz>
Subject: Re: max file size for ext3
Date: Thu, 11 Oct 2007 00:17:44 +0200
Message-ID: <20071010221743.GA15035@atrey.karlin.mff.cuni.cz>
References: <470C64BF.509@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:36006 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868AbXJJWRp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Oct 2007 18:17:45 -0400
Content-Disposition: inline
In-Reply-To: <470C64BF.509@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hello,

> I am looking at ext4_max_size and was confused how the
> number upper_limit = 0x1ff7fffd000LL is arrived. 
> The comment says the value is arrived looking at 4K.
> So i tried the below program. 
> 
> main()
> {
> 	unsigned long long upper_limit, meta_blocks;
> 	int bits = 12;
> 
> 	/* total blocks in 512 bytes */
> 	upper_limit = (1LL << 32) - 1;
> 	/* total blocks in file system block size */
> 	upper_limit >>= (bits - 9);
> 
> 
> 	meta_blocks = 1;
> 	/* double indirect blocks */
> 	meta_blocks += 1 + 1LL << (bits-2);
> 	/* tripple indirect blocks */
> 	meta_blocks += 1 + 1LL << (bits-2) + 1LL << (2*(bits-2));
> 
> 	upper_limit -= meta_blocks;
> 	upper_limit <<= bits;
> 
> 	printf("%x\n", upper_limit);
> }
> 
> Can somebody help me to find out what is missing in the above ?
  You actually overestimate the number of triply indirect blocks in your
program above (you count all possible but since the limit is around 2TB
only roughly half of them is really needed).

> I also think hardcoding 4k block size is not correct. I have the below
> patch pending with large file size.
  It is incorrect for blocksize larger than 4096, that's right. Your
patch looks fine - we loose a bit of filesize limit but I don't think it
really matters.

								Honza
