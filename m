From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [REGRESSION] xfstests #269 without journal failure against 'dev'
 branch
Date: Tue, 19 Feb 2013 01:21:40 +0800
Message-ID: <20130218172140.GA3056@gmail.com>
References: <20130217170918.GA4059@gmail.com>
 <20130218045747.GC10361@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:42844 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755702Ab3BRRG4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Feb 2013 12:06:56 -0500
Received: by mail-pa0-f44.google.com with SMTP id kp1so2944139pab.17
        for <linux-ext4@vger.kernel.org>; Mon, 18 Feb 2013 09:06:55 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20130218045747.GC10361@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Feb 17, 2013 at 11:57:47PM -0500, Theodore Ts'o wrote:
> On Mon, Feb 18, 2013 at 01:09:18AM +0800, Zheng Liu wrote:
> > Hi Ted,
> > 
> > There is a regression in 'dev' branch of ext4.  I can trigger it by
> > xfstests #269 in my desktop with a SSD when journal is disabled.  I
> > run this test case in 3.8-rc7 and it is ok.  So I think this is a
> > regression in 'dev' branch.
> 
> Hmm, I'm not seeing it on my auto run:
> 
> BEGIN TEST: Ext4 4k block w/ no journal Sun Feb 17 06:48:55 EST 2013
> Ran: 001 002 005 006 007 011 013 014 015 020 053 062 069 070 074 075 076 079 083 088 089 091 100 105 112 113 117 120 123 124 125 126 127 128 129 130 131 132 133 135 141 169 184 192 193 198 204 207 208 209 210 211 212 213 214 215 219 221 223 224 225 226 228 230 231 232 233 234 235 236 237 239 240 243 245 246 247 248 249 255 256 257 258 263 269 270 271 272 273 274 275 277 285 289
> Failures: 274
> END TEST: Ext4 4k block w/ no journal Sun Feb 17 08:01:06 EST 2013
> 
> Is this failing for you reliably?  I've double checked all of my test
> runs, and I've never seen test 269 fail for me with the standard 4k no
> journal test run.  Of course, I'm not using an SSD for my tests, so
> that may explain the difference.  I have seen the warning before, but
> it's not a regression, so it on my "we need to examine this closely
> but it's not yet a showstopper list":

Today I run xfstest #269 serveral times (maybe 30 times I guess) against
different commits.  To be honest, It couldn't be always reproduced.  I
summarize the result here.

9fff24aa, I never trigger the regression against this commit.
1139575a, the regression is triggered only one time.
7eedefe8, the regression can be triggered three or four times.
7b690cfa, I could trigger it about six times.

I also run the same test case in another machine, which is almost the
same previous one except that it only has a HDD.  The regression could be
triggered in commit 7eedefe8.  But I don't think this commit can causes
this regression.

In general I agree with you that we need to take care of it but it's not
yet urgent.

Regards,
                                                - Zheng
