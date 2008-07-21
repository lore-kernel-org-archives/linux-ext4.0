From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: delalloc is crippling fs_mark performance
Date: Mon, 21 Jul 2008 11:22:39 -0500
Message-ID: <4884B7CF.7060800@redhat.com>
References: <4880C0B2.9040706@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:59142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329AbYGUQWl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Jul 2008 12:22:41 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m6LGMfYm010502
	for <linux-ext4@vger.kernel.org>; Mon, 21 Jul 2008 12:22:41 -0400
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6LGMeX4006870
	for <linux-ext4@vger.kernel.org>; Mon, 21 Jul 2008 12:22:40 -0400
Received: from Liberator.local (sebastian-int.corp.redhat.com [172.16.52.221])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6LGMdML018416
	for <linux-ext4@vger.kernel.org>; Mon, 21 Jul 2008 12:22:40 -0400
In-Reply-To: <4880C0B2.9040706@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> running fs_mark like this:
> 
> fs_mark -d /mnt/test -D 256 -n 100000 -t 4 -s 20480 -F -S 0
> 
> (256 subdirs, 100000 files/iteration, 4 threads, 20k files, no sync)
> 
> on a 1T fs, with and without delalloc (mount option), is pretty interesting:
> 
> http://people.redhat.com/esandeen/ext4/fs_mark.png

I've updated this graph with another run where the group_prealloc
tuneable was set to a perfect multiple of the allocation size, or 500
blocks.  This way the leftover 2-block preallocations don't wind up
causing the list to grow with unuseable tiny leftover preallocations.
After tuning this way, it does clearly seem to be the problem here.

-Eric

