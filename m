From: Suparna Bhattacharya <suparna@in.ibm.com>
Subject: Re: Updated ext4/jbd2 patches based on 2.6.19-rc1
Date: Tue, 10 Oct 2006 13:24:02 +0530
Message-ID: <20061010075402.GA23992@in.ibm.com>
References: <1160072610.8508.12.camel@kleikamp.austin.ibm.com> <20061005173933.f54555fb.akpm@osdl.org> <20061009232927.77b667c2.akpm@osdl.org>
Reply-To: suparna@in.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Kleikamp <shaggy@austin.ibm.com>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:61062 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S964979AbWJJHvt
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Oct 2006 03:51:49 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e34.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id k9A7pnkj032558
	for <linux-ext4@vger.kernel.org>; Tue, 10 Oct 2006 03:51:49 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by westrelay02.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k9A7pma7485684
	for <linux-ext4@vger.kernel.org>; Tue, 10 Oct 2006 01:51:48 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k9A7pm49002016
	for <linux-ext4@vger.kernel.org>; Tue, 10 Oct 2006 01:51:48 -0600
To: Andrew Morton <akpm@osdl.org>
Content-Disposition: inline
In-Reply-To: <20061009232927.77b667c2.akpm@osdl.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Oct 09, 2006 at 11:29:27PM -0700, Andrew Morton wrote:
> On Thu, 5 Oct 2006 17:39:33 -0700
> Andrew Morton <akpm@osdl.org> wrote:
> 
> > Could we please have a few nice words about ext4 for the record?  Like,
> > what its features are, how one creates an instance, where to get the
> > correct userspace tools from, stability level, any known shortcomings,
> > issues, etc?
> 
> So I guess I get to write this.

Hopefully not :) 
We should be able to put something together for a start. Where should this
reside ? Under Documentation/filesystems/ext4.txt ?

However, since this is still very clearly a "development" branch at the moment,
with lots of ongoing work both on the kernel and even more so on the
tools side, how much detail are you looking for ?

Regards
Suparna

> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Suparna Bhattacharya (suparna@in.ibm.com)
Linux Technology Center
IBM Software Lab, India

