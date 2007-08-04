From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: Ext4 devel interlock meeting minutes (July 30, 2007)
Date: Fri, 3 Aug 2007 21:42:22 -0500
Message-ID: <20070803214222.2e0999f8@gara>
References: <46B3B2A5.9000307@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Avantika Mathur <mathur@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:36300 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbXHDCov (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Aug 2007 22:44:51 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l742ioat026134
	for <linux-ext4@vger.kernel.org>; Fri, 3 Aug 2007 22:44:50 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l742ioL6269436
	for <linux-ext4@vger.kernel.org>; Fri, 3 Aug 2007 20:44:50 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l742ioNm012278
	for <linux-ext4@vger.kernel.org>; Fri, 3 Aug 2007 20:44:50 -0600
Received: from austin.ibm.com (netmail2.austin.ibm.com [9.41.248.176])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l742ingk012258
	for <linux-ext4@vger.kernel.org>; Fri, 3 Aug 2007 20:44:50 -0600
In-Reply-To: <46B3B2A5.9000307@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 03 Aug 2007 15:56:37 -0700
Avantika Mathur <mathur@linux.vnet.ibm.com> wrote:
> Flexible Block Groups:
> - Jose is trying to see why fsck is not working.  once this is resolved, 
> the feature will be complete. 

Not quite true.  Solving the fsck issue means that we can do more
thorough testing of the performance impacts of packaging meta-data
closer together.  The patches do not currently remove the 512TB limit
imposed by the number of block groups, which is something that I also
plan to address on this feature.

-JRS
