From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: What represent 646345728 bytes
Date: Mon, 01 Feb 2010 14:07:24 -0600
Message-ID: <4B67347C.3030103@redhat.com>
References: <20027776.19701265044015458.JavaMail.www@wsfrf1112>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: paul.chavent@fnac.net
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47844 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754594Ab0BAUHa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Feb 2010 15:07:30 -0500
In-Reply-To: <20027776.19701265044015458.JavaMail.www@wsfrf1112>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

paul.chavent@fnac.net wrote:
> Thank you Eric for your reply.
> 
> My problem with preallocation is that i don't know the size of my
> final tar archive. So i would prefer to don't make any supposition.
> 
> Yes, i write a stream of 640x480x1 pnm images (307215 bytes each) to
> a single tar file. So lets say that each write is 307712 (divisible
> by 512 bytes for tar).
> 
> Here is a test bench program that reproduce the behaviour of the real
> app.
> 
> The program log some write overhead at 645579776bytes and other at
> 645887488bytes, so not exactly the same thing as in the real app.
> 
> You will be able to tell me if my test bench is correct (metric,
> compilation options, etc.).

I changed the test for an abnormally long write to printf if the
current time is more than twice the average; the hardcoded time
didn't trip on my run (faster disk?)

uninit_bg

size  480338432 time 10170277 avg 1533119
size  661580800 time  6651861 avg 1559238
size 1025296384 time 16295994 avg 1585389
size 1206538752 time  5157166 avg 1591501
size 1388704256 time 10096621 avg 1596869
size 1570562048 time  6523130 avg 1600365
size 1752727552 time 11047298 avg 1603791
size 1935200768 time  7421506 avg 1606132
size 1963202560 time 13636110 avg 1608181
size 2116750848 time  4634594 avg 1609417
size 2299224064 time 17226228 avg 1612249
diff min : 1468219
diff moy : 1612779
diff max : 17226228
8035 iterations

^uninit_bg

size  125854208 time 11192339 avg 1531071
size  480646144 time  8405476 avg 1537763 *
size  662196224 time  5187685 avg 1562247 *
size  843746304 time 10184477 avg 1577636
size 1025911808 time 15772404 avg 1589258 *
size 1207154176 time  3354220 avg 1594480 *
size 1389011968 time 17024332 avg 1601196 *
size 1570562048 time  5321635 avg 1604032 *
size 1752727552 time 10858699 avg 1607154 *
size 1934585344 time  6316573 avg 1609076 *
size 1963202560 time 12102167 avg 1610854 *
size 1963510272 time  9019437 avg 1612015 *
size 2116135424 time  3464465 avg 1612853 *
size 2297993216 time  8579660 avg 1614396 *
diff min : 1469909
diff moy : 1614416
diff max : 17024332
7493 iterations

* = roughly same offset as with uninit_bg

So uninit_bg doesn't seem to help.  (this was on 2.6.32-ish)

some oprofiling may be in order ...

-Eric

> The system on which i run the test bench has no other workload, no
> other disk access.
> 
> Please find the attached files : - test bench source - the dumpe2fs
> log
> 
> Tonight, i will try with the "-O ^uninit_bg at mkfs time".
> 
> Thanks.
> 
> Paul.
> 
> 
> 

