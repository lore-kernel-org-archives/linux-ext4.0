From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: EXT3 fuzzing
Date: Fri, 27 Oct 2006 10:26:20 -0500
Message-ID: <4542251C.9050603@redhat.com>
References: <20061027151445.GA13599@alice>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:44438 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S1752305AbWJ0P0Y (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Oct 2006 11:26:24 -0400
To: Eric Sesterhenn / Snakebyte <snakebyte@gmx.de>
In-Reply-To: <20061027151445.GA13599@alice>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Eric Sesterhenn / Snakebyte wrote:
> hi,
> 
> after fsfuzz
> (http://www.securityfocus.com/archive/1/449568/30/0/threaded) was
> released i decided to give it a spin. So far I got two problematic
> images:
> 
> http://www.cobra-basket.de/ext3_ls_prozzy_hog.img.bz2
> 	which makes the kernel use as much cpu as it can get
> 
> http://www.cobra-basket.de/ext3_memhog.img.bz2
> 	eats all memory it can get
> 
> I enabled jbd debugging for a while, and the traces looked
> similar, but made not much sense to me. kmemleak
> locked my box, so I was not able to get some debugging
> info from there.
> To test the images, just mount them, and do an ls
> on the image.

Hi Eric, I recently posted a patch to LKML ([PATCH] handle ext3 directory 
corruption better) to handle the broken fuzz cases I found.  You might try again 
w/ that patch... I can also give your images a whirl.  With the patch I 
submitted, I had thousands of successful fsfuzz runs.  The only snag I hit was 
actually an fsfuzz bug; lost+found/ had been fuzzed so it looked like a pipe, 
and the "cat" part of the test hung up - not really an ext3 bug.

Thanks,

-Eric
