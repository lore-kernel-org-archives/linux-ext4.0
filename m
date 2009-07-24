From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ioctl32 (was Re: filefrag abort)
Date: Thu, 23 Jul 2009 21:38:01 -0500
Message-ID: <4A691E89.2020801@redhat.com>
References: <4A64E650.6020603@cox.net> <20090721020312.GL2416@mit.edu> <4A665E3F.7000109@cox.net> <4A666413.5030301@redhat.com> <20090722170152.GN4231@webber.adilger.int> <4A67EC3B.9060503@redhat.com> <4A690198.4000904@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Ron Johnson <ron.l.johnson@cox.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:54152 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009AbZGXCiG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 23 Jul 2009 22:38:06 -0400
In-Reply-To: <4A690198.4000904@cox.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ron Johnson wrote:
> On 2009-07-22 23:51, Eric Sandeen wrote:
> [snip]
>> I think adding COMPATIBLE_IOCTL(FS_IOC_FIEMAP); to fs/compat_ioctl.c
>> should be enough, I'll try to get it tested tomorrow.
> 
> If the tarball/git tree can be installed under /usr/local, I'd be 
> glad to test it too.
> 

It'd be a kernel patch, not userspace.

And sorry, didn't get to it today....

-Eric
