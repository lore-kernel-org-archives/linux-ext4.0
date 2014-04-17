From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: RE: [PATCH 3/3] ext4: disable COLLAPSE_RANGE for bigalloc
Date: Thu, 17 Apr 2014 20:27:00 +0900
Message-ID: <008c01cf5a2f$f35f5e30$da1e1a90$@samsung.com>
References: <002b01cf59c3$878af780$96a0e680$@samsung.com>
 <alpine.LFD.2.00.1404171313210.2143@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Cc: 'Theodore Ts'o' <tytso@mit.edu>,
	'linux-ext4' <linux-ext4@vger.kernel.org>
To: =?iso-8859-2?Q?'Luk=E1=B9_Czerner'?= <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:40765 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbaDQL1D (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Apr 2014 07:27:03 -0400
Received: from epcpsbgr5.samsung.com
 (u145.gpu120.samsung.co.kr [203.254.230.145])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0N4600FHMAH1TM80@mailout3.samsung.com> for
 linux-ext4@vger.kernel.org; Thu, 17 Apr 2014 20:27:01 +0900 (KST)
In-reply-to: <alpine.LFD.2.00.1404171313210.2143@localhost.localdomain>
Content-language: ko
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


> >  	}
> >
> > +	if (EXT4_SB(inode->i_sb)->s_cluster_ratio > 1) {
> > +		ret = -EOPNOTSUPP;
> > +		goto out_mutex;
> > +	}
> > +
> 
> I do not think we need to hold mutex for this. You can move it to
> the beginning of the function preferably right after S_ISREG check.
> 
> Otherwise it looks ok, but it would be better if we could fix it :)
Okay, Thanks for review!
> 
> Reviewed-by: Lukas Czerner <lczerner@redhat.com>
> 
> >  	truncate_pagecache_range(inode, ioffset, -1);
> >
> >  	/* Wait for existing dio to complete */
> >

