From: vineetagarwal <checkout.vineet@gmail.com>
Subject: Block allocation
Date: Sat, 27 Sep 2008 08:07:06 -0700 (PDT)
Message-ID: <19703506.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kuber.nabble.com ([216.139.236.158]:47837 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbYI0PHH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 27 Sep 2008 11:07:07 -0400
Received: from isper.nabble.com ([192.168.236.156])
	by kuber.nabble.com with esmtp (Exim 4.63)
	(envelope-from <lists@nabble.com>)
	id 1KjbNy-0001nl-VY
	for linux-ext4@vger.kernel.org; Sat, 27 Sep 2008 08:07:06 -0700
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


hello everybody,

I want to allocate few blocks from a blockgroup in ext2 within a range of
offset specified by user. Is it possible of doing so if yes then can someone
please explain.As i know balloc.c and ialloc.c are responsible for it and
they work on entire file system can i somehow manipulate it for ceratin
ranges.

For Ex
let say i provide a range 100 - 3000. Can i allocate few blocks within this
range .

Thanking you

-- 
>From :
Vineet Agarwal
-- 
View this message in context: http://www.nabble.com/Block-allocation-tp19703506p19703506.html
Sent from the linux-ext4 mailing list archive at Nabble.com.

