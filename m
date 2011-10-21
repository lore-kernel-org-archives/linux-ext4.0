From: Matt Parnell <mparnell@gmail.com>
Subject: Re: Bug In ext4 in kernels > 2.6.39 - Not mounting with arguments/options
 I specify in fstab on root remount
Date: Thu, 20 Oct 2011 22:29:49 -0500
Message-ID: <4EA0E72D.8020305@gmail.com>
References: <4E6F1B49.3010803@gmail.com> <CABeR262=5V1wuXPDVr_qLTeFTc4zDSFKVYKvO_+1w60XmwJvKA@mail.gmail.com> <4E6F6D89.5040905@redhat.com> <CABeR260PEDEF1cyX5JPs3VC0hpThmKNtDAhDd-sPDZ2grtL+=g@mail.gmail.com> <20111009234433.GU7948@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63013 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab1JUD3M (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Oct 2011 23:29:12 -0400
Received: by iaek3 with SMTP id k3so4187653iae.19
        for <linux-ext4@vger.kernel.org>; Thu, 20 Oct 2011 20:29:11 -0700 (PDT)
In-Reply-To: <20111009234433.GU7948@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The output of /proc/cmdline on 3.0.7:

BOOT_IMAGE=/boot/vmlinuz26-zen root=/dev/sdb1 ro rootfstype=ext4 
rootflags=data=writeback noatime nodiratime barrier=0 discard noinitrd


On 10/09/2011 06:44 PM, Ted Ts'o wrote:
> On Sun, Oct 09, 2011 at 05:10:54PM -0500, Matt Parnell wrote:
>> /proc/mounts (as you can see it's not being remounted rw for some
>> reason - /dev/sdc1 is the flash drive I used to pipe this info onto):
>>
>> rootfs / rootfs rw 0 0
>> /dev/root / ext4 ro,relatime,barrier=1 0 0
> Can you send me the output of /proc/cmdline?  It looks like the
> rootflags command line option isn't getting passed to the kernel for
> some reason.  That would explain why data=writeback isn't showing up
> in /proc/mounts.
>
> 						- Ted
