From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: OOPs in ext4
Date: Wed, 21 May 2014 16:33:57 +0200
Message-ID: <CAOkSjBiAtP0pc5nckV_Opd1+kxaxFBxT=4tYgUGMo+gkAz5_EQ@mail.gmail.com>
References: <CAOkSjBgTFq_LnYnctOj2zR_to47joQDDbft3-kjEGzd2=ooswg@mail.gmail.com>
 <alpine.LFD.2.00.1405211506190.2114@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: =?UTF-8?B?THVrw6HFoSBDemVybmVy?= <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:57000 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbaEUOeT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 May 2014 10:34:19 -0400
Received: by mail-lb0-f172.google.com with SMTP id l4so1651154lbv.17
        for <linux-ext4@vger.kernel.org>; Wed, 21 May 2014 07:34:17 -0700 (PDT)
In-Reply-To: <alpine.LFD.2.00.1405211506190.2114@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 21 May 2014 15:20, Luk=C3=A1=C5=A1 Czerner <lczerner@redhat.com> wro=
te:
> On Wed, 21 May 2014, Arturo Borrero Gonzalez wrote:
>
>> Date: Wed, 21 May 2014 12:29:04 +0200
>> From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
>> To: linux-ext4@vger.kernel.org
>> Subject: OOPs in ext4
>>
>> Hi there!
>>
>> I have an oops in a virtual machine using ext4 as fs.
>
> Hi,
>
> yes there is definitely a bug in the error handling code because we
> really should not hit that BUG_ON() later.
>
> However I am curious how we got this state in the first place. Can
> you provide the logs before the first oops ? Are there any more
> warnings ?
>

Unfortunately, given the fs was remounted ro, no logs were written.
I took the error from dmesg.

> What is your storage setup ? Any particular workload you've been
> running at the time ? Can you reproduce it ?
>

I have a machine with a plain libvirt/kvm with LVM for virtualization.
I create a couple of LVM volumes for each virtual machine.

Each virtual machine is then installed to the LVM volume, using ext4
and using the volume as a plain disc (no nested LVM, etc..)
Specifically, I use this virtual machine to develop (netfilter,
kernel). Is a Debian Wheezy system.

So, what happened was:
 * ssh to the virtual machine.
 * cd to the devel dir
 * stg pop a couple of patches.
 * git pull the latest nftables kernel tree.
 * run `make -j8 deb-pkg'
 * the build failed due to fs remounted RO.
 * reboot.

The kernel image I was running is this:
http://git.kernel.org/cgit/linux/kernel/git/pablo/nftables.git/ I see
now that it seem to be based upon 3.10, not 3.14 as originally I
stated.

regards
--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
