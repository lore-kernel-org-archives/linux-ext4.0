From: Matt Parnell <mparnell@gmail.com>
Subject: Re: Bug In ext4 in kernels > 2.6.39 - Not mounting with arguments/options
 I specify in fstab on root remount
Date: Thu, 20 Oct 2011 23:29:54 -0500
Message-ID: <4EA0F542.6060606@gmail.com>
References: <4E6F1B49.3010803@gmail.com> <CABeR262=5V1wuXPDVr_qLTeFTc4zDSFKVYKvO_+1w60XmwJvKA@mail.gmail.com> <4E6F6D89.5040905@redhat.com> <CABeR260PEDEF1cyX5JPs3VC0hpThmKNtDAhDd-sPDZ2grtL+=g@mail.gmail.com> <20111009234433.GU7948@thunk.org> <4EA0E72D.8020305@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57338 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792Ab1JUE3O (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Oct 2011 00:29:14 -0400
Received: by iaek3 with SMTP id k3so4234255iae.19
        for <linux-ext4@vger.kernel.org>; Thu, 20 Oct 2011 21:29:13 -0700 (PDT)
In-Reply-To: <4EA0E72D.8020305@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Also, note that the image is named vmlinuz26-zen there by mistake - I 
fixed that in my build script, but even so, it makes no difference. In 
3.0.7, I still can't remount root rw on ext4.

On 10/20/2011 10:29 PM, Matt Parnell wrote:
> The output of /proc/cmdline on 3.0.7:
>
> BOOT_IMAGE=/boot/vmlinuz26-zen root=/dev/sdb1 ro rootfstype=ext4 
> rootflags=data=writeback noatime nodiratime barrier=0 discard noinitrd
>
>
> On 10/09/2011 06:44 PM, Ted Ts'o wrote:
>> On Sun, Oct 09, 2011 at 05:10:54PM -0500, Matt Parnell wrote:
>>> /proc/mounts (as you can see it's not being remounted rw for some
>>> reason - /dev/sdc1 is the flash drive I used to pipe this info onto):
>>>
>>> rootfs / rootfs rw 0 0
>>> /dev/root / ext4 ro,relatime,barrier=1 0 0
>> Can you send me the output of /proc/cmdline?  It looks like the
>> rootflags command line option isn't getting passed to the kernel for
>> some reason.  That would explain why data=writeback isn't showing up
>> in /proc/mounts.
>>
>>                         - Ted
