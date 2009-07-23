From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ioctl32 (was Re: filefrag abort)
Date: Wed, 22 Jul 2009 23:51:07 -0500
Message-ID: <4A67EC3B.9060503@redhat.com>
References: <4A64E650.6020603@cox.net> <20090721020312.GL2416@mit.edu> <4A665E3F.7000109@cox.net> <4A666413.5030301@redhat.com> <20090722170152.GN4231@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ron Johnson <ron.l.johnson@cox.net>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:51596 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888AbZGWEvN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 23 Jul 2009 00:51:13 -0400
In-Reply-To: <20090722170152.GN4231@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On Jul 21, 2009  19:57 -0500, Eric Sandeen wrote:
>> Ron Johnson wrote:
>>> On 2009-07-20 21:03, Theodore Tso wrote:
>>>> On Mon, Jul 20, 2009 at 04:49:04PM -0500, Ron Johnson wrote:
>>>>> Hi,
>>>>>
>>>>> (Is this OT?  http://sourceforge.net/forum/forum.php?forum_id=7052  
>>>>> doesn't show much activity...)
>>>>>
>>>>> Debian Sid, e2fsprogs 1.41.8-1
>>>>> Home-rolled 64-bit 2.6.30 with 32-bit userland
>>>> Should be fixed in e2fsprogs 1.41.8-2
>>> ff seems to work now, but I still get this in dmesg:
>>>
>>> [188883.274547] ioctl32(filefrag:7086): Unknown cmd fd(3) 
>>> cmd(c020660b){t:'f';sz:32} arg(ffacb808) on /some/large/file
>> Huh, did we miss a compat ioctl for fiemap.... looks like so.  I'll look
>> into that tomorrow, thanks.
> 
> Sigh, I wish there was some sort of automatic ioctl parser tool that
> would report if the ioctl will need compat handling or not.  I thought
> the fiemap structs didn't need any compat handling because they are
> properly sized/aligned and w/o pointers...

They are properly sized yep but I think they still have to be flagged:

/* pointer to compatible structure or no argument */
#define COMPATIBLE_IOCTL(cmd) \
        { (cmd), do_ioctl32_pointer },

I have to remind myself how this all works, despite doing a bunch of
ioctl32 work for xfs last year :)

I think adding COMPATIBLE_IOCTL(FS_IOC_FIEMAP); to fs/compat_ioctl.c
should be enough, I'll try to get it tested tomorrow.

-Eric

-Eric
