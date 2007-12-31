From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [Updated PATCH] ext4: Use the correct block number when
	reading the super block.
Date: Mon, 31 Dec 2007 14:12:10 +0530
Message-ID: <20071231084210.GA9890@skywalker>
References: <1199089762-10378-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: cmm@us.ibm.com, tytso@mit.edu, akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:46019 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544AbXLaIoF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 31 Dec 2007 03:44:05 -0500
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp01.au.ibm.com (8.13.1/8.13.1) with ESMTP id lBV8ihbJ027074
	for <linux-ext4@vger.kernel.org>; Mon, 31 Dec 2007 19:44:43 +1100
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id lBV8kPis160542
	for <linux-ext4@vger.kernel.org>; Mon, 31 Dec 2007 19:46:25 +1100
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lBV8gW7x009744
	for <linux-ext4@vger.kernel.org>; Mon, 31 Dec 2007 19:42:32 +1100
Content-Disposition: inline
In-Reply-To: <1199089762-10378-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 31, 2007 at 01:59:22PM +0530, Aneesh Kumar K.V wrote:
> If the block device hard sector size is larger than EXT4_MIN_BLOCK_SIZE we
> end up with wrong block number when reading super block.
> 

Ignore the patch. I got confused by the do_div syntax. The do_div already save
the division result in logical_sb_block;

-aneesh
