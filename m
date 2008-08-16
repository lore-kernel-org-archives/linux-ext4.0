From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH 0/6 ]Ext4 journal credits reservation fixes
Date: Fri, 15 Aug 2008 17:34:33 -0700
Message-ID: <1218846873.8183.40.camel@mingming-laptop>
References: <48841077.500@cse.unsw.edu.au> <20080721082010.GC8788@skywalker>
	 <1216774311.6505.4.camel@mingming-laptop>
	 <20080723074226.GA15091@skywalker>
	 <1217032947.6394.2.camel@mingming-laptop>
	 <1218558190.6766.37.camel@mingming-laptop>
	 <20080815173321.GC6511@skywalker>
	 <1218826975.8183.28.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger@sun.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:51548 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbYHPAeh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 Aug 2008 20:34:37 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7G0YZjC017590
	for <linux-ext4@vger.kernel.org>; Fri, 15 Aug 2008 20:34:35 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7G0YZFB235276
	for <linux-ext4@vger.kernel.org>; Fri, 15 Aug 2008 20:34:35 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7G0YYKZ030069
	for <linux-ext4@vger.kernel.org>; Fri, 15 Aug 2008 20:34:34 -0400
In-Reply-To: <1218826975.8183.28.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-08-15=E4=BA=94=E7=9A=84 12:02 -0700=EF=BC=8CMingming Cao=
=E5=86=99=E9=81=93=EF=BC=9A
> =E5=9C=A8 2008-08-15=E4=BA=94=E7=9A=84 23:03 +0530=EF=BC=8CAneesh Kum=
ar K.V=E5=86=99=E9=81=93=EF=BC=9A
> > On Tue, Aug 12, 2008 at 09:23:10AM -0700, Mingming Cao wrote:
> > > This is a rework of journal credits fix patch in the ext4 patch q=
ueue.
> > > The patch series contains
> > >=20
> > > - patch 1: helper funtions for journal credits calculation and fi=
x the
> > > writepage/write_begin on nonextent files
> > > - patch 2: journal credit fix wirtepahe/write_begin for extents f=
iles,
> > > and migration
> > > - patch 3: credit fix for dio, fallocate
> > > -patch 4: rebase ext4_da_writepages_rework patch
> > > - patch 5: credit fix for delalloc writepages
> > > -patch 6: credit fix for defrag
> > >=20
> > >=20
> >=20
> > I see this patch is pushed to the patch queue. Below is the review =
in
> > patch form.
> >=20

I have updated the patches, mostly:

1) Remove unnecessary journalled mode handling =20
2) More common code sharing, less code than before
3) Updated da_writepages credits calculation

 will reply to each individual patch.

Thanks,
Mingming

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
