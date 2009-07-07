From: Andreas Dilger <adilger@sun.com>
Subject: Re: Strange disk failure...could ext4 be the culprit?
Date: Tue, 07 Jul 2009 16:28:34 -0600
Message-ID: <20090707222834.GQ5073@webber.adilger.int>
References: <loom.20090707T173457-377@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Evan King <f11n1@unb.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:53756 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755652AbZGGW3G (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Jul 2009 18:29:06 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n67MSoJ7024456
	for <linux-ext4@vger.kernel.org>; Tue, 7 Jul 2009 15:29:05 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KMF00J00NOWU000@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Tue,
 07 Jul 2009 15:28:50 -0700 (PDT)
In-reply-to: <loom.20090707T173457-377@post.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jul 07, 2009  18:16 +0000, Evan King wrote:
> So my questions are these:
> 
>  - How likely is it that some arcane bug in ext4 is responsible for the failure?

It is possible - there are still bugs being fixed in ext4.

>  - What can I do to track the occurrence of this bug, its source, and/or the
> conditions that may trigger it?  (Note that iostat shows nothing of interest,
> as the actual I/O load isn't particularly unusual.)

Reporting the actual kernel version you are using is critical.  If you
are going to stick with ext4, I would follow the latest FC11 kernels,
since there is an active maintainer for ext4 at Red Hat.

Depending on how you formatted the filesystem, you may be able to revert
to ext3 if you want more stability.  Providing the output of "dumpe2fs -h"
for the filesystem will tell (in particular the "features" line).

>  - Should I seriously consider using an SSD?  (NFS will not share
> memory-mapped directories, which thwarted the last of my 'better' plans,
> and the software's scratch directory can potentially grow to several gigs
> over the span of a few days/weeks.)

That is an independent question from using ext4.  If you are using NFS
without "async", then an SSD will almost certainly help performance,
but it is probably completely unrelated to the corruption issue.


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

