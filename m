From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Far too long mount time
Date: Thu, 16 Aug 2012 03:09:53 -0600
Message-ID: <0F24AF1B-39C9-4300-862B-B9E84A21E34C@dilger.ca>
References: <CAAnFQG_O051svcCZftDefebVEds+P1zAceteh=B18HOqmoqitg@mail.gmail.com> <CAAnFQG9esXovsAYkCS5Lw5JGpc5dW2PLccvYjN7NvaHLQDqGmA@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Linux Ext4 Mailing List <linux-ext4@vger.kernel.org>
To: Javier Marcet <jmarcet@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:48540 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152Ab2HPJJz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Aug 2012 05:09:55 -0400
In-Reply-To: <CAAnFQG9esXovsAYkCS5Lw5JGpc5dW2PLccvYjN7NvaHLQDqGmA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-08-16, at 1:54 AM, Javier Marcet wrote:
> I'm in the process of setting up a new software raid with four 3TB disks.
> So far I'm doing the tests using also bcache on a 60GB partition on a 120GB
> SSD. Everything is protected by a UPS.
> 
> On the software side: self compiled kernel 3.5.1 and util-linux 2.20.1
> 
> Thus far, ext4 is doing really really well but for one thing, the mount
> time. At the moment I'm testing a RAID5 which makes the partition 8.2TB.
> 
> ext4 takes:
> $ time mount /mnt/raid
> 0.00s user 79.49s system 92% cpu 1:26.25 total
> 
> xfs, OTOH, is way faster:
> time mount /mnt/raid
> 0.00s user 0.01s system 0% cpu 1.869 total
> 
> I'v tried everything I could think of but the mount time remains constant.
> Is there anything I can do to speed up the mount time?

Did you format the filesystem with "mke2fs -t ext4"?  Without the "-t ext4" option, you won't get the "flex_bg" formatting option, which improves the layout of the filesystem metadata, and definitely reduces mount times.

It is a bit strange that _mounting_ uses 92% CPU.  Hmm, there was a bug
reported for 3.5.1, see "Re: Upgraded from 3.4 to 3.5.1 kernel: machine
does not boot", and reverting the patch with git commit hash
"8aeb00ff85ad25453765dd339b408c0087db1527" resolved the problem.  This
slowdown was only seen with larger devices.

Cheers, Andreas





