From: Karsten Weiss <K.Weiss@science-computing.de>
Subject: Re: Bad ext4 sync performance on 16 TB GPT partition
Date: Fri, 26 Feb 2010 12:33:22 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1002261228570.18232@wong.science-computing.de>
References: <alpine.LNX.2.00.1002260926140.18232@wong.science-computing.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.belwue.de ([129.143.2.12]:65187 "EHLO smtp1.belwue.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934718Ab0BZLdg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 26 Feb 2010 06:33:36 -0500
Received: from mx4.science-computing.de (mx4.science-computing.de [193.197.16.30])
	by smtp1.belwue.de with ESMTP id o1QBXYgS002873
	for <linux-ext4@vger.kernel.org>; Fri, 26 Feb 2010 12:33:34 +0100 (MET)
	env-from (prvs=6660bea79=K.Weiss@science-computing.de)
In-Reply-To: <alpine.LNX.2.00.1002260926140.18232@wong.science-computing.de>
Content-ID: <alpine.LNX.2.00.1002261229581.18232@wong.science-computing.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 26 Feb 2010, Karsten Weiss wrote:

> However, the sync performance is fine if we ...
> 
> * use xfs or
> * disable the ext4 journal or
> * disable ext4 extents (but with enabled journal)

ext3 is okay, too:

# /usr/bin/time bash -c "dd if=/dev/zero of=/mnt/large/10GB_1 bs=1M count=10000 && sync"
10000+0 records in
10000+0 records out
10485760000 bytes (10 GB) copied, 39.7188 seconds, 264 MB/s
0.03user 21.00system 1:47.24elapsed 19%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (0major+788minor)pagefaults 0swaps

Compare:

XFS:    57s
ext4: 7m26s

-- 
Karsten Weiss
