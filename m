From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] Add extent conversion support to chattr
Date: Fri, 12 Sep 2008 14:57:49 +0530
Message-ID: <20080912092749.GC8405@skywalker>
References: <1221210249-26484-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080912091713.GY3086@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:50270 "EHLO
	e28esmtp05.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751133AbYILJ21 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Sep 2008 05:28:27 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp05.in.ibm.com (8.13.1/8.13.1) with ESMTP id m8C9RvGx003086
	for <linux-ext4@vger.kernel.org>; Fri, 12 Sep 2008 14:57:57 +0530
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m8C9RvPB1765384
	for <linux-ext4@vger.kernel.org>; Fri, 12 Sep 2008 14:57:57 +0530
Received: from d28av03.in.ibm.com (loopback [127.0.0.1])
	by d28av03.in.ibm.com (8.13.1/8.13.3) with ESMTP id m8C9RuZt002857
	for <linux-ext4@vger.kernel.org>; Fri, 12 Sep 2008 19:27:57 +1000
Content-Disposition: inline
In-Reply-To: <20080912091713.GY3086@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 12, 2008 at 03:17:13AM -0600, Andreas Dilger wrote:
> On Sep 12, 2008  14:34 +0530, Aneesh Kumar wrote:
> > -		_("Usage: %s [-RVf] [-+=AacDdijsSu] [-v version] files...\n"),
> > +		_("Usage: %s [-RVf] [-+=AacDdijsSue] [-v version] files...\n"),
> 
> Please keep options in alphabetical order.
> 
> > @@ -105,6 +105,7 @@ static const struct flags_char flags_array[] = {
> >  	{ EXT2_UNRM_FL, 'u' },
> >  	{ EXT2_NOTAIL_FL, 't' },
> >  	{ EXT2_TOPDIR_FL, 'T' },
> > +	{ EXT4_EXTENTS_FL, 'e'},
> 
> I'd also prefer to keep these in alphabetical order, which they almost are.
> 
> > @@ -199,7 +201,22 @@ static int change_attributes(const char * name)
> >  	if (set) {
> > +		if (extent_file && !(sf & EXT4_EXTENTS_FL)) {
> > +			if (!silent)
> > +				com_err(program_name, 0,
> > +				_("Clearing extent flag not supported on %s"),
> > +					name);
> > +			return -1;
> > +		}
> 
> Why not just try to set this flag and let the kernel decide what is
> possible?
> 

The motivation is to give a clear message that we still don't support
clearing extent flags. If we pass it to the kernel we will get
operation not supported error which would confuse the user who does
chattr -de f1

-aneesh
