From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/4] Fix fsync on ext3 and ext4 (v2)
Date: Thu, 5 Nov 2009 22:05:10 +0530
Message-ID: <20091105163510.GA5897@skywalker.linux.vnet.ibm.com>
References: <1256647729-29834-1-git-send-email-jack@suse.cz>
 <20091105130250.GC17008@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:42730 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756450AbZKEQfL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Nov 2009 11:35:11 -0500
Received: from d28relay03.in.ibm.com (d28relay03.in.ibm.com [9.184.220.60])
	by e28smtp05.in.ibm.com (8.14.3/8.13.1) with ESMTP id nA5GZFh3002621
	for <linux-ext4@vger.kernel.org>; Thu, 5 Nov 2009 22:05:15 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay03.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id nA5GZFbl2715882
	for <linux-ext4@vger.kernel.org>; Thu, 5 Nov 2009 22:05:15 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id nA5GZEJV001586
	for <linux-ext4@vger.kernel.org>; Thu, 5 Nov 2009 22:05:14 +0530
Content-Disposition: inline
In-Reply-To: <20091105130250.GC17008@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 05, 2009 at 02:02:50PM +0100, Jan Kara wrote:
>   Hi,
> 
> >   this is a second try for a patchset which makes ext3 and ext4 properly force
> > a transaction commit when needed. We now do not rely on buffer dirty bits
> > (which does not work as pdflush can just clear them without forcing a
> > transaction commit) but rather keep transaction ids that need to be committed
> > for each inode.
> >   Since last version, I've implemented Aneesh's and Curt's comments and also
> > fixed a missing initialization of the fields. I've tested that now the patch
> > works correctly for uninitialized extents as well as for standard writes.  If
> > noone objects, would you merge the ext4 part Ted? I'll take care of the ext3
> > patch.
>   Aneesh, Ted, is the second version of the patchset fine with you?

The patches looks good.

Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

-aneesh
