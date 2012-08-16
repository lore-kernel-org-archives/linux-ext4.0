From: Calvin Walton <calvin.walton@kepstin.ca>
Subject: Re: Far too long mount time
Date: Thu, 16 Aug 2012 10:16:48 -0400
Message-ID: <1345126608.22142.59.camel@cwalton-XPS-8300>
References: <CAAnFQG_O051svcCZftDefebVEds+P1zAceteh=B18HOqmoqitg@mail.gmail.com>
	 <CAAnFQG9esXovsAYkCS5Lw5JGpc5dW2PLccvYjN7NvaHLQDqGmA@mail.gmail.com>
	 <0F24AF1B-39C9-4300-862B-B9E84A21E34C@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Javier Marcet <jmarcet@gmail.com>,
	Linux Ext4 Mailing List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:64386 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932538Ab2HPOQ3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Aug 2012 10:16:29 -0400
Received: by qcro28 with SMTP id o28so2124507qcr.19
        for <linux-ext4@vger.kernel.org>; Thu, 16 Aug 2012 07:16:28 -0700 (PDT)
In-Reply-To: <0F24AF1B-39C9-4300-862B-B9E84A21E34C@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2012-08-16 at 03:09 -0600, Andreas Dilger wrote:
> On 2012-08-16, at 1:54 AM, Javier Marcet wrote:
> > I'm in the process of setting up a new software raid with four 3TB disks.
> > So far I'm doing the tests using also bcache on a 60GB partition on a 120GB
> > SSD. Everything is protected by a UPS.
> > 
> > On the software side: self compiled kernel 3.5.1 and util-linux 2.20.1
> > 
> > Thus far, ext4 is doing really really well but for one thing, the mount
> > time. At the moment I'm testing a RAID5 which makes the partition 8.2TB.
> > 
> > ext4 takes:
> > $ time mount /mnt/raid
> > 0.00s user 79.49s system 92% cpu 1:26.25 total

> It is a bit strange that _mounting_ uses 92% CPU.  Hmm, there was a bug
> reported for 3.5.1, see "Re: Upgraded from 3.4 to 3.5.1 kernel: machine
> does not boot", and reverting the patch with git commit hash
> "8aeb00ff85ad25453765dd339b408c0087db1527" resolved the problem.  This
> slowdown was only seen with larger devices.

I've been seeing this as well, the symptom being the boot time on my
computer going from <5s to ~20s while my 6TB ext4 filesystem mounts.
I'll try reverting this patch; hopefully that helps.

Is there any fix for this issue queued up for an upcoming stable
release? It still reverts cleanly on 3.5.2.

-- 
Calvin Walton <calvin.walton@kepstin.ca>

