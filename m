From: john stultz <johnstul@us.ibm.com>
Subject: Re: ext4 dbench performance with CONFIG_PREEMPT_RT
Date: Tue, 13 Apr 2010 20:04:50 -0700
Message-ID: <1271214290.2169.254.camel@localhost>
References: <1270682478.3755.58.camel@localhost.localdomain>
	 <20100408034631.GB23188@thunk.org>
	 <1270759317.3373.7.camel@localhost.localdomain>
	 <20100408211054.GB1849@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Mingming Cao <cmm@us.ibm.com>,
	keith maanthey <kmannth@us.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>, Darren Hart <dvhltc@us.ibm.com>,
	djwong <djwong@linux.vnet.ibm.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:54708 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012Ab0DNDEx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Apr 2010 23:04:53 -0400
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com [9.17.195.226])
	by e38.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id o3E2wmxb028285
	for <linux-ext4@vger.kernel.org>; Tue, 13 Apr 2010 20:58:48 -0600
Received: from d03av06.boulder.ibm.com (d03av06.boulder.ibm.com [9.17.195.245])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o3E34qUq123850
	for <linux-ext4@vger.kernel.org>; Tue, 13 Apr 2010 21:04:52 -0600
Received: from d03av06.boulder.ibm.com (loopback [127.0.0.1])
	by d03av06.boulder.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o3E37Urr007523
	for <linux-ext4@vger.kernel.org>; Tue, 13 Apr 2010 21:07:31 -0600
In-Reply-To: <20100408211054.GB1849@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2010-04-08 at 17:10 -0400, tytso@mit.edu wrote:
> On Thu, Apr 08, 2010 at 01:41:57PM -0700, john stultz wrote:
> > 
> > I'll continue to play with your patch and see if I can con some some
> > folks with more interesting storage setups to do some testing as well.
> 
> You might want to ask djwong to play with it with his nice big
> machine.  (We don't need a big file system, but we want as many CPU's
> as possible, and to use his "mailserver" workload to really stress the
> journal.  I'd recommend using barrier=0 for additional journal
> lock-level stress testing, and then try some forced sysrq-b reboots
> and then make sure that the filesystem is consistent after the journal
> replay.)

So I did the above on a 16way that I borrowed from Keith and Darrick.
Got about 5 power-cycles and the journal was recovered and reported
clean by fsck on bootup each time.

So, again, doesn't prove its right, but nothing blew up. 

thanks
-john
 

