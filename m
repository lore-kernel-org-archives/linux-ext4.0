From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [RFC] [PATCH] Flex_BG ialloc awareness V2.
Date: Fri, 14 Dec 2007 12:07:23 -0600
Message-ID: <20071214120723.2cf97caa@gara>
References: <20071206161045.1054bbe7@gara>
	<20071207101428.GE3214@webber.adilger.int>
	<20071207095212.037ca68a@gara>
	<20071211110033.GQ3214@webber.adilger.int>
	<20071211100812.557b923b@gara>
	<20071211231528.GS3214@webber.adilger.int>
	<20071213095112.100b3d9e@gara>
	<20071213225857.GK3214@webber.adilger.int>
	<20071213203611.69525e6c@gara>
	<20071214170106.GQ3214@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:35894 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752288AbXLNSHn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 14 Dec 2007 13:07:43 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id lBEI7TZD005003
	for <linux-ext4@vger.kernel.org>; Fri, 14 Dec 2007 13:07:29 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id lBEI7SiK132570
	for <linux-ext4@vger.kernel.org>; Fri, 14 Dec 2007 13:07:29 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lBEI7SKH023097
	for <linux-ext4@vger.kernel.org>; Fri, 14 Dec 2007 13:07:28 -0500
In-Reply-To: <20071214170106.GQ3214@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 14 Dec 2007 10:01:06 -0700
Andreas Dilger <adilger@sun.com> wrote:
> Well, I can imagine in some cases that the flexbg will not be completely
> contiguous on disk (e.g. after a filesystem resize, if there are bad
> blocks, etc).  As long as the group descriptors themselves are correct
> (i.e. referencing valid bitmaps/itable) then it shouldn't cause a mount
> failure if the per-group data isn't strictly aligned according to the
> superblock flexbg count.

Yes, the meta-data may not be completely contiguous on the disk as per
the definition of flexbg.  What I was planing on doing was to check the
first, second and last-1 flexbg to see if how the meta-data is
arranged.  If none of those flexbg matches the size of the flexbg size
in the super block the we can set sbi->s_groups_per_flex_shift to zero
which would make the fs fallback to Orlov.
 
> We would need to validate the group descriptor separately though (e.g.
> group checksums).

Agree
 
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
> 

-JRS
