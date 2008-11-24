From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -V2 3/5] ext4: Fix the race between read_block_bitmap
	and mark_diskspace_used
Date: Mon, 24 Nov 2008 22:13:00 +0530
Message-ID: <20081124164300.GD8462@skywalker>
References: <1227285875-18011-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1227285875-18011-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1227285875-18011-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20081123140038.GC26473@mit.edu> <492A5453.9030801@sun.com> <20081124113323.GC8462@skywalker> <492AD821.9030506@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@MIT.EDU>, cmm@us.ibm.com, sandeen@redhat.com,
	linux-ext4@vger.kernel.org
To: Alex Zhuravlev <Alex.Zhuravlev@Sun.COM>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:39932 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737AbYKXQtb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Nov 2008 11:49:31 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id mAOGmeXk001934
	for <linux-ext4@vger.kernel.org>; Tue, 25 Nov 2008 03:48:40 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mAOGhTVW2420922
	for <linux-ext4@vger.kernel.org>; Tue, 25 Nov 2008 03:43:29 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mAOGhATW015373
	for <linux-ext4@vger.kernel.org>; Tue, 25 Nov 2008 03:43:10 +1100
Content-Disposition: inline
In-Reply-To: <492AD821.9030506@sun.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 24, 2008 at 07:36:49PM +0300, Alex Zhuravlev wrote:
> Aneesh Kumar K.V wrote:
>> Ok the changes was not done for this purpose. I need to make sure we
>> update bitmap and clear group_desc uninit flag after taking sb_bgl_lock
>> That means when we claim blocks we can't use mb_set_bits with
>> sb_bgl_lock because we would already be holding it. How about the below
>> change
>
> may I have a look at the original patch?

http://patchwork.ozlabs.org/patch/10065/

-aneesh
