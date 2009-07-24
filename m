From: Andi Kleen <andi@firstfloor.org>
Subject: Re: ioctl32
Date: Fri, 24 Jul 2009 18:26:56 +0200
Message-ID: <87k51y11yn.fsf@basil.nowhere.org>
References: <4A64E650.6020603@cox.net> <20090721020312.GL2416@mit.edu>
	<4A665E3F.7000109@cox.net> <4A666413.5030301@redhat.com>
	<20090722170152.GN4231@webber.adilger.int>
	<4A67EC3B.9060503@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>,
	Ron Johnson <ron.l.johnson@cox.net>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:43025 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbZGXQ1A (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 24 Jul 2009 12:27:00 -0400
In-Reply-To: <4A67EC3B.9060503@redhat.com> (Eric Sandeen's message of "Wed, 22 Jul 2009 23:51:07 -0500")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen <sandeen@redhat.com> writes:
>
> /* pointer to compatible structure or no argument */
> #define COMPATIBLE_IOCTL(cmd) \
>         { (cmd), do_ioctl32_pointer },


The modern way to do this is to use the ->compat_ioctl VFS
method. COMPATIBLE_IOCTL etc are all obsolete.

> I think adding COMPATIBLE_IOCTL(FS_IOC_FIEMAP); to fs/compat_ioctl.c
> should be enough, I'll try to get it tested tomorrow.

Nope, add a ->compat_ioctl 

When your ioctl is already a unlocked_ioctl you can just use
the same function. If not convert to unlocked_ioctl first.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
