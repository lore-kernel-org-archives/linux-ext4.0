From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] Ext4: Fix delalloc enospace handling counter update
	race
Date: Mon, 14 Jul 2008 11:34:04 -0700
Message-ID: <1216060444.6468.15.camel@mingming-laptop>
References: <200807130626.m6D6QMvj007916@imap1.linux-foundation.org>
	 <20080714010828.GD7938@mit.edu> <1216052897.7937.1.camel@mingming-laptop>
	 <20080714165324.GA3545@skywalker>
	 <1216058076.6468.11.camel@mingming-laptop>  <20080714180505.GA8886@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:51554 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278AbYGNSeL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Jul 2008 14:34:11 -0400
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com [9.17.195.228])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m6EIY96I004958
	for <linux-ext4@vger.kernel.org>; Mon, 14 Jul 2008 14:34:09 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6EIY78x137954
	for <linux-ext4@vger.kernel.org>; Mon, 14 Jul 2008 12:34:08 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6EIY5Bu029203
	for <linux-ext4@vger.kernel.org>; Mon, 14 Jul 2008 12:34:06 -0600
In-Reply-To: <20080714180505.GA8886@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-07-14=E4=B8=80=E7=9A=84 14:05 -0400=EF=BC=8CTheodore Tso=
=E5=86=99=E9=81=93=EF=BC=9A
> On Mon, Jul 14, 2008 at 10:54:36AM -0700, Mingming Cao wrote:
> > Updated patch with only the first race fix,=20
> >=20
> > If no objection I will fold this to the parent patch
> > delalloc-ext4-ENOSPC-handling.patch in the patch queue.
>=20
> If you're going to fold this to the parent patch (which makes sense),
> the following grammatical correction won't be necessary, but here are
> some mostly verb tense fixups.
>=20

Thanks for going through the grammers and fixed the errors for me.

> Please feel free to add a
>=20
>        Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
>=20
> to the patch.
>=20

I added your Signed-off to the patch
delalloc-ext4-ENOSPC-handling.patch

Regrads,

Mingming
>      	       	   	       	   	      - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
