From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: What's cooking in e2fsprogs.git (topics)
Date: Sat, 1 Mar 2008 21:24:51 -0600
Message-ID: <20080301212451.66633441@gara>
References: <E1IooAl-0006SJ-Ki@closure.thunk.org>
	<20071217171100.GA7070@thunk.org>
	<20080211045107.GB25089@mit.edu>
	<20080219050945.GU25098@mit.edu>
	<20080229154333.GC8968@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:39571 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbYCBDY7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 1 Mar 2008 22:24:59 -0500
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m223OsRk003980
	for <linux-ext4@vger.kernel.org>; Sat, 1 Mar 2008 22:24:54 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m223Oshb213170
	for <linux-ext4@vger.kernel.org>; Sat, 1 Mar 2008 20:24:54 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m223Osch025300
	for <linux-ext4@vger.kernel.org>; Sat, 1 Mar 2008 20:24:54 -0700
In-Reply-To: <20080229154333.GC8968@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 29 Feb 2008 10:43:33 -0500
Theodore Tso <tytso@MIT.EDU> wrote:
> Although I've checked to make sure that each of these topic branches
> passes "make check" on their own, the combined pu branch is failing
> due to what appears to be unfortunate interactions between js/flex-bg
> and js/uninit.  This *may* be because I botched the merge, which got
> tricky when I merged in js/uninit into the pu branch which already had
> js/flex-bg.  If someone could take a look at the misc/mke2fs.c changes
> in "git show bffaaf74", I'd much appreciate it.

The misc/mke2fs.c changes look sane to me.

> * js/flex-bg (Wed Feb 13 20:47:50 2008 -0600) 1 commit
>  - e2fsprogs: New bitmap and inode table allocation for FLEX_BG v2
> 
> 	I've noticed that this patch is slightly different from what
> 	Jose sent in for the e2fsprogs-interim branch, so I'm a little
> 	concerned about which is the latest, or whether the
> 	differences are intentional.  Jose, if you have time, could
> 	you take a look at commits cb676995 and 8072fe6 and perhaps comment?

There where slight differences in misc/mke2fs.c that required making a
different patch for the e2fsprogs-interim branch.  The patches are
functionally the same.

-JRS
