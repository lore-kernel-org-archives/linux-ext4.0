From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: How to switch ext4 to ordered_data mode
Date: Sat, 14 Jun 2008 14:23:38 +0530
Message-ID: <20080614085338.GC11866@skywalker>
References: <3.0.6.32.20080614003935.02423cb8@pop.west.cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Gary Hawco <ghawco@cox.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:59071 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461AbYFNIxv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 14 Jun 2008 04:53:51 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id m5E8qtGl024372
	for <linux-ext4@vger.kernel.org>; Sat, 14 Jun 2008 18:52:55 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5E8rn7o206854
	for <linux-ext4@vger.kernel.org>; Sat, 14 Jun 2008 18:53:49 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m5E8rm24005155
	for <linux-ext4@vger.kernel.org>; Sat, 14 Jun 2008 18:53:48 +1000
Content-Disposition: inline
In-Reply-To: <3.0.6.32.20080614003935.02423cb8@pop.west.cox.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jun 14, 2008 at 12:39:35AM +0000, Gary Hawco wrote:
> Ted,
> 
> I notice that ext4dev defaults to data=writeback mode. This is in contrast
> to ext3 which uses ordered data mode. Tune2fs from git does not seem to be
> able to change this using "tune2fs -o ^journal_data_writeback /dev/sdaX"
> followed by "tune2fs -o journal_data_ordered /dev/sdaX.
> 
> Is this change intentional or a not yet worked out bug?
> 

With delayed allocation we currently support only writeback mode. We enable
delayed allocation by default with the latest patches. The intention is
to get these new features test well enough before they can be pushed
upstream. Since we enable delalloc by default we also force writeback
mode. You should be able to disable them by -o nodelalloc,data=ordered
mount option. I have patches which  support ordered mode with delalloc. Once we get
those patches in we should be able to remove forcing writeback mode with delalloc.


-aneesh
