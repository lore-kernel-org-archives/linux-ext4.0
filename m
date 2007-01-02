From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [RFC][Patch 1/2] Persistent preallocation in ext4
Date: Tue, 02 Jan 2007 14:47:32 -0800
Message-ID: <1167778052.4197.3.camel@dyn9047017103.beaverton.ibm.com>
References: <20061205134338.GA1894@amitarora.in.ibm.com>
	 <20061206055822.GA6182@amitarora.in.ibm.com>
	 <20061215123528.GA24572@amitarora.in.ibm.com>
	 <1167262245.3792.20.camel@dyn9047017103.beaverton.ibm.com>
	 <20070102110409.GB5932@amitarora.in.ibm.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, suparna@in.ibm.com, suzuki@in.ibm.com,
	alex@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:34613 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932914AbXABWrm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Jan 2007 17:47:42 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id l02MlZsi028114
	for <linux-ext4@vger.kernel.org>; Tue, 2 Jan 2007 17:47:35 -0500
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id l02MlYwQ525152
	for <linux-ext4@vger.kernel.org>; Tue, 2 Jan 2007 15:47:34 -0700
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l02MlYcA028442
	for <linux-ext4@vger.kernel.org>; Tue, 2 Jan 2007 15:47:34 -0700
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
In-Reply-To: <20070102110409.GB5932@amitarora.in.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2007-01-02 at 16:34 +0530, Amit K. Arora wrote:
> Hi Mingming,
> > And, Looking at other places calling ext4_*_get_blocks() in the kernel,
> > it seems not all of them protected by i_mutex lock. I think it probably
> > okay to not holding i_mutex during calling ext4_ext4_get_blocks().
> 
> We are not holding i_mutex lock during ext4_ext_get_blocks() call.
> Above, this lock is being held inorder to avoid race while updating the
> filesize in inode (reference your comment in a previous mail "I think we
> should update i_size and i_disksize after preallocation. Oh,
> to protect parallel updating i_size, we have to take i_mutex down.").
> Perhaps, truncate_mutex lock should be used here, and not i_mutex.
> 

truncate_mutex is hold at the entry of ext4_**_get_blocks() to protect
parallel block allocation. Here I was worried about concurrent modifying
i_size and i_disksize which were protected by the i_mutex lock. Sorry
for any confusion.
