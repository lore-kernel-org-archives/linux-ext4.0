From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: discard + LVM
Date: Sun, 07 Mar 2010 12:38:56 -0500
Message-ID: <yq18wa4c9qn.fsf@sermon.lab.mkp.net>
References: <4B922929.5020006@zappa.cx> <4B933BD6.80100@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Sundstrom <sunkan@zappa.cx>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from acsinet11.oracle.com ([141.146.126.233]:17270 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab0CGRkz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 7 Mar 2010 12:40:55 -0500
In-Reply-To: <4B933BD6.80100@redhat.com> (Eric Sandeen's message of "Sat, 06
	Mar 2010 23:38:30 -0600")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>>>>> "Eric" == Eric Sandeen <sandeen@redhat.com> writes:

Eric> Andreas Sundstrom wrote:
>> Hi..
>> 
>> I have an OCZ agility SSD drive with FW 1.5 that supports the TRIM
>> command.
>> 
>> I can see that it works on a plain partition.  But it does not seem
>> to work together with LVM.
>> 
>> So I'm wondering if this is expected and whether it is something that
>> will be worked on to get fixed?

Eric> It is expected, as lvm is not yet passing discard requests.

I'm working on this.  Missed the 2.6.34 merge window so I'm aiming at
2.6.35.

-- 
Martin K. Petersen	Oracle Linux Engineering
