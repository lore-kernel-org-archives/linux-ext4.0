From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: e2fsprogs coverity patch <cid-11.diff>
Date: Wed, 21 Mar 2007 14:14:15 -0500
Message-ID: <1174504455.13386.30.camel@kleikamp.austin.ibm.com>
References: <200702100211.l1A2B9wF007009@igsi.llnl.gov>
	 <20070321185445.GA17405@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "Brian D. Behlendorf" <behlendorf1@llnl.gov>,
	linux-ext4@vger.kernel.org, adilger@clusterfs.com,
	wartens2@llnl.gov
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:42741 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933788AbXCUTPh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Mar 2007 15:15:37 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l2LJFWTe016673
	for <linux-ext4@vger.kernel.org>; Wed, 21 Mar 2007 15:15:32 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l2LJEGeB286596
	for <linux-ext4@vger.kernel.org>; Wed, 21 Mar 2007 15:14:16 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l2LJEFnT025541
	for <linux-ext4@vger.kernel.org>; Wed, 21 Mar 2007 15:14:15 -0400
In-Reply-To: <20070321185445.GA17405@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2007-03-21 at 14:54 -0400, Theodore Tso wrote:
> On Fri, Feb 09, 2007 at 06:11:09PM -0800, Brian D. Behlendorf wrote:
> > Add an extra byte to EXT2_NAME_LEN in the static allocation for the
> > required trailing null.  This allows filenames up to the maximum
> > length of EXT2_NAME_LEN withover an overrun.
> > 
> > Coverity ID: 11: Overrun Static
> > 
> > -	thislen = ((dirent->name_len & 0xFF) < EXT2_NAME_LEN) ?
> > +	thislen = ((dirent->name_len & 0xFF) <= EXT2_NAME_LEN) ?
> >  		(dirent->name_len & 0xFF) : EXT2_NAME_LEN;
> 
> This change is largely meaningless/unnecessary, since if
> *dirent->name_len & 0xFF) is equal to EXT2_NAME_LEN it doesn't matter
> which path is chosen; was there a reason for the change.

#define EXT2_NAME_LEN 255

How about this?

	thislen = dirent->name_len & 0xFF;

-- 
David Kleikamp
IBM Linux Technology Center
