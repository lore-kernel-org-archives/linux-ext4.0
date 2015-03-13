From: Adrian Bridgett <adrian@smop.co.uk>
Subject: Re: very slow SSD with fsync
Date: Fri, 13 Mar 2015 19:33:57 +0000
Message-ID: <55033BA5.9000806@smop.co.uk>
References: <5502F8A3.4020608@smop.co.uk> <20150313152559.GB21922@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:46395 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbbCMTeB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Mar 2015 15:34:01 -0400
Received: by wiwh11 with SMTP id h11so8549259wiw.5
        for <linux-ext4@vger.kernel.org>; Fri, 13 Mar 2015 12:34:00 -0700 (PDT)
In-Reply-To: <20150313152559.GB21922@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 13/03/15 15:25, Theodore Ts'o wrote:
> The obvious thing to do is to try using blktrace to see which I/O
> operations are triggering the problem.  It may just be that the hard
> drive's internal FTL metadata is very badly fragmented.
Damn :-(  Seems a bit odd as it's only a few months old (not used much) 
and OSX _seems_ fine.

Not quite sure what to look for in blktrace.  I see the sync but the 
timestamps in blktrace are near instantaneous vs 1.3, 2.2 seconds 
reported by strace.   Trying a "find" and watching it stall blktrace 
shows this - which to my amateur eyes shows a 0.5s gap between the read 
request at 1.815589 and being issued at 2.373.  Two completions being 
the only occurrence in the middle.  Maybe queue depth was full - but we 
have a two completions earlier.


   8,0    0      226     1.812363080   271  D  WS 498955904 + 16 (     
988) [jbd2
/dm-0-8]
   8,0    0      227     1.812439052     0  C  WS 498955904 + 16 ( 
75972) [0]
   8,4    0      228     1.812456484   271  A FWS 0 + 0 <- (252,0) 0
   8,0    0      229     1.812456838   271  Q FWS [jbd2/dm-0-8]
   8,4    0      230     1.812457124   271  A FWS 0 + 0 <- (252,0) 0
   8,0    0      231     1.812457237   271  Q FWS [jbd2/dm-0-8]
   8,0    0      232     1.812458007   271  G FWS [jbd2/dm-0-8]
   8,0    0      233     1.812458478   271  I FWS (     471) [jbd2/dm-0-8]
   8,0    0      234     1.812465182   271  G FWS [jbd2/dm-0-8]
   8,0    0      235     1.812465316   271  I FWS (     134) [jbd2/dm-0-8]
   8,0    0      236     1.815446245     0  C  RM 507106648 + 8 ( 
3778637) [0]
   8,4    2       11     1.815585457 31072  A  RM 16875872 + 8 <- 
(252,0) 1687382
4
   8,0    2       12     1.815585633 31072  A  RM 507107680 + 8 <- (8,4) 
16875872
   8,0    2       13     1.815586124 31072  Q  RM 507107680 + 8 [find]
   8,0    2       14     1.815588326 31072  G  RM 507107680 + 8 [find]
   8,0    2       15     1.815589269 31072  I  RM 507107680 + 8 ( 943) 
[find]
   8,0    0      237     1.830102994     0  C  WS 0 (17739914) [0]
   8,0    0      238     2.373458367     0  C  WS 0 [0]
   8,0    0      239     2.373469557     0  D  RM 507107680 + 8 
(557880288) [swap
per/0]
   8,4    0      240     2.373486949 15158  A WFS 8724112 + 8 <- (252,0) 
8722064
   8,0    0      241     2.373487336 15158  A WFS 498955920 + 8 <- (8,4) 
8724112
   8,0    0      242     2.373488480 15158  Q WFS 498955920 + 8 
[kworker/0:2]
   8,0    0      243     2.373490158 15158  G WFS 498955920 + 8 
[kworker/0:2]
   8,0    0      244     2.373491573 15158  I WFS 498955920 + 8 ( 1415) 
[kwork
er/0:2]
   8,0    0      245     2.373491927 15158  D  WS 498955920 + 8 ( 354) 
[kworker/0:2]
   8,0    0      246     2.373596570     0  C  WS 498955920 + 8 ( 
104643) [0]
   8,0    0      247     2.375251869     0  C  RM 507107680 + 8 ( 
1782312) [0]
   8,4    2       16     2.375452116 31072  A  RM 16875072 + 8 <- 
(252,0) 16873024
   8,0    2       17     2.375452283 31072  A  RM 507106880 + 8 <- (8,4) 
16875072
   8,0    2       18     2.375452776 31072  Q  RM 507106880 + 8 [find]

I'm looking at  'watch -n0 cat  /proc/diskstats |egrep -v "ram|loop"' 
and it's normally sat down at 0/1 for I/Os in progress (have seen hit 
100 _briefly_ and then drop just as quickly).

> What model SSD is it, by the way?
It's the built-in Apple MBP 512GB drive - "APPLE SSD SM0512F" which 
apparently means Samsung (I've been reading about issues with their 
840EVO drives...

Thanks once again (and for all your immense work over the many, many years!)

Adrian
