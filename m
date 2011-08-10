From: Florian Weimer <fweimer@bfk.de>
Subject: Re: Feature request: e2fsck -z
Date: Wed, 10 Aug 2011 11:04:42 +0000
Message-ID: <82fwl9a5o5.fsf@mid.bfk.de>
References: <4E4173D4.9010104@zytor.com> <4E422686.8080207@gmail.com>
	<4420E0D8-5E16-4FD0-A7A9-B462F02D742D@dilger.ca>
	<4E423FD0.40108@gmail.com>
	<alpine.LFD.2.00.1108101134580.4380@dhcp-27-109.brq.redhat.com>
	<82k4ala62o.fsf@mid.bfk.de>
	<alpine.LFD.2.00.1108101259330.4380@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ric Wheeler <ricwheeler@gmail.com>,
	Andreas Dilger <adilger@whamcloud.com>,
	"H. Peter Anvin" <hpa@zytor.com>, linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx01.bfk.de ([193.227.124.2]:56085 "EHLO mx01.bfk.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752730Ab1HJLEr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Aug 2011 07:04:47 -0400
In-Reply-To: <alpine.LFD.2.00.1108101259330.4380@dhcp-27-109.brq.redhat.com>
	(Lukas Czerner's message of "Wed, 10 Aug 2011 13:01:10 +0200 (CEST)")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Lukas Czerner:

> On Wed, 10 Aug 2011, Florian Weimer wrote:
>
>> * Lukas Czerner:
>>=20
>> > You're right. It is a part of e2fsck and you can enable it with -E
>> > discard.
>>=20
>> If the block device does not support TRIM, does this result in zeros
>> being written instead?

> Of course not, discard works only on devices which does support it. I=
f
> the device does not support discard it will to nothing.

Oh, then it doesn't address hpa's use case (improving compression).

--=20
=46lorian Weimer                <fweimer@bfk.de>
BFK edv-consulting GmbH       http://www.bfk.de/
Kriegsstra=DFe 100              tel: +49-721-96201-1
D-76133 Karlsruhe             fax: +49-721-96201-99
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
