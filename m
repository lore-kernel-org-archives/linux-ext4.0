From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: tune2fs -o noatime /dev/sd_
Date: Fri, 19 Dec 2008 09:19:50 -0600
Message-ID: <494BBB96.5080207@redhat.com>
References: <20081217121533.30951131.taeuber@bbaw.de> <20081219110114.aedf7b29.taeuber@bbaw.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: =?UTF-8?B?TGFycyBUw6R1YmVy?= <taeuber@bbaw.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:38199 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046AbYLSPUF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Dec 2008 10:20:05 -0500
In-Reply-To: <20081219110114.aedf7b29.taeuber@bbaw.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Lars T=C3=A4uber wrote:
> Sorry for the noise.
> Might have been a silly idea.

It's not silly, I can see where this might be very useful; but noatime
is applied at the vfs level and not at the filesystem level, so putting
the flag in the filesystem superblock on disk and propagating that back
up to the vfs at mount time might require a bit of trickiness to get
right & do cleanly, I'm not sure.  I'll give it some thought.

It may be simpler & quicker to just tell your auto-mount framework to
mount certain devices, or labels, or uuids, or $WHATEVER with noatime i=
f
you can?  Of course that configuration is local to a single machine, an=
d
doesn't travel with the drive...

-Eric

> Happy Christmas to you.
> Lars
>=20
> Lars T=C3=A4uber <taeuber@bbaw.de> schrieb:
>> Hallo developers!
>>
>> I just would like to ask for a feature request for the ext[234] file=
systems.
>> There are some usb-sticks used by me that are formated with ext2. Al=
l recent desktop enviroments let me mount them quiet easy but without t=
he chance to tell them to mount it with the =C2=BBnoatime=C2=AB option.=
 But I liked them to be mounted with this option because of their flash=
 characteristics.
>> It seems there is some space left for an EXT4_MOUNT_NOATIME option i=
n ext4.h for all the ext[234] file systems.
>> What do you think about this?
>>
>> Thanks
>> Lars

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
