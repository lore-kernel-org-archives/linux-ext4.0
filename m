From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: resize4fs: File too large while trying to determine filesystem
 size
Date: Thu, 05 May 2011 15:14:30 -0500
Message-ID: <4DC30526.8000809@redhat.com>
References: <4DC2FF1D.6040903@slac.stanford.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Ling Ho <ling@slac.stanford.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18846 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297Ab1EEUOi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 May 2011 16:14:38 -0400
In-Reply-To: <4DC2FF1D.6040903@slac.stanford.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/5/11 2:48 PM, Ling Ho wrote:
> Hi,
> 
> I am trying to resize a ext4 filesystem. I am using e4fsprogs
> 1.41.12.
> 
> My device is actually 17TB. I can live with just using 16TB of it if
> that's what's supported. But when I tried to increase the size by
> specifying the size, I get this error:
> 
> # resize4fs /dev/sdb 16000G resize4fs 1.41.12 (17-May-2010) 
> resize4fs: File too large while trying to determine filesystem size #
> resize4fs /dev/sdb 15000G resize4fs 1.41.12 (17-May-2010) resize4fs:
> File too large while trying to determine filesystem size

resize4fs indicates that you are on a Red Hat Enterprise Linux 5 system,
so this may go better through your Red Hat support contacts.

I have some open bugs similar to

Bug 654093 - [6.0]The resize2fs command fails to run on a 16TiB filesystem.

which was fixed in RHEL6.1.

> 
> I also tried 16T and 15T, and get the same thing.

Well, the issue is that the device itself is more than 16T, and the e2fsprogs
tools won't even touch it; e2fsprogs has never released more than 32-bit
support.  I would recommend resizing your device to something small enough
for e2fsprogs to handle.

Thanks,
-Eric

> # cat /proc/partitions
> major minor  #blocks  name
> 
>    8     0  243163136 sda
>    8     1   16779861 sda1
>    8     2    6289447 sda2
>    8     3    6289447 sda3
>    8     4          0 sda4
>    8     5    4192933 sda5
>    8     6    4192933 sda6
>    8     7    4192933 sda7
>    8     8  201222126 sda8
>    8    16 17560535040 sdb 
> 
> # df
> Filesystem           1K-blocks      Used Available Use% Mounted on
> /dev/sda1             16253924   9484080   5930852  62% /
> /dev/sda8            194917600  66106672 118749824  36% /u1
> /dev/sda6              4061540     83700   3768196   3% /tmp
> /dev/sda3              6092388    221168   5556748   4% /opt
> /dev/sda2              6092388   4701480   1076436  82% /var
> /dev/sda5              4061540     73800   3778096   2% /var/tmp
> tmpfs                 16481060         0  16481060   0% /dev/shm
> /dev/sdb             2880829872 1505086604 1229405476  56% /u2

> 
> Can someone suggest I am doing wrong?
> 
> Thanks, ... ling -- To unsubscribe from this list: send the line
> "unsubscribe linux-ext4" in the body of a message to
> majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html

