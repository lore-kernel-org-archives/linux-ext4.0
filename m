From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Questions on ext4 and writeback
Date: Thu, 20 Aug 2009 12:35:35 +0530
Message-ID: <20090820070535.GA26492@skywalker.linux.vnet.ibm.com>
References: <6601abe90908130909v582df37aq773e95f49f4a1248@mail.gmail.com> <20090818163909.GD28560@mit.edu> <6601abe90908180957u6ebe424q878229d2df9ffa94@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:50942 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495AbZHTHFq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Aug 2009 03:05:46 -0400
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.31.243])
	by e23smtp08.au.ibm.com (8.14.3/8.13.1) with ESMTP id n7K72V9E018108
	for <linux-ext4@vger.kernel.org>; Thu, 20 Aug 2009 17:02:31 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n7K75lLB409778
	for <linux-ext4@vger.kernel.org>; Thu, 20 Aug 2009 17:05:47 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n7K75kVQ032706
	for <linux-ext4@vger.kernel.org>; Thu, 20 Aug 2009 17:05:47 +1000
Content-Disposition: inline
In-Reply-To: <6601abe90908180957u6ebe424q878229d2df9ffa94@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 18, 2009 at 09:57:49AM -0700, Curt Wohlgemuth wrote:
> Hi Ted:
>=20
> On Tue, Aug 18, 2009 at 9:39 AM, Theodore Tso<tytso@mit.edu> wrote:
> > On Thu, Aug 13, 2009 at 09:09:58AM -0700, Curt Wohlgemuth wrote:
> >> But the actual submittal of I/O for the previous extent might caus=
e
> >> pages_skipped to be bumped, right? =A0Removing these increments mi=
ght cause
> >> the accounting to be incorrect, it seems to me.
> >
> > I don't see where the submission of an extent of pages for I/O woul=
d
> > cause page_skipped to be incremented or changed --- am I missing
> > something?
>=20
> Probably not.  But it seems to me that a call order of
>=20
>   write_cache_pages -> __mpage_da_writepage -> mpage_da_submit_io ->
> ext4_writepage
>=20
> can cause pages_skipped to be incremented, either directly in
> ext4_writepage() (page has delayed/unwritted buffers) or in
> __block_write_full_page() (buffer already locked).
>=20
> In fact, in mpage_da_submit_io(), pages_written is only incremented i=
f
> pages_skipped hasn't been bumped -- so that routine already knows tha=
t
> pages_skipped might be changed on I/O submit.
>=20
> If this happens, ext4_da_writepages() will wipe out the fact that
> pages_skipped was changed during submittal, won't it?
>=20

In that case we would have set MPAGE_DA_EXTENT_TAIL and we loop again
in the writepages, trying to write again from the beginning and writing=
 the
earlier skipped pages.

In otherwords we retry in writepages untill we are able to write all th=
e
nr_to_write pages.

-aneesh
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
