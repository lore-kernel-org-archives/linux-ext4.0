From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2 V3] allow direct IO to fallocate and holes
Date: Thu, 10 Sep 2009 13:27:30 +0530
Message-ID: <20090910075730.GD8690@skywalker.linux.vnet.ibm.com>
References: <1252025090.15321.17.camel@mingming-laptop>
 <20090907215746.GA11748@duck.suse.cz>
 <1252529462.19097.170.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
To: Mingming <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:50170 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704AbZIJH5b (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Sep 2009 03:57:31 -0400
Received: from d28relay03.in.ibm.com (d28relay03.in.ibm.com [9.184.220.60])
	by e28smtp05.in.ibm.com (8.14.3/8.13.1) with ESMTP id n8A7vWCP026138
	for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2009 13:27:32 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay03.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n8A7vWoE2384010
	for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2009 13:27:32 +0530
Received: from d28av04.in.ibm.com (loopback [127.0.0.1])
	by d28av04.in.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id n8A7vVke003737
	for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2009 17:57:32 +1000
Content-Disposition: inline
In-Reply-To: <1252529462.19097.170.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 09, 2009 at 01:51:02PM -0700, Mingming wrote:
.....
.....

> >   I think fsync() still won't work correctly since it can happen user sees
> > AIO completed, calls fsync() that completes, 
> 
> hmm, does fsync() ensure user sees AIO data completed?
>

If we call fsync after getting AIO completion event and crash we should
ensure that the data can be read back properly. That is either

a) we should ensure that we convert the extent before returning the io
    completion event
b) Or the fsync should be able to guarantee that it will force the extent
   conversion pending on the file.

-aneesh
