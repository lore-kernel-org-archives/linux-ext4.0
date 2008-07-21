From: Andreas Dilger <adilger@sun.com>
Subject: Re: delalloc is crippling fs_mark performance
Date: Mon, 21 Jul 2008 16:39:35 -0600
Message-ID: <20080721223935.GC15203@webber.adilger.int>
References: <4880C0B2.9040706@redhat.com> <4884B7CF.7060800@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:53250 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119AbYGUWjj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Jul 2008 18:39:39 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m6LMddwa002949
	for <linux-ext4@vger.kernel.org>; Mon, 21 Jul 2008 15:39:39 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K4D00I01O2TR700@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Mon, 21 Jul 2008 15:39:38 -0700 (PDT)
In-reply-to: <4884B7CF.7060800@redhat.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jul 21, 2008  11:22 -0500, Eric Sandeen wrote:
> Eric Sandeen wrote:
> > running fs_mark like this:
> > 
> > fs_mark -d /mnt/test -D 256 -n 100000 -t 4 -s 20480 -F -S 0
> > 
> > (256 subdirs, 100000 files/iteration, 4 threads, 20k files, no sync)
> > 
> > on a 1T fs, with and without delalloc (mount option), is pretty interesting:
> > 
> > http://people.redhat.com/esandeen/ext4/fs_mark.png
> 
> I've updated this graph with another run where the group_prealloc
> tuneable was set to a perfect multiple of the allocation size, or 500
> blocks.  This way the leftover 2-block preallocations don't wind up
> causing the list to grow with unuseable tiny leftover preallocations.
> After tuning this way, it does clearly seem to be the problem here.

Looking at that graph it would seem that allowing 1000 PAs to accumulate
with Aneesh's patch adds a constant slowdown.  Compared with the "perfect"
case where the PA list is always empty it is noticably slower.

I'd guess that the right thing to do is have a few buckets for PAs of
different sizes, and keep them very short (e.g. <= 8) to avoid a lot of
list walking overhead on each access.

I think keeping a single PA of "each size" would likely run out if
different-sized allocations are being done, requiring a re-search.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

