From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: calculate journal credits correctly
Date: Sun, 23 Nov 2008 20:02:58 +0530
Message-ID: <20081123143258.GA17002@skywalker>
References: <20081103033920.GC29102@mit.edu> <1226001075-16457-1-git-send-email-tytso@mit.edu> <1226534622.12488.25.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Aneesh Kumar <aneesh.kumar@gmail.com>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:59592 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758210AbYKWOdJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 23 Nov 2008 09:33:09 -0500
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp01.au.ibm.com (8.13.1/8.13.1) with ESMTP id mANEX7A8020456
	for <linux-ext4@vger.kernel.org>; Mon, 24 Nov 2008 01:33:07 +1100
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mANEX7oH263394
	for <linux-ext4@vger.kernel.org>; Mon, 24 Nov 2008 01:33:07 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mANEX60X029385
	for <linux-ext4@vger.kernel.org>; Mon, 24 Nov 2008 01:33:07 +1100
Content-Disposition: inline
In-Reply-To: <1226534622.12488.25.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 12, 2008 at 04:03:42PM -0800, Mingming Cao wrote:
>=20
> =E5=9C=A8 2008-11-06=E5=9B=9B=E7=9A=84 14:51 -0500=EF=BC=8CTheodore T=
s'o=E5=86=99=E9=81=93=EF=BC=9A
> > This fixes a 2.6.27 regression which was introduced in commit a0290=
8f1.
> >=20
> > We weren't passing the chunk parameter down to the two subections,
> > ext4_indirect_trans_blocks() and ext4_ext_index_trans_blocks(), wit=
h
> > the result that massively overestimate the amount of credits needed=
 by
> > ext4_da_writepages, especially in the non-extents case.  This cause=
s
> > failures especially on /boot partitions, which tend to be small and
> > non-extent using since GRUB doesn't handle extents.
> >=20
> > Thanks to Joseph Fannin for reporting this bug.
> >=20
> Thanks for fixing this up!

This was sent to my gmail.com  id so missed it before.
>=20
> However, looking at the code path, I wasn't sure if we got the delall=
oc
> credits right.  In ext4_da_writepages()->mpage_da_writepages(),  the
> credits is calculated based on the assumption that mpage_da_writepage=
s()
> doing* one* single chunk of contigugous allocation? So only one singl=
e
> extent credit is reserved (here you see the "chunk" flag passed from =
the
> ext4_da_writepages)
>=20
> __mpage_da_writepage() does do single chunk of block allocation at a
> time, but mpage_da_writepages()->write_cache_pages() will loop the pa=
ge
> vectors and probably will calling writepage->__mpage_da_writepage->
> mpage_da_map_blocks() multiple times?  Am I  missing anything?
>=20

mpage_da_writepages does block allocation for single chunk only.
ext4_da_writepages allocate credit needed for single chunk allocation.
write_cache_pages iterate through contiguous pages and build an in
memory extent. It then call get_blocks for 'x' blocks. After that
we map the blocks to the unmapped buffer_heads. Then we do
ext4_da_writepage which redirty pages which are not fully mapped. That
means we skip pages. We retry using mpage_data_writepages again.

-aneesh
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
