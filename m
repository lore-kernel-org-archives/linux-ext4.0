From: Dexuan Cui <decui@microsoft.com>
Subject: RE: Can one file system be R/W mounted multiple times in Linux?
Date: Sat, 10 Jan 2015 03:52:35 +0000
Message-ID: <F792CF86EFE20D4AB8064279AFBA51C61EA73ACF@SIXPRD3002MB028.064d.mgd.msft.net>
References: <F792CF86EFE20D4AB8064279AFBA51C61EA72765@SIXPRD3002MB028.064d.mgd.msft.net>
 <20150109035123.GG22149@ZenIV.linux.org.uk>
 <20150109120159.GA20300@stefanha-thinkpad.redhat.com>
 <alpine.LFD.2.00.1501091646400.24821@localhost.localdomain>
 <CA+aCy1Esm-2NGvJFG4_22rNaXiOqx1f2beCPpSCcovrXFf07+A@mail.gmail.com>
 <20150109203711.GJ22149@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?iso-8859-2?Q?Luk=E1=B9_Czerner?= <lczerner@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	"kzak@redhat.com" <kzak@redhat.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Al Viro <viro@ZenIV.linux.org.uk>,
	Pranay Srivastava <pranjas@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bl2on0129.outbound.protection.outlook.com ([65.55.169.129]:53184
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751785AbbAJEHS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Jan 2015 23:07:18 -0500
In-Reply-To: <20150109203711.GJ22149@ZenIV.linux.org.uk>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> -----Original Message-----
> From: Al Viro [mailto:viro@ftp.linux.org.uk] On Behalf Of Al Viro
> Sent: Saturday, January 10, 2015 4:37 AM
> To: Pranay Srivastava
> Cc: Luk=E1=B9 Czerner; Stefan Hajnoczi; kzak@redhat.com; Dexuan Cui; =
linux-
> fsdevel@vger.kernel.org; linux-ext4
> Subject: Re: Can one file system be R/W mounted multiple times in Lin=
ux?
>=20
> On Sat, Jan 10, 2015 at 01:01:19AM +0530, Pranay Srivastava wrote:
>=20
> > It's not the mount. If you see mount_bdev it checks for this and us=
es
> > the existing super block from the first mount
> > for all subsequent mounts of that block device.
> >
> > When block devices differ, as in with 2 loop devices they have
> > different bdev and that's why it doesn't work with 2
> > loop devices.
>=20
> What Lukas is suggesting is for mount(8) to spot an existing loop dev=
ice with
> the desired backing store and reuse it, rather than try and set the n=
ew one
> up.  That's where -o loop is handled - it's gone before mount(2) migh=
t see
> it.  The problem is in races...

Thank you all for the pretty informative discussion!

I think now I know when it's safe and when it's unsafe... :-)

Thanks,
-- Dexuan
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
