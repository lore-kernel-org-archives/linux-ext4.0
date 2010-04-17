From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: ext4: (2.6.34-rc4): This should not happen!!  Data will be lost
Date: Sat, 17 Apr 2010 18:55:36 +0200
Message-ID: <201004171855.36874.bernd.schubert@fastmail.fm>
References: <20100416123526.GW21495@skl-net.de> <20100416163654.GD58339@plapa.qlogic.org> <20100416170707.GB25507@skl-net.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>,
	Eric Sandeen <sandeen@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Linux Driver <Linux-Driver@qlogic.com>,
	Thomas Helle <Helle@tuebingen.mpg.de>
To: Andre Noll <maan@systemlinux.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:48179 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751195Ab0DQQzk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 17 Apr 2010 12:55:40 -0400
In-Reply-To: <20100416170707.GB25507@skl-net.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Friday 16 April 2010, Andre Noll wrote:
> On 09:36, Andrew Vasquez wrote:
> > > > 	qla2xxx 0000:06:09.0: scsi(0:0:0): Abort command issued -- 1 f=
a6a73
> > > > 2002.
> > > >
> > > > I can't explain why the storage did not complete the request in=
 the
> > > > allotted time.
> > >
> > > Ah, that's valuable information, thanks. The underlying Infortren=
d
> > > Raid System is rather old but worked without any problems for sev=
eral
> > > years. We recently replaced its 400G disks by new 2T WD disks. Ma=
ybe
> > > the new disks have longer response times, could that be the reaso=
n? And
> > > is there a way to increase the timeout value?
> >
> > To update the default timeout value (30 seconds) for commands
> > submitted to /dev/sdn to 60 seconds:
> >
> >         $ echo 60 > /sys/block/sdn/device/timeout
>=20
> I will re-run the stress test with a 60 seconds timeout value and fol=
low
> up if this did not help.

That will not help if the command is "SYNCHRONIZE_CACHE", as that ignor=
es=20
device settings, but uses scsi default timeout (30s), which is far too =
small=20
for SATA based raid units. Scsi maintainers ignored that and a couple o=
f other=20
patches I wrote to improve error handling with Infortrend units. Will s=
end the=20
patches again soon.
Also, if the abort command succeeds, it the command should be re-queued=
 and=20
should not result in an error. I think my patches also would increase=20
verbosity to point out what exactly happened (possibly a wrong return c=
ode in=20
the qla2xxx driver, although that should activate the next step in erro=
r=20
handling, I need to find some to go through the code...).

Altogether filesystem unrelated. The filesystem just might be the reaso=
n for a=20
synchronize-cache, e.g. barriers, etc.

Greetings from T=FCbingen,
Bernd=20
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
