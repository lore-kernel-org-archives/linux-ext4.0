From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: RFC PATCH: ext4 no journal corruption with locale-gen
Date: Thu, 2 Jul 2009 00:05:09 +0530
Message-ID: <20090701183509.GB31235@skywalker>
References: <6601abe90906171148w1431258fvd0afa105cda9b77b@mail.gmail.com> <20090617234604.GF7867@mit.edu> <6601abe90906220942se70fb70w5481e178f1525dd8@mail.gmail.com> <20090622211327.GI13398@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Curt Wohlgemuth <curtw@google.com>, Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:46786 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360AbZGASfP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Jul 2009 14:35:15 -0400
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.31.243])
	by e23smtp07.au.ibm.com (8.13.1/8.13.1) with ESMTP id n624ZHck016654
	for <linux-ext4@vger.kernel.org>; Thu, 2 Jul 2009 14:35:17 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n61IZHjs475412
	for <linux-ext4@vger.kernel.org>; Thu, 2 Jul 2009 04:35:17 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n61IZHci032369
	for <linux-ext4@vger.kernel.org>; Thu, 2 Jul 2009 04:35:17 +1000
Content-Disposition: inline
In-Reply-To: <20090622211327.GI13398@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 22, 2009 at 11:13:27PM +0200, Andreas Dilger wrote:
> On Jun 22, 2009  09:42 -0700, Curt Wohlgemuth wrote:
> > I tested the locale-gen example with all combinations of
> > 
> >    data=writeback
> >    data=ordered
> >    data=journal
> >    <no journal at all>
> 
> On an unrelated note - would it be useful to mount an ext4 filesystem
> with a journal using "data=none" (or similar) to run without a journal?
> 

I think this is better. I would suggest data=nojournal. That way we can
check the mount options to figure out whether we are running with
journal or not. Also i guess this enables us to run without using a
journal even if  mke2fs created a journal for us

-aneesh
