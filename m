From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: Crash and stack trace for jbd2 under ext4
Date: Tue, 22 Jul 2008 17:49:48 -0700
Message-ID: <1216774188.6505.1.camel@mingming-laptop>
References: <48841077.500@cse.unsw.edu.au> <20080721082010.GC8788@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Shehjar Tikoo <shehjart@cse.unsw.edu.au>,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:40327 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752940AbYGWAtw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Jul 2008 20:49:52 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m6N0nnB4010905
	for <linux-ext4@vger.kernel.org>; Tue, 22 Jul 2008 20:49:49 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6N0nnPW220122
	for <linux-ext4@vger.kernel.org>; Tue, 22 Jul 2008 20:49:49 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6N0nnOX011315
	for <linux-ext4@vger.kernel.org>; Tue, 22 Jul 2008 20:49:49 -0400
In-Reply-To: <20080721082010.GC8788@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-07-21=E4=B8=80=E7=9A=84 13:50 +0530=EF=BC=8CAneesh Kumar=
 K.V=E5=86=99=E9=81=93=EF=BC=9A
> On Mon, Jul 21, 2008 at 02:28:39PM +1000, Shehjar Tikoo wrote:
> > Hi all
> >
> > Please see the contents of the file
> > for details of two similar crashes observed
> > on two different commits. Both crashes were
> > observed while using ext4 on the server while
> > accessing the export through NFSv3. The link
> > has more details.
> >
> > http://www.gelato.unsw.edu.au/~shehjart/docs/jbd_ext4_crash.txt
> >
>=20
> I guess we cannot use
> #define EXT4_MAX_WRITEBACK_CREDITS    DIO_CREDITS
>=20
> We do multiple block allocation in ext4_da_writepages and we can=20
> get these blocks from different block groups. So we may need to updat=
e
> bitmap of multiple groups.
>=20
> -aneesh

Yeah, the journal credit reservation for writepages() need a little
attention.  I will send a RFC patch shortly.

Mingming

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
