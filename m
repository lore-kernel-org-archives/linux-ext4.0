From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 27/28] ext4: Convert BUG_ON checks to use ext4_error()
 instead
Date: Sun, 07 Mar 2010 10:36:14 -0700
Message-ID: <693CC368-2A80-4BBC-8C8B-4BEEB8E0D098@sun.com>
References: <1267553925-6308-1-git-send-email-tytso@mit.edu>
 <1267553925-6308-28-git-send-email-tytso@mit.edu>
 <87r5nxsitn.fsf@linux.vnet.ibm.com> <20100307024531.GB5395@thunk.org>
 <4B933EE8.8030408@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: tytso@mit.edu,
	"Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Frank Mayhar <fmayhar@google.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:45930 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473Ab0CGRgW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 7 Mar 2010 12:36:22 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id o27HaFVp005315
	for <linux-ext4@vger.kernel.org>; Sun, 7 Mar 2010 09:36:21 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KYX00A00A3GHR00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Sun,
 07 Mar 2010 09:36:15 -0800 (PST)
In-reply-to: <4B933EE8.8030408@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-03-06, at 22:51, Eric Sandeen wrote:
> tytso@mit.edu wrote:
>> On Sat, Mar 06, 2010 at 06:33:48PM +0530, Aneesh Kumar K. V wrote:
>>> I guess ext4_error and ext4_warning are now not taking __func__.  
>>> So we
>>> to be consistant with thos i this this can be in lower case even  
>>> though
>>> they are #defines.
>>
>> Or maybe we should rename them be EXT4_ERROR and EXT4_WARNING.  What
>> do other people think?
>
> As the originator of the lower-case ext4_error and ext4_warning  
> macros,
> I don't much care.
>
> I find the lower case more readable, but if the expectation in fs/ 
> extN is
> that ALL_MACROS_SHALL_BE_UPPER_CASE, that's fine by me.


I think it would make for a lot of code churn without any rel value.   
We have lots of lower-case wrappers around functions for things like  
this already (e.g. ext4_journal_start(), etc.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

