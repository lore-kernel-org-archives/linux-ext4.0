From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Fwd: Need help with Data Recovery on Ext4 partitions that became
 corrupted on running OS
Date: Wed, 25 Sep 2013 11:50:42 -0500
Message-ID: <52431462.1090906@redhat.com>
References: <CAOWv6b1Jq0MAtELB_brhg_G3S2svEW8EaW9A8ciddTUdqDWFdQ@mail.gmail.com> <CAOWv6b1m8A2S3sjDsJxOrRVztch6iq4zH9eFq5DKFMqtWWWpEw@mail.gmail.com> <CAOWv6b3+rzK4a6Oc29R2gNTv-mX+9QvnsuE0O3dCL8F8-PfjTQ@mail.gmail.com> <524302D5.10701@redhat.com> <CAOWv6b0Pr5JdLc9JCQFA3AyLwa_GGPrJa71oK0St8Ci2NA+uNA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: InvTraySts <invtrasys@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40297 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797Ab3IYQuq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Sep 2013 12:50:46 -0400
In-Reply-To: <CAOWv6b0Pr5JdLc9JCQFA3AyLwa_GGPrJa71oK0St8Ci2NA+uNA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 9/25/13 11:35 AM, InvTraySts wrote:
> Not used to mailing list courtesy so forgive how gmail responds to these...
> 
> I didn't have any kind of error on the RAID controller itself. When I
> went back for one of the weekends, I went into the RAID controller
> BIOS and everything was reported as normal. Of the four logical drives
> experiencing problems, only two of them were on the controller, one
> was plugged into the motherboard, the last one was plugged into an
> add-on SATA card.
> 
> I don't know what happened on the 24th of August, all I know is that
> it was working fine the previous night, tried to get on the network,
> and everything had stopped working (web server, DHCP, bind, samba,
> etc). Went down to inspect the machine and noticed that it was running
> but there was nothing showing up the monitor when plugging it in. So I
> am not sure of the exact events of how it failed, I just know that
> after hardware testing, the processor was dead.

Ok, so pretty extreme hardware failure.

> I have tried using dd and ddrescue using the following commands:
>  dd if=/dev/sdc of=/dev/sdf bs=4096 conv=notrunc,noerror,sync
>  ddrescue -vf /dev/sdh /dev/sdf /home/andrew/logfile.txt

(you said the copy was worse; what was wrong with it?)
(did the dd or ddrescue encounter any errors while doing the copy?)

dd should have worked fine, and you should be able to play with that
image.  First thing I'd try, if it still throws the bad journal
error first, is to tune2fs -O ^has_journal /dev/sdf

Then try to mount and /or run e2fsck on it, see how it fares.
The journal is just the first thing mount's going to look at;
if the corruption is widespread you may just have a cascade of other
errors behind it, but worth a shot.

-Eric

