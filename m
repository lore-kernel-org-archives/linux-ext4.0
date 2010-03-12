From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] mke2fs: skip alignment questioning if -F specified
Date: Fri, 12 Mar 2010 00:54:39 -0700
Message-ID: <31D4615D-CB8C-48D7-934D-2CDAF327CF44@sun.com>
References: <4B8C1B25.5050006@redhat.com> <20100312024831.GN1497@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:39166 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756Ab0CLHyl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Mar 2010 02:54:41 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id o2C7sepu024369
	for <linux-ext4@vger.kernel.org>; Thu, 11 Mar 2010 23:54:40 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KZ500500S6S0G00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Thu,
 11 Mar 2010 23:54:40 -0800 (PST)
In-reply-to: <20100312024831.GN1497@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-03-11, at 19:48, tytso@mit.edu wrote:
> On Mon, Mar 01, 2010 at 01:53:09PM -0600, Eric Sandeen wrote:
>> RH bug 569021 - mke2fs insists on user interaction even if stdin is  
>> not a tty and -F is passed
>>
>> This is just a warning, -F should easily override it.

Since this is just a warning, do we really need to have "-F" at all?   
I dislike requiring "-F" on common actions, because it means that it  
will commonly be used, but may accidentally override some unintended  
problem.

We've lived without block device alignment until now, and it seems  
somewhat unpleasant that mke2fs may start failing (if -F is not given)  
for situations where it previously worked just fine.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

