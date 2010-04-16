From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: e2fsck doesn't repair broken ext4
Date: Fri, 16 Apr 2010 10:22:30 -0500
Message-ID: <4BC880B6.9090207@redhat.com>
References: <20100312205435.GG32664@alea.gnuu.de> <20100416101156.GB1556@alea.gnuu.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	linux-ext4@vger.kernel.org
To: =?ISO-8859-1?Q?J=F6rg_Sommer?= <joerg@alea.gnuu.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15747 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752338Ab0DPPWh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Apr 2010 11:22:37 -0400
In-Reply-To: <20100416101156.GB1556@alea.gnuu.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04/16/2010 05:11 AM, J=F6rg Sommer wrote:
> Hi,
>=20
> J=F6rg Sommer hat am Fri 12. Mar, 21:54 (+0100) geschrieben:
>> after a system crash, I had a problem with ext4 that e2fsck didn't f=
ix. I
>> don't know if e2fsck or ext4 was wrong. In the end, I had to remove =
the
>> broken directory, which succeed and solved my problem.
>>
>> These are the steps I did:
>>
>> 01 % e2fsck -fy /dev/root
>> 02 % dumpe2fsck -x /dev/root
>> 03 % e2image -r /dev/root
>> 04 % apt-get install
>> 05 % dmesg
>> 06 % dumpe2fs -x /dev/root
>> 07 % e2image -r /dev/root
>> 08 % e2fsck -y /dev/root
>> 09 % dumpe2fs -x /dev/root
>> 10 % e2image -r /dev/root
>> 11 % apt-get install
>> 12 % dmesg
>>
>> I've put the output and images of all these commands at
>> <http://alioth.debian.org/~jo-guest/ext4/>. I hope they help you som=
ehow.
>=20
> I would like to ask, if there was any result from this issue? Did you
> found a bug in e2fsck?

I'm sorry, I haven't made further progress on this yet.

-Eric

> Bye, J=F6rg.

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
