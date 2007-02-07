From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: [RFC] [PATCH 1/1] Nanosecond timestamps
Date: Wed, 07 Feb 2007 15:05:39 -0600
Message-ID: <1170882340.13329.4.camel@kleikamp.austin.ibm.com>
References: <1170427790.6464.6.camel@garfield>
	 <20070206151242.GB3140@lombardij>
	 <20070207203946.GB6565@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Johann Lombardi <johann.lombardi@bull.net>,
	Kalpak Shah <kalpak@clusterfs.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>, tytso <tytso@mit.edu>,
	sct <sct@redhat.com>
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:49921 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422737AbXBGVGN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Feb 2007 16:06:13 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l17L6BXJ016264
	for <linux-ext4@vger.kernel.org>; Wed, 7 Feb 2007 16:06:11 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l17L5gKp196972
	for <linux-ext4@vger.kernel.org>; Wed, 7 Feb 2007 16:05:42 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l17L5fNi012718
	for <linux-ext4@vger.kernel.org>; Wed, 7 Feb 2007 16:05:42 -0500
In-Reply-To: <20070207203946.GB6565@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2007-02-07 at 13:39 -0700, Andreas Dilger wrote:
> On Feb 06, 2007  16:12 +0100, Johann Lombardi wrote:
> > > +                       if (EXT3_SB(sb)->s_want_extra_isize <
> > > +                           le32_to_cpu(es->s_min_extra_isize))
> >                                 ^^
> > > +                               EXT3_SB(sb)->s_want_extra_isize =
> > > +                                       le32_to_cpu(es->s_min_extra_isize);
> >                                             ^^
> > Since es->s_{min,want}_extra_isize are both __u16 (BTW, shouldn't it be
> > __le16?), I think you should use le16_to_cpu() instead of le32_to_cpu().
> 
> You are right - this works fine on little endian systems, but fails on
> big endian systems where you will get the other half of the word.
> 
> This has been a bug in several places already, and I wonder if the
> le*_to_cpu() and cpu_to_le*() macros shouldn't do some type checking
> instead of just casting the variable to the specified type?

I think that sparse will catch this.  To get the endian checks you need
to do something like this:

make C=2 CF="-D__CHECK_ENDIAN__"'

-- 
David Kleikamp
IBM Linux Technology Center
