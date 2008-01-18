From: Martin Knoblauch <spamtrap@knobisoft.de>
Subject: Re: regression: 100% io-wait with 2.6.24-rcX
Date: Fri, 18 Jan 2008 00:19:06 -0800 (PST)
Message-ID: <166634.14296.qm@web32603.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Fengguang Wu <wfg@mail.ustc.edu.cn>,
	Mike Snitzer <snitzer@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>, jplatte@naasa.net,
	Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	James.Bottomley@steeleye.com
To: Mel Gorman <mel@csn.ul.ie>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from web32603.mail.mud.yahoo.com ([68.142.207.230]:34183 "HELO
	web32603.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753606AbYARITI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Jan 2008 03:19:08 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

----- Original Message ----
> From: Mel Gorman <mel@csn.ul.ie>
> To: Martin Knoblauch <spamtrap@knobisoft.de>
> Cc: Fengguang Wu <wfg@mail.ustc.edu.cn>; Mike Snitzer <snitzer@gmail.com>; Peter Zijlstra <peterz@infradead.org>; jplatte@naasa.net; Ingo Molnar <mingo@elte.hu>; linux-kernel@vger.kernel.org; "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>; Linus Torvalds <torvalds@linux-foundation.org>; James.Bottomley@steeleye.com
> Sent: Thursday, January 17, 2008 11:12:21 PM
> Subject: Re: regression: 100% io-wait with 2.6.24-rcX
> 
> On (17/01/08 13:50), Martin Knoblauch didst pronounce:
> > > 
> > 
> > The effect  is  defintely  depending on  the  IO  hardware.
> > 
 performed the same tests
> > on a different box with an AACRAID controller and there things
> > look different.
> 
> I take it different also means it does not show this odd performance
> behaviour and is similar whether the patch is applied or not?
>

Here are the numbers (MB/s) from the AACRAID box, after a fresh boot:

Test           2.6.19.2   2.6.24-rc6  2.6.24-rc6-81eabcbe0b991ddef5216f30ae91c4b226d54b6d
dd1             325       350             290
dd1-dir       180       160             160
dd2             2x90     2x113         2x110
dd2-dir       2x120   2x92            2x93
dd3            3x54      3x70           3x70
dd3-dir      3x83      3x64           3x64
mix3          55,2x30  400,2x25   310,2x25

 What we are seing here is that:

a) DIRECT IO takes a much bigger hit (2.6.19 vs. 2.6.24) on this IO system compared to the CCISS box
b) Reverting your patch hurts single stream
c) dual/triple stream are not affected by your patch and are improved over 2.6.19
d) the mix3 performance is improved compared to 2.6.19.
d1) reverting your patch hurts the local-disk part of mix3
e) the AACRAID setup is definitely faster than the CCISS.

 So, on this box your patch is definitely needed to get the pre-2.6.24 performance
when writing a single big file.

 Actually things on the CCISS box might be even more complicated. I forgot the fact
that on that box we have ext2/LVM/DM/Hardware, while on the AACRAID box we have
ext2/Hardware. Do you think that the LVM/MD are sensitive to the page order/coloring?

 Anyway: does your patch only address this performance issue, or are there also
data integrity concerns without it? I may consider reverting the patch for my
production environment. It really helps two thirds of my boxes big time, while it does
not hurt the other third that much :-)

> > 
> >  I can certainly stress the box before doing the tests. Please
> > define "many" for the kernel compiles :-)
> > 
> 
> With 8GiB of RAM, try making 24 copies of the kernel and compiling them
> all simultaneously. Running that for for 20-30 minutes should be enough
> 
 to randomise the freelists affecting what color of page is used for the
> dd  test.
> 

 ouch :-) OK, I will try that.

Martin
