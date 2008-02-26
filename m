From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC] ext3 freeze feature ver 0.2
Date: Tue, 26 Feb 2008 09:08:07 -0800
Message-ID: <20080226170807.GE3172@webber.adilger.int>
References: <20080219202706t-sato@mail.jp.nec.com>
 <20080226172014t-sato@mail.jp.nec.com> <47C440A6.6080202@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Takashi Sato <t-sato@yk.jp.nec.com>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:45921 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762994AbYBZRIT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Feb 2008 12:08:19 -0500
In-reply-to: <47C440A6.6080202@redhat.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Feb 26, 2008  08:39 -0800, Eric Sandeen wrote:
> Takashi Sato wrote:
>=20
> > o Elevate XFS ioctl numbers (XFS_IOC_FREEZE and XFS_IOC_THAW) to th=
e VFS
> >   As Andreas Dilger and Christoph Hellwig advised me, I have elevat=
ed
> >   them to include/linux/fs.h as below.
> >     #define FIFREEZE        _IOWR('X', 119, int)
> > =E3=80=80  #define FITHAW          _IOWR('X', 120, int)
> >   The ioctl numbers used by XFS applications don't need to be chang=
ed.
> >   But my following ioctl for the freeze needs the parameter
> >   as the timeout period.  So if XFS applications don't want the tim=
eout
> >   feature as the current implementation, the parameter needs to be
> >   changed 1 (level?) into 0.
>=20
> So, existing xfs applications calling the xfs ioctl now will behave
> differently, right?  We can only keep the same ioctl number if the
> calling semantics are the same.  Keeping the same number but changing
> the semantics is harmful, IMHO....

Do we know what this parameter was supposed to mean?

We could special case "1" if needed to keep compatibility (documenting
this clearly), either making it =3D=3D 0, or some very long timeout (1h
or whatever).  A relatively minor wart I think.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
