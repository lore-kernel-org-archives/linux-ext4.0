From: Andreas Dilger <adilger@sun.com>
Subject: Re: EXT4 is ~2X as slow as XFS (593MB/s vs 304MB/s) for writes?
Date: Mon, 01 Mar 2010 01:39:18 -0700
Message-ID: <832C6227-BF34-43C2-8768-1308C00AB17F@sun.com>
References: <alpine.DEB.2.00.1002261922010.8247@p34.internal.lan>
 <4B886CA1.9050906@redhat.com>
 <alpine.DEB.2.00.1002262006000.8247@p34.internal.lan>
 <4B887160.2090606@redhat.com> <4B887548.50508@redhat.com>
 <alpine.DEB.2.00.1002270513280.17433@p34.internal.lan>
 <alpine.DEB.2.00.1002270550330.17433@p34.internal.lan>
 <alpine.DEB.2.00.1002270607020.17433@p34.internal.lan>
 <alpine.DEB.2.00.1002270634200.17433@p34.internal.lan>
 <20100228054240.GE14646@thunk.org>
 <alpine.DEB.2.00.1002280628550.22822@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: tytso@mit.edu, Eric Sandeen <sandeen@redhat.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Alan Piszcz <ap@solarrain.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:34726 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab0CAIjY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Mar 2010 03:39:24 -0500
In-reply-to: <alpine.DEB.2.00.1002280628550.22822@p34.internal.lan>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-02-28, at 07:55, Justin Piszcz wrote:
> === CREATE RAID-0 WITH 11 DISKS


Have you tried testing with "nice" numbers of disks in your RAID set  
(e.g. 8 disks for RAID-0, 9 for RAID-5, 10 for RAID-6)?  The mballoc  
code is really much better tuned for power-of-two sized allocations.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

