From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: ext4 xfstests results for 3.8 on Pandaboard ES (ARM)
Date: Mon, 25 Feb 2013 10:47:33 +0800
Message-ID: <20130225024733.GA4477@gmail.com>
References: <20130223000955.GA3231@wallace>
 <5128517A.7000501@gmail.com>
 <20130224193552.GA2320@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f54.google.com ([209.85.210.54]:63849 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759481Ab3BYCck (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 24 Feb 2013 21:32:40 -0500
Received: by mail-da0-f54.google.com with SMTP id p1so648345dad.27
        for <linux-ext4@vger.kernel.org>; Sun, 24 Feb 2013 18:32:39 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20130224193552.GA2320@wallace>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Feb 24, 2013 at 02:35:52PM -0500, Eric Whitney wrote:
> * Zheng Liu <gnehzuil.liu@gmail.com>:
> 
> <snip>
> 
> > > BEGIN TEST: Ext4 4k block w/nodelalloc, no flex_bg, and no extents Thu Feb 21
> > > 15:41:27 EST 2013
> > > Ran: 001 002 005 006 007 011 013 014 015 020 053 062 068 069 070 074 075 076
> > >  077 079 083 088 089 091 100 105 112 113 117 120 123 124 125 126 127 128 129
> > >  130 131 132 133 135 141 169 184 192 193 198 204 207 208 209 210 211 212 215
> > >  219 221 224 225 226 230 231 232 233 234 235 236 237 239 240 245 246 247 248
> > >  249 257 258 263 269 270 271 272 273 275 277 280 285 289 294
> > > Failures: 125 285
> > > END TEST: Ext4 4k block w/nodelalloc, no flex_bg, and no extents Thu Feb 21
> > >  17:24:32 EST 2013
> > > 
> > > Xfstest 285 fails reliably for me on both ARM and x86-64 and only in this test
> > > scenario.  I see the same failure on 3.7, so it's not a regression (however,
> > > this failure doesn't appear in Ted's early 3.8-rc results).
> > > 
> > >     --- 285.out	2013-02-19 15:58:25.110665500 -0500
> > >     +++ 285.out.bad	2013-02-21 17:23:45.156519882 -0500
> > >     @@ -1 +1,3 @@
> > >      QA output created by 285
> > >     +seek sanity check failed!
> > 
> > This test case is used to test seek data/hole feature.  After 3.8 ext4
> > has supported it.  But it will fail without extents feature because
> > indirect-based file haven't unwritten extent.  Please check 285.full
> > file, and you will see that test07 fails.
> > 
> > BTW, I am trying to fix this problem for xfstests.
> > 
> > Regards,
> > 						- Zheng
> > 
> 
> Hi Zheng:
> 
> Thanks very much for your explanation and reminder - it is indeed test07 that
> fails.  I'm looking forward to testing your fix when it's ready.

Actually I just let xfstest #285 check unwritten extent feature.  If the
file system doesn't support it #285 will be skipped.  Meanwhile I create
a new test case that only contains test case 1~6.  You can find first
version in this link [1].

1. http://www.spinics.net/lists/xfs/msg16231.html

Regards,
                                                - Zheng
