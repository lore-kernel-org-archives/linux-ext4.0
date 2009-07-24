From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ioctl32
Date: Fri, 24 Jul 2009 11:28:31 -0500
Message-ID: <4A69E12F.2070904@redhat.com>
References: <4A64E650.6020603@cox.net> <20090721020312.GL2416@mit.edu>	<4A665E3F.7000109@cox.net> <4A666413.5030301@redhat.com>	<20090722170152.GN4231@webber.adilger.int>	<4A67EC3B.9060503@redhat.com> <87k51y11yn.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>,
	Ron Johnson <ron.l.johnson@cox.net>, linux-ext4@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:33417 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356AbZGXQ3b (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Jul 2009 12:29:31 -0400
In-Reply-To: <87k51y11yn.fsf@basil.nowhere.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andi Kleen wrote:
> Eric Sandeen <sandeen@redhat.com> writes:
>> /* pointer to compatible structure or no argument */
>> #define COMPATIBLE_IOCTL(cmd) \
>>         { (cmd), do_ioctl32_pointer },
> 
> 
> The modern way to do this is to use the ->compat_ioctl VFS
> method. COMPATIBLE_IOCTL etc are all obsolete.
> 
>> I think adding COMPATIBLE_IOCTL(FS_IOC_FIEMAP); to fs/compat_ioctl.c
>> should be enough, I'll try to get it tested tomorrow.
> 
> Nope, add a ->compat_ioctl 
> 
> When your ioctl is already a unlocked_ioctl you can just use
> the same function. If not convert to unlocked_ioctl first.
> 
> -Andi

Ok thanks, I knew I needed to revisit it.  ;)

-Eric
