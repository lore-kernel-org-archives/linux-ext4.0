From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: Fast ext4 cleanup to avoid data loss after power failure
Date: Fri, 3 Oct 2014 16:08:59 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1410031550090.2333@localhost.localdomain>
References: <542EA00B.4040401@pqgruber.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org
To: Clemens Gruber <clemens.gruber@pqgruber.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752489AbaJCOJJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Oct 2014 10:09:09 -0400
In-Reply-To: <542EA00B.4040401@pqgruber.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 3 Oct 2014, Clemens Gruber wrote:

> Date: Fri, 03 Oct 2014 15:09:31 +0200
> From: Clemens Gruber <clemens.gruber@pqgruber.com>
> To: linux-ext4@vger.kernel.org
> Subject: Fast ext4 cleanup to avoid data loss after power failure
> 
> Hi,
> 
> I am using ext4 as root filesystem of my TQMa28-based board with 2GB eMMC.
> In case of a power failure I have to clean up the filesystem in 1.5 to 2
> seconds, that's how long the caps can sustain the power.

What exactly is the problem you're trying to solve ? Does it concern
specific application ?

> 
> I pass the following rootflags on the kernel cmdline: data=journal,commit=1
> In my user space application I open important files with O_SYNC.

So what you expect to happen if the power failure happens in the
middle of the write to the eMMC ?

> 
> Is there something else I can or should do to avoid data corruption?
> 
> I can detect when the power fails over a GPIO line, so I close open file
> descriptors in one important application but doing a "normal"
> poweroff/shutdown takes too long.

That will help a little bit, but it's not reliable at all. Again
what do you expect to happen when the goes off in the middle of the
write to the eMMC ?

> 
> What would you do if you had 1.5 seconds until the power is gone?

I'd avoid the need to deal with this at all. File system
(journal) itself will protect you from metadata corruption (file
system corruption). But the application has to protect it's own
important files for data consistency (data=journal will not help
you, nor commit=1).

The usual and simple way for the application to deal with this is to
use temporary file, fsync the changes to make sure that everything
hit the disk and then atomically rename the file to replace the
original. That way your file will always by in consistent state. It
will either have the new content, or the old one, not mix of both.

> 
> Maybe a read-only rootfs and a separate small data partition?

Well, if you do not need to write to the rootfs why you need to deal
with data corruption ?

Regards,
-Lukas

> 
> Thanks for your help.
> 
> Best regards,
> Clemens
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
