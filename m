From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: 2.6.35-r5 ext3 corruptions
Date: Wed, 21 Jul 2010 09:01:49 -0500
Message-ID: <4C46FDCD.9010007@redhat.com>
References: <20100715105745.GI30737@dastard>	<20100719224512.GD32635@dastard>	<20100721063222.GW32635@dastard> <20100721140758.68ca16ab@debian>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53023 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755624Ab0GUOCA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Jul 2010 10:02:00 -0400
In-Reply-To: <20100721140758.68ca16ab@debian>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

T=F6r=F6k Edwin wrote:
> On Wed, 21 Jul 2010 16:32:22 +1000
> Dave Chinner <david@fromorbit.com> wrote:

=2E..

>> Quite frankly, data=3Dwriteback mode for ext3 is a dangerous,
>> dangerous configuration to run by default. IMO, it shouldn't be the
>> default. Patch below.
>=20
> Hi,
>=20
> I don't see CONFIG_EXT3_DEFAULTS_TO_ORDERED in my .config at all.
> What I have in my .config is:
> CONFIG_EXT4_FS=3Dy
> CONFIG_EXT4_USE_FOR_EXT23=3Dy
> CONFIG_EXT4_FS_XATTR=3Dy
>=20
> So what is the equivalent of that config option for ext4 used as ext3
> driver?

There is none AFAICT, just an artifact of the twisting option-paths of
extN, I guess.  :)

Good news is you should get something sane, and -not- default to writeb=
ack
with your config.

-Eric

> Best regards,
> --Edwin

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
