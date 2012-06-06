From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4 corruption during unexpected power cycle in the middle of
 writing
Date: Wed, 06 Jun 2012 00:31:34 -0500
Message-ID: <4FCEEB36.9010102@redhat.com>
References: <2CE44BD3DBCF9541909CCB42F11CA392825CBF@SFO1EXC-MBXP06.nbttech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Ming Lei <Ming.Lei@riverbed.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9426 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885Ab2FFFbg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Jun 2012 01:31:36 -0400
In-Reply-To: <2CE44BD3DBCF9541909CCB42F11CA392825CBF@SFO1EXC-MBXP06.nbttech.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 6/6/12 12:24 AM, Ming Lei wrote:
> I ran the power cycle test during the middle of file writing and after bootup, I ran force fsck and found two errors (If I run fsck -p -v I don't see the errors). From what I saw I think it is file system meta data corruption. Fsck can repair it but each time I ran the same test and I hit the same issue. 
> 
> I don't think it is relevant but want to point out that sda6 shares the same drive as another partition on sda(sda3) is used for the raid6 array for /var.
> 
> The same issue was found whenever barrier is on or off, and the disk drive write cache is enabled or disabled. The test result shown below is when barrier is on and disk write cache is disabled. 
> 
> I use kernel version 2.6.32SL6 version. I also see the same issue on 2.6.9 based kernel on the same hardware with ext3 file system.
> 
> My question is:
> 1) Is the issue caused from something unique in my box? Configuration error?
> 2) Is it possible my version of fsck reported false errors?

Sort of.  You got:

> Free blocks count wrong (118366120, counted=76269471).
> Fix? yes
> 
> Free inodes count wrong (30081013, counted=30081004).
> Fix? yes

Those are the superblock counters, which aren't journaled - only the bg counters are logged via the journal, IIRC.

They aren't false... they are just expected due to the design I'm afraid.

If you had mounted/unmounted/fsck'd you wouldn't have seen errors, because at mount time the superblock gets updated from all of the individual bg counters in ext4_fill_super:

        /*
         * The journal may have updated the bg summary counts, so we
         * need to update the global counters.
         */

> 3) Is this a known issue? ? Is it a kernel bug?

yes.  Not really.  ;)

> 4) How do I find what's wrong?

I think this is by design, though maybe a little unfortunate in that it is unexpected to get fsck errors on a journaling filesystem after a crash...

I ran into this same thing when doing recovery testing for > 16T filesystems.

-Eric

