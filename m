From: Kalpak Shah <kalpak@clusterfs.com>
Subject: Re: [RFC][PATCH] Multiple mount protection
Date: Tue, 22 May 2007 13:36:16 +0530
Message-ID: <1179821176.4797.15.camel@garfield>
References: <1179777153.3910.13.camel@garfield>
	 <4652987D.70209@clusterfs.com> <1179819282.4797.9.camel@garfield>
	 <4652A192.9010506@clusterfs.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@clusterfs.com>
To: Manoj Joseph <manoj@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:48261 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754914AbXEVICi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 May 2007 04:02:38 -0400
In-Reply-To: <4652A192.9010506@clusterfs.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2007-05-22 at 13:23 +0530, Manoj Joseph wrote:
> Kalpak Shah wrote:
> 
> >> Also, I am curious about this. Is there a test case for mounting the 
> >> same filesystem multiple times? Does this use different paths to reach 
> >> the device? Or is there a race? Or does it happen on a device shared by 
> >> multiple hosts?
> >>
> > 
> > If you are using some HA software, there is the possibility of a race.
> > Yes it can happen on a device shared by multiple hosts.
> 
> Ah, if the HA-software doesn't deal with multiple mounts for filesystems 
> it is managing, then I would claim that the software is flawed. :)

Well, it is known to happen so it wouldn't be bad to make sure.

> 
> But yes, turning on MMP would help.
> 
> It might also help to make the frequency at which sequence number gets 
> updated (currently 5 sec) tunable. Would making that also a field in the 
> super block be a bad idea (set only by mkfs/tunefs)?

Updating the MMP sequence too often would hurt the filesystem
performance.

> 
> It might also be worthwhile to write the dev_t, the path of the device 
> and the hostname to the s_mmp_block, along with the random sequence. (I 
> assume there is enough space.) If the mount is being failed because of a 
> multiple mount  scenario, these fields could be used to provide useful 
> diagnostics.

Yes, the dev_t, host name, the sequence and the time last updated would
all be printed. There is lots of space since we have an entire block.

> My $ 0.02. :)

Thanks. :)

> 
> Regards,
> Manoj
