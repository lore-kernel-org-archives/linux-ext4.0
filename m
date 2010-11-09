From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: How can I do online resize from 14TB to 30TB?
Date: Tue, 9 Nov 2010 14:29:05 -0700
Message-ID: <A09A0FD5-97DA-494A-B248-CFBC1AF7DBE4@dilger.ca>
References: <855286.34705.qm@web74212.mail.tp2.yahoo.com>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=big5
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: =?utf-8?B?5a+s?= <l021220a@yahoo.com.tw>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:27738 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab0KIV3I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Nov 2010 16:29:08 -0500
In-Reply-To: <855286.34705.qm@web74212.mail.tp2.yahoo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-11-09, at 03:06, =BCe wrote:
> I saw the mail "E2fsprogs master branch now has all 64-bit patch appl=
ied" written by Ted.  Ext4 with 64bit couldn't do online resize which i=
s larger than 16TB, because "meta_bg" in kernel is not ready.
>=20
> However, it really took lots of time to do off-line resizing.  Could =
I do online resize without meta_bg?  Or what can I do for e2fsprogs to =
support online resize for larger than 16TB?

=46or the current time there will be no support for resizing a filesyst=
em formatted < 16TB to one > 16TB.

Cheers, Andreas





--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
