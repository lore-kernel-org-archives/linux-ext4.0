From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] Add checks to validate extent entries.
Date: Mon, 9 Feb 2009 16:01:58 +0530
Message-ID: <20090209103158.GD31884@skywalker>
References: <20090207173239.GA25942@skywalker> <1234036882-30656-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <499004C4.9040305@ph.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:51653 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116AbZBIKcI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Feb 2009 05:32:08 -0500
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.31.243])
	by e23smtp09.au.ibm.com (8.13.1/8.13.1) with ESMTP id n19APnwp021859
	for <linux-ext4@vger.kernel.org>; Mon, 9 Feb 2009 21:25:49 +1100
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id n19AWN7T324056
	for <linux-ext4@vger.kernel.org>; Mon, 9 Feb 2009 21:32:23 +1100
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n19AW5ZH017967
	for <linux-ext4@vger.kernel.org>; Mon, 9 Feb 2009 21:32:05 +1100
Content-Disposition: inline
In-Reply-To: <499004C4.9040305@ph.tum.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 09, 2009 at 11:26:12AM +0100, Thiemo Nagel wrote:
> Aneesh Kumar K.V wrote:
> > This patch adds check to validate the extent entries along
> > with extent  headers. Should handle crash with corrupt filesystem.
> 
> While your patch probably decreases the average number of checks that
> are done, it makes single random accesses quite expensive since always
> complete extent blocks are checked at once, even if just a single pblock
> is accessed.  No idea whether there are workloads which have that as a
> typical access pattern...

The second patch make sure we do it only when we read the extent
information from the disk.

-aneesh
