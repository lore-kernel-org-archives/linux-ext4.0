From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] ext4: Fix truncation of symlinks after failed write
Date: Wed, 15 Jul 2009 11:48:56 +0530
Message-ID: <20090715061856.GB17310@skywalker>
References: <1247513367-5609-1-git-send-email-jack@suse.cz> <1247513367-5609-3-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:55764 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbZGOGTE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Jul 2009 02:19:04 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28smtp03.in.ibm.com (8.13.1/8.13.1) with ESMTP id n6F6J0tZ018894
	for <linux-ext4@vger.kernel.org>; Wed, 15 Jul 2009 11:49:00 +0530
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n6F6IxEf3964968
	for <linux-ext4@vger.kernel.org>; Wed, 15 Jul 2009 11:49:00 +0530
Received: from d28av02.in.ibm.com (loopback [127.0.0.1])
	by d28av02.in.ibm.com (8.13.1/8.13.3) with ESMTP id n6F6IxrB016498
	for <linux-ext4@vger.kernel.org>; Wed, 15 Jul 2009 16:18:59 +1000
Content-Disposition: inline
In-Reply-To: <1247513367-5609-3-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 13, 2009 at 09:29:27PM +0200, Jan Kara wrote:
> Contents of long symlinks is written via standard write methods. So when the
> write fails, we add inode to orphan list. But symlinks don't have .truncate
> method defined so nobody properly removes them from the on disk orphan list.
> 
> Fix this by calling ext4_truncate() directly instead of calling vmtruncate()
> (which is saner anyway since we don't need anything vmtruncate() does except
> from calling .truncate in these paths).

We are fixing below by not adding the inode to orphan list if they don't
have a .truncate call back right ?. So changing vmtruncate to ext4_truncate is
not be really needed to fix the problem right ?


>We also add inode to orphan list only
> if ext4_can_truncate() is true (currently, it can be false for symlinks when
> there are no blocks allocated) - otherwise orphan list processing will complain
> and ext4_truncate() will not remove inode from on-disk orphan list.
> 

-aneesh
