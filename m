From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: When reading from fallocated blocks make sure we
	return zero.
Date: Sat, 16 Feb 2008 08:53:34 +0530
Message-ID: <20080216032334.GA6501@skywalker>
References: <1203099414-8815-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1203104584.3598.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:50374 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763893AbYBPDXm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Feb 2008 22:23:42 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id m1G3NQiG018583
	for <linux-ext4@vger.kernel.org>; Sat, 16 Feb 2008 14:23:26 +1100
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1G3NeD13383446
	for <linux-ext4@vger.kernel.org>; Sat, 16 Feb 2008 14:23:40 +1100
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1G3Nebg008649
	for <linux-ext4@vger.kernel.org>; Sat, 16 Feb 2008 14:23:40 +1100
Content-Disposition: inline
In-Reply-To: <1203104584.3598.4.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 15, 2008 at 11:43:04AM -0800, Mingming Cao wrote:
> On Fri, 2008-02-15 at 23:46 +0530, Aneesh Kumar K.V wrote:
> > fallocate blocks are considered as sparse area and read from them should
> > return zero. ext4_ext_get_blocks should return zero for read request.
> > 
> 
> The patch itself looks harmless, but I still don't see how this could
> fix the problem you described at irc: a write hit a BUG_ON() in
> fs/buffer.c saying the buffer is not mapped. Could you add more details
> here?

Write will take the below call chain

ext4_write_begin
  block_write_begin
    __block_prepare_write
       ext4_getblock
         ext4_get_blocks_wrap
(1)	   ext4_ext_get_blocks with create = 0 return allocated
       ll_rw_block  if buffer not uptodate.
         submit_bh
	   BUG_ON(!buffer_mapped(bh))


ext4_ext_get_blocks at (1) should have returned 0. That would cause
ext4_get_blocks_wrap to again call ext4_ext_get_blocks with create = 1
and that would have returned us the buffer head which is mapped. This
would also result in splitting the extent to initialized and
uninitialized one.


-aneesh
