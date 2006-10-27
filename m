From: Eric Sesterhenn / Snakebyte <snakebyte@gmx.de>
Subject: EXT3 fuzzing
Date: Fri, 27 Oct 2006 17:14:45 +0200
Message-ID: <20061027151445.GA13599@alice>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:10372 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S1752274AbWJ0POs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Oct 2006 11:14:48 -0400
To: linux-ext4@vger.kernel.org
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

hi,

after fsfuzz
(http://www.securityfocus.com/archive/1/449568/30/0/threaded) was
released i decided to give it a spin. So far I got two problematic
images:

http://www.cobra-basket.de/ext3_ls_prozzy_hog.img.bz2
	which makes the kernel use as much cpu as it can get

http://www.cobra-basket.de/ext3_memhog.img.bz2
	eats all memory it can get

I enabled jbd debugging for a while, and the traces looked
similar, but made not much sense to me. kmemleak
locked my box, so I was not able to get some debugging
info from there.
To test the images, just mount them, and do an ls
on the image.

Greetings, Eric

-- 
 www.cobra-basket.de -- just my stuff
