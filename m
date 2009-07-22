From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ioctl32 (was Re: filefrag abort)
Date: Tue, 21 Jul 2009 19:57:55 -0500
Message-ID: <4A666413.5030301@redhat.com>
References: <4A64E650.6020603@cox.net> <20090721020312.GL2416@mit.edu> <4A665E3F.7000109@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Ron Johnson <ron.l.johnson@cox.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:54374 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752977AbZGVA6T (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Jul 2009 20:58:19 -0400
In-Reply-To: <4A665E3F.7000109@cox.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ron Johnson wrote:
> On 2009-07-20 21:03, Theodore Tso wrote:
>> On Mon, Jul 20, 2009 at 04:49:04PM -0500, Ron Johnson wrote:
>>> Hi,
>>>
>>> (Is this OT?  http://sourceforge.net/forum/forum.php?forum_id=7052  
>>> doesn't show much activity...)
>>>
>>> Debian Sid, e2fsprogs 1.41.8-1
>>> Home-rolled 64-bit 2.6.30 with 32-bit userland
>> Should be fixed in e2fsprogs 1.41.8-2
> 
> ff seems to work now, but I still get this in dmesg:
> 
> [188883.274547] ioctl32(filefrag:7086): Unknown cmd fd(3) 
> cmd(c020660b){t:'f';sz:32} arg(ffacb808) on /some/large/file
> 

Huh, did we miss a compat ioctl for fiemap.... looks like so.  I'll look
into that tomorrow, thanks.

-Eric
