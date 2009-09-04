From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: EXT4: kernel BUG at fs/jbd2/commit.c:533!
Date: Fri, 4 Sep 2009 13:32:55 +0530
Message-ID: <20090904080254.GA19757@skywalker.linux.vnet.ibm.com>
References: <4A9E5496.8050909@in.ibm.com> <20090902120958.GA16415@mit.edu> <20090902210737.GV4197@webber.adilger.int> <20090902223011.GA30497@mit.edu> <4A9F3F7F.6030304@in.ibm.com> <4A9F71EA.4070406@in.ibm.com> <4AA09ED6.3050007@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	linux-ext4@vger.kernel.org
To: Sachin Sant <sachinp@in.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:45560 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856AbZIDIDO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Sep 2009 04:03:14 -0400
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.31.243])
	by e23smtp03.au.ibm.com (8.14.3/8.13.1) with ESMTP id n8480rHF031331
	for <linux-ext4@vger.kernel.org>; Fri, 4 Sep 2009 18:00:53 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n8483FRR430120
	for <linux-ext4@vger.kernel.org>; Fri, 4 Sep 2009 18:03:15 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n8483E9n014214
	for <linux-ext4@vger.kernel.org>; Fri, 4 Sep 2009 18:03:15 +1000
Content-Disposition: inline
In-Reply-To: <4AA09ED6.3050007@in.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 04, 2009 at 10:30:06AM +0530, Sachin Sant wrote:
> Sachin Sant wrote:
>> As for this issue not sure how to proceed further. I probably will
>> continue to execute the tests few more times. Maybe will try on
>> a different box.
> After increasing nproc value from 50 to 150 (-p 150)
> i was able to recreate this bug again.
>


Can you find the below info

a) blocksize with which the file system was created
b) I guess the file system was in data=journal mode (looking at the dmesg output)

-aneesh
