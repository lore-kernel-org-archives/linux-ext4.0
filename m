From: Andreas Dilger <adilger@sun.com>
Subject: Re: [Bug 14830] When other IO is running sync times go to 10 to 20
 minutes
Date: Wed, 27 Jan 2010 12:43:57 -0700
Message-ID: <6465E5ED-8392-4929-9FD6-EFCCA7D75E0B@sun.com>
References: <bug-14830-13602@http.bugzilla.kernel.org/>
 <201001251119.o0PBJDXw012169@demeter.kernel.org>
 <20100127130625.GQ7517@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: Michael Godfrey <godfrey@isl.stanford.edu>,
	linux-ext4@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:40457 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283Ab0A0ToF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Jan 2010 14:44:05 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id o0RJhxAv021550
	for <linux-ext4@vger.kernel.org>; Wed, 27 Jan 2010 11:44:01 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KWX00H008432I00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Wed,
 27 Jan 2010 11:43:59 -0800 (PST)
In-reply-to: <20100127130625.GQ7517@skl-net.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-01-27, at 06:06, Andre Noll wrote:
> On 11:19, bugzilla-daemon@bugzilla.kernel.org wrote:
>> After kill -9 of the sync run it took about 20 minutes before
>> it died.
>
> I was seeing similar behaviour on one of our servers, and changing
> the io scheduler to noop fixed things for me. So it seems to be an
> issue with cfq which is somehow triggered by ext4 but not by ext3.
>
> To change the IO scheduler, just execute
>
> 	echo noop > /sys/block/sda/queue/scheduler

Andre, could you please also test deadline instead of noop?  In  
general, deadline has nearly the same IO behaviour as noop, but still  
allows simple request merging and is generally a better option than  
noop.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

