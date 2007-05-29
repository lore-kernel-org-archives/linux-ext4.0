From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH] update ext4-nanosecond-patch comments
Date: Tue, 29 May 2007 05:53:27 -0600
Message-ID: <20070529115327.GY5181@schatzie.adilger.int>
References: <20070529054822.GA14186@skywalker.home.org> <1180420717.4339.8.camel@garfield> <465BE1CF.2040304@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kalpak Shah <kalpak@clusterfs.com>, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:50641 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117AbXE2Lx3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 May 2007 07:53:29 -0400
Content-Disposition: inline
In-Reply-To: <465BE1CF.2040304@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On May 29, 2007  13:48 +0530, Aneesh Kumar K.V wrote:
> Kalpak Shah wrote:
> >On Tue, 2007-05-29 at 11:18 +0530, Aneesh Kumar K.V wrote:
> >>Also can we have a description of why s_{min, want}_extra_isize
> >>fields are added in the commit message ?
> >
> >The i_extra_isize for each inode should ideally be s_want_extra_isize
> >after inode expansion. If expansion by s_want_extra_isize is not
> >possible, then i_extra_isize must be atleast s_min_extra_isize.
> 
> My point was that the commit message of ext4-nanosecond-patch should 
> explain the usage scenario for these variables. We may want to move the
> commit message of ext4_expand_inode_extra_isize.patch reworded to this.
> 
> BTW i also think that adding s_{min, want}_extra_isize can be a separate 
> patch altogether.

When the nanosecond timestamp extension was first proposed, the requirement
from Ted and Stephen were that s_min_extra_isize was a requirement.  Otherwise
it would be possible to have a filesystem where the timestamps are going
backward on some files due to MOST of the files supporting ns timestamps,
but some with full EAs having to truncate the ns part away.

Now, this might not be critical for some users, but for others it can be.
Since this functionality is all here there isn't any reason to move it to
a separate patch.  The same fields will be important for the inode version
also.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
