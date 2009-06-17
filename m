From: Andreas Dilger <adilger@sun.com>
Subject: Re: Something wrong with extent-based journal creation
Date: Wed, 17 Jun 2009 02:04:32 -0600
Message-ID: <20090617080432.GC13073@webber.adilger.int>
References: <4A381EC8.4010202@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:49331 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556AbZFQIEp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Jun 2009 04:04:45 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n5H84imd011977
	for <linux-ext4@vger.kernel.org>; Wed, 17 Jun 2009 01:04:48 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KLD00700IDAW500@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Wed,
 17 Jun 2009 01:04:44 -0700 (PDT)
In-reply-to: <4A381EC8.4010202@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jun 16, 2009  17:38 -0500, Eric Sandeen wrote:
> I've narrowed it down to the commit (961306d3) which creates the journal
> with extent format; if that's commented out, it works fine.

Hmm, this seems like it might be a troublesome feature...  Are we sure
that there is proper kernel/tool compatibility for an extent-mapped
journal?  At least none of the Lustre code has any support for this,
though they can handle the INCOMPAT_EXTENTS feature, and I don't think
this was present in older kernels either.

I haven't looked at the code for this yet, so it may be that it will
"just work", but if this is a new feature I would urge caution w.r.t.
compatibility before this is merged upstream (in either e2fsprogs or
the kernel).

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

