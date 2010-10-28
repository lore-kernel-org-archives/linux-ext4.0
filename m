From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [next-20101038] Call trace in ext4
Date: Thu, 28 Oct 2010 17:06:44 -0400
Message-ID: <20101028210644.GF28126@thunk.org>
References: <AANLkTi=E_uMj_ndGU86DCjX4aDwjHqg3dkwxjQRSJtq6@mail.gmail.com>
 <20101028175221.GA1578@arch.trippelsdorf.de>
 <20101028180118.GC6814@thunk.org>
 <20101028193211.GA28126@thunk.org>
 <AANLkTimHJe9bA-X+JWkspgjb4AZkkgbEFWQiwzO-gx-h@mail.gmail.com>
 <20101028200548.GC28126@thunk.org>
 <AANLkTimw9Vwzy4MXO1t7TnJfwTwYtWcfj0D=Zx8O72cY@mail.gmail.com>
 <20101028203706.GD28126@thunk.org>
 <AANLkTimFgcCVgBrW_oLzn0tUdGwJKfkhDJMf=EVHZ4Vf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
	sfr@canb.auug.org.au, Arnd Bergmann <arnd@arndb.de>,
	Avinash Kurup <kurup.avinash@gmail.com>
To: sedat.dilek@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:57953 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934558Ab0J1VGr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Oct 2010 17:06:47 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTimFgcCVgBrW_oLzn0tUdGwJKfkhDJMf=EVHZ4Vf@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 28, 2010 at 11:02:14PM +0200, Sedat Dilek wrote:
> 
> I could copy a complete linux-2.6 GIT tree within my $HOME/src, looks good.

Excellent; and attempts to do this before resulted on the BUG_ON
tripping?  If so, that's certainly a good sign!

> 
> Any other test-case you can suggest to be sure things work as expected, now?

Well, given that I haven't been able to replicate myself, no, not
really.

I am curious about your setup.  How much memory do you have on your
system, and how much free memory did you have before running the copy?
(i.e, what does the "free" command display)?

> BTW, feel free to add:
> 
>       Reported-andtested-by: Sedat Dilek <sedat.dilek@gmail.com>

I'll certainly give you credit (as well as to the other people who
reported the problem).

Thanks again!!

						- Ted
