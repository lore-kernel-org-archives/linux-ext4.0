From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: ext3: kernel BUG at fs/jbd/journal.c:412!
Date: Thu, 6 Nov 2008 23:08:55 +0530
Message-ID: <20081106173855.GI25194@skywalker>
References: <20081106155025.GE25194@skywalker> <20081106161227.GA9254@ajones-laptop.nbttech.com> <20081106171322.GD18939@mit.edu> <20081106171639.GH25194@skywalker> <20081106173236.GE18939@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arthur Jones <ajones@riverbed.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp06.au.ibm.com ([202.81.18.155]:34547 "EHLO
	ausmtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbYKFRqw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Nov 2008 12:46:52 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by ausmtp06.au.ibm.com (8.13.8/8.13.8) with ESMTP id mA6HjCSb4735100
	for <linux-ext4@vger.kernel.org>; Fri, 7 Nov 2008 04:45:12 +1100
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mA6HdBkr2981904
	for <linux-ext4@vger.kernel.org>; Fri, 7 Nov 2008 04:39:11 +1100
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mA6Hd6dl005251
	for <linux-ext4@vger.kernel.org>; Fri, 7 Nov 2008 04:39:07 +1100
Content-Disposition: inline
In-Reply-To: <20081106173236.GE18939@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 06, 2008 at 12:32:36PM -0500, Theodore Tso wrote:
> On Thu, Nov 06, 2008 at 10:46:39PM +0530, Aneesh Kumar K.V wrote:
> > 
> > you would need the same patch for jbd2
> 
> I know, already done, and checked into the ext4 patch queue.

Now i am hitting this on ext4

__jbd2_log_wait_for_space: needed 1024 blocks and only had 1023 space
available
__jbd2_log_wait_for_space: no way to get more journal space in hdc:8
------------[ cut here ]------------
kernel BUG at fs/jbd2/checkpoint.c:164!
invalid opcode: 0000 [#1] SMP

I also have the change to make sure we use the right chunk value in
ext4_index_trans_blocks

-aneesh
