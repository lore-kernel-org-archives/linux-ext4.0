From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -V4] ext4: sparse fixes
Date: Fri, 21 Nov 2008 23:25:34 +0530
Message-ID: <20081121175534.GI11212@skywalker>
References: <1227285636-16221-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20081121175110.GA12412@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com,
	linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:43937 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757063AbYKURzo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Nov 2008 12:55:44 -0500
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp07.in.ibm.com (8.13.1/8.13.1) with ESMTP id mALHtfGb026524
	for <linux-ext4@vger.kernel.org>; Fri, 21 Nov 2008 23:25:41 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mALHtgMx3027022
	for <linux-ext4@vger.kernel.org>; Fri, 21 Nov 2008 23:25:42 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.13.1/8.13.3) with ESMTP id mALHteQa021896
	for <linux-ext4@vger.kernel.org>; Sat, 22 Nov 2008 04:55:41 +1100
Content-Disposition: inline
In-Reply-To: <20081121175110.GA12412@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 21, 2008 at 12:51:10PM -0500, Christoph Hellwig wrote:
> On Fri, Nov 21, 2008 at 10:10:36PM +0530, Aneesh Kumar K.V wrote:
> >  #define EXT4_HAS_COMPAT_FEATURE(sb,mask)			\
> > -	(EXT4_SB(sb)->s_es->s_feature_compat & cpu_to_le32(mask))
> > +	(__force __u32)!!(EXT4_SB(sb)->s_es->s_feature_compat &	\
> > +					cpu_to_le32(mask))
> 
> As mentioned before please don't abuse __force here.
> 
> 	((EXT4_SB(sb)->s_es->s_feature_compat & cpu_to_le32(mask)) != 0)
> 
> does the right things and is a lote more readable.

I thought your comment was on returning value that had multiple flag bit
set. I didn't look at the __force usage as bad. I will send an updated patch.

-aneesh
