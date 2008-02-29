From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 2/2] e2fsprogs: fix resize2fs moving inodes with inline
 xattrs
Date: Fri, 29 Feb 2008 11:20:00 -0600
Message-ID: <47C83EC0.4080009@redhat.com>
References: <47C70A61.4080302@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:54568 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752308AbYB2RUM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 Feb 2008 12:20:12 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m1THK1ox014702
	for <linux-ext4@vger.kernel.org>; Fri, 29 Feb 2008 12:20:06 -0500
Received: from lacrosse.corp.redhat.com (lacrosse.corp.redhat.com [172.16.52.154])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1THK0qf019269
	for <linux-ext4@vger.kernel.org>; Fri, 29 Feb 2008 12:20:00 -0500
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by lacrosse.corp.redhat.com (8.12.11.20060308/8.11.6) with ESMTP id m1THK0TM010057
	for <linux-ext4@vger.kernel.org>; Fri, 29 Feb 2008 12:20:00 -0500
In-Reply-To: <47C70A61.4080302@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> Addresses RH Bug 434893: resizing leads to missing xattrs
> 
> inode_scan_and_fix() in resize2fs needs to do read/write
> of the full inode to be sure it gets all data from larger
> (>128 byte) inodes.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Well, crud, this isn't working on ppc.  Looking into it now... I guess I
should use the resources at my disposal to test the "odd arches" before
sending patches... sorry.

-Eric
