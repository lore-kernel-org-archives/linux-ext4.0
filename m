From: Spelic <spelic@shiftmail.org>
Subject: Re: du -s src is a lot slower on SSD than spinning disk in the same
 laptop
Date: Wed, 01 Aug 2012 10:18:56 +0200
Message-ID: <5018E670.4060608@shiftmail.org>
References: <20120725154521.GA3398@merlins.org>
 <20120726033223.GA5884@thunk.org> <20120726065412.GB20315@merlins.org>
 <20120801053042.GG12695@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from blade3.isti.cnr.it ([194.119.192.19]:2599 "EHLO
	blade3.isti.cnr.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337Ab2HAITg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Aug 2012 04:19:36 -0400
Received: from [192.168.6.232] ([155.253.6.254])
 by mx.isti.cnr.it (PMDF V6.5-x6 #31988)
 with ESMTPSA id <01OIJ9UYM46GAH3W3R@mx.isti.cnr.it> for
 linux-ext4@vger.kernel.org; Wed, 01 Aug 2012 10:19:05 +0200 (MEST)
In-reply-to: <20120801053042.GG12695@merlins.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/01/12 07:30, Marc MERLIN wrote:
> 2) Then I put a crucial 256 C300 SSD (the replacement for the one I 
> had that just died and killed all my data), and du took 0.3 seconds on 
> both my old and new thinkpads. 


What does FIO say on your Samsung 830 SSD, 4k random reads?
Last time I checked online benchmarks Samsung 830 had very good 4k 
random reads, but it's difficult to find online benchmarks for 
incompressible data (which fio rightly uses btw)

multithreded test:
vi fiotest_mt.fio
         [random-read]
         rw=randread
         numjobs=20
         thread
         iodepth=10
         group_reporting
         blocksize=4k
         size=512m
         directory=/mnt/<yourmountpoint>
         end_fsync=1
         runtime=10

and single threaded (more important here):
vi fiotest_st.fio
         [random-read]
         rw=randread
         numjobs=1
         thread
         iodepth=1
         group_reporting
         blocksize=4k
         size=4g
         directory=/mnt/<yourmountpoint>
         end_fsync=1
         runtime=10


