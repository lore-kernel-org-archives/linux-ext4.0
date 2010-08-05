From: john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH -v2 0/3] jbd2 scalability patches
Date: Thu, 05 Aug 2010 10:42:08 -0700
Message-ID: <1281030128.3405.2.camel@localhost.localdomain>
References: <1280939957-3277-1-git-send-email-tytso@mit.edu>
	 <1280973537.2678.37.camel@localhost.localdomain>
	 <20100805054211.GF2901@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	ocfs2-devel@oss.oracle.com, Keith Maanthey <kmannth@us.ibm.com>,
	Eric Whitney <eric.whitney@hp.com>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:43861 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391Ab0HERmb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Aug 2010 13:42:31 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id o75Hcp3w014478
	for <linux-ext4@vger.kernel.org>; Thu, 5 Aug 2010 11:38:51 -0600
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o75HgL0I074212
	for <linux-ext4@vger.kernel.org>; Thu, 5 Aug 2010 11:42:21 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id o75HgEaw001236
	for <linux-ext4@vger.kernel.org>; Thu, 5 Aug 2010 11:42:15 -0600
In-Reply-To: <20100805054211.GF2901@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2010-08-05 at 01:42 -0400, Ted Ts'o wrote:
> Thanks, John, for doing these numbers!!!
> 
> > vfs + j_state lock + jdb2 scalability queue
> > Throughput 1214.21 MB/sec 8 procs
> > Throughput 1175.49 MB/sec 4 procs
> > Throughput 716.294 MB/sec 2 procs
> > Throughput 402.988 MB/sec 1 procs
> 
> 2.6.35-rc6-vfs + atomic
> Throughput 2648.42 MB/sec 8 procs
> Throughput 1586.68 MB/sec 4 procs
> Throughput 851.545 MB/sec 2 procs
> Throughput 453.106 MB/sec 1 procs
> 
> Your earlier numbers were quite a bit higher than this latest set.  I
> assume that's due to hardware differences?

So yes, it was run on a different but similar system.

But the numbers I just provided here were with CONFIG_PREEMPT_RT (vfs:
2.6.33-rt23 or novfs: 2.6.33-rt29). Sorry for not making that explicit.

Do you want me to generate non-rt 2.6.35 numbers as well?

thanks
-john


