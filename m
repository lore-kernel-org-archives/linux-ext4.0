From: =?UTF-8?B?Q3Jpc3RpYW4gUm9kcsOtZ3Vleg==?= <crrodriguez@opensuse.org>
Subject: Re: [opensuse-factory] /sbin/fstrim: /home: FITRIM ioctl failed:
 Operation not supported
Date: Wed, 23 Feb 2011 16:12:06 -0300
Message-ID: <4D655C06.2080704@opensuse.org>
References: <4D644245.9000809@opensuse.org> <AANLkTi=sMAam8sa-QUxZKzeCev2JWqhc+HnhwC33wgUy@mail.gmail.com> <alpine.LFD.2.00.1102231119580.2934@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Greg Freemyer <greg.freemyer@gmail.com>,
	opensuse-factory <opensuse-factory@opensuse.org>,
	ext4 <linux-ext4@vger.kernel.org>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:39220 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932408Ab1BWTLE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Feb 2011 14:11:04 -0500
Received: by pxi15 with SMTP id 15so470349pxi.19
        for <linux-ext4@vger.kernel.org>; Wed, 23 Feb 2011 11:11:02 -0800 (PST)
In-Reply-To: <alpine.LFD.2.00.1102231119580.2934@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

El 23/02/11 07:28, Lukas Czerner escribi=C3=B3:
> On Tue, 22 Feb 2011, Greg Freemyer wrote:
>=20
>> On Tue, Feb 22, 2011 at 6:09 PM, Cristian Rodr=C3=ADguez
>> <crrodriguez@opensuse.org> wrote:
>>>  Hi:
>>>
>>>  I get the error message in $Subject if I try to use /sbin/fstrim o=
n all
>>>  my filesystems BUT /boot which is the only one which is not encryp=
ted.
>>>
>>>  How am I supposed to "trim" dm-crypt/LUKS volumes on an SSD device=
 ?
>>>
>>> Thanks.

Lukas, thanks for your answer.

> No NO NO! Big no to trimming encrypted filesystems! When you are
> discarding blocks, the subsequent read from those blocks are usually =
"well
> defined" and hence you are giving away useful information for attacke=
r
> trying to decrypt your filesystem.=20

I understand that there might be security issues, but so far, for this
scenario the only kind of attacker from which I need to protect my
desktop is from low-funded regular thieves that may break into my home
office, unlikely that will get pass the volume password prompt ;-)


> Now, there might be some way around this to allow trimming encrypted
> volumes without serious security issue, but this is rather question f=
or
> dm-crypt guys.

Maybe making work the "discard" mount option ?
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
