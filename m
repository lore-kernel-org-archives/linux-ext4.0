From: Andreas Dilger <adilger@sun.com>
Subject: Re: Enable asynchronous commits by default patch revoked?
Date: Mon, 24 Aug 2009 12:31:19 -0600
Message-ID: <20090824183119.GI5931@webber.adilger.int>
References: <200908241033.10527.Christian.Fischer@easterngraphics.com>
 <20090824133447.GH23677@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Christian Fischer <Christian.Fischer@easterngraphics.com>,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:64936 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbZHXSbc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Aug 2009 14:31:32 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n7OIVFeO018163
	for <linux-ext4@vger.kernel.org>; Mon, 24 Aug 2009 11:31:29 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KOW00L008R34B00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Mon,
 24 Aug 2009 11:31:15 -0700 (PDT)
In-reply-to: <20090824133447.GH23677@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 24, 2009  09:34 -0400, Theodore Ts'o wrote:
> On Mon, Aug 24, 2009 at 10:33:10AM +0200, Christian Fischer wrote:
> > I try to figure out reasonable mount options for ext4.
> > 
> > I've seen a "Enable asynchronous commits by default" patch from Sun, 21 Sep 
> > 2008.
> > 
> > Why is it revoked?
> 
> It patch was never merged because the ayschronous commits feature
> disabled all write barriers, so under heavy workloads a power failure
> could cause data loss.
> 
> No one has gotten around to looking at this closely; I think adding a
> strategically placed blkdev_issue_flush() will allow us to safely
> enable this feature, but it needs careful study.

I don't think that was the issue, but rather that we wanted to have
per-block checksums in order to handle the case were some block in
transaction A is causing a transaction checksum failure, yet transaction
B has already committed and begun checkpointing.

One option discussed was to add a lightweight 16-bit checksum (e.g. TCP
checksum) to the high bits of the t_flags of the block tag.  The checksum
doesn't have to be very strong since the whole-transaction checksum will
be the primary point of validation.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

