From: Matt LaPlante <cybrmatt@gmail.com>
Subject: Re: Mounting Ext3 with Ext4
Date: Wed, 20 May 2009 21:28:30 -0400
Message-ID: <baab8ccb0905201828i7ad6536ele72157b3e2d223c1@mail.gmail.com>
References: <baab8ccb0905201624j56767f59mff537ab8767ffc8d@mail.gmail.com>
	 <4A14ABAC.7040901@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:63229 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524AbZEUB2a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 May 2009 21:28:30 -0400
Received: by ewy24 with SMTP id 24so933987ewy.37
        for <linux-ext4@vger.kernel.org>; Wed, 20 May 2009 18:28:30 -0700 (PDT)
In-Reply-To: <4A14ABAC.7040901@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 20, 2009 at 9:17 PM, Eric Sandeen <sandeen@redhat.com> wrot=
e:
> Matt LaPlante wrote:
>> According to the Ext4 howto
>> (http://ext4.wiki.kernel.org/index.php/Ext4_Howto#Converting_an_ext3=
_filesystem_to_ext4),
>> "It is possible to mount both ext3 (and ext2, in kernels 2.6.28 and
>> later) filesystems directly using the ext4 filesystem driver." =A0So
>> this means, if I'm reading it correctly, that a kernel built with ex=
t4
>> support should be able to mount and manage ext[234] filesystems. =A0=
Is
>> that correct? =A0If so, are there any limitations on this support?
>>
>> I'm running Ubuntu Jaunty with some custom-built 2.6.29.4 kernels an=
d
>> grub2. =A0I seem to have no problem booting from ext4 disks, so the =
ext4
>> support is definitely there and functioning. =A0I had hoped the ext3
>> support meant I could build the kernel with ext4 only and carry on a=
s
>> usual with my ext3 partitions. =A0Unfortunately doing so causes the =
ext3
>> partitions to fail to boot. =A0So...
>>
>> booting ext3 with ext3 in the kernel=3Dfine
>> booting ext4 with ext4 in the kernel=3Dfine
>> booting ext3 with ext4 (only) in the kernel=3Dnot fine
>>
>> Is this a problem or was it never intended to work?
>
> It should work...
>
> It'd be more helpful if you could include details on exactly how it
> failed, but if Ubuntu builds ext4 as a module, perhaps the initrd
> creation sees root as ext3 and doesn't bother to put ext4 in the init=
rd?

ext4 was compiled in directly, it was not a module (this wasn't an
ubuntu kernel; it was stock).  I can try to get a stack trace with
netconsole if it gets far enough to function.

>
> -Eric
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
