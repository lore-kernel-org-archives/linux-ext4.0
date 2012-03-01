From: Chris Mason <chris.mason@oracle.com>
Subject: Re: getdents - ext4 vs btrfs performance
Date: Thu, 1 Mar 2012 09:18:23 -0500
Message-ID: <20120301141823.GV5054@shiny>
References: <CADDYkjS5VJeYyHzqumazQ0qKg+HwA6GO+zYSJj7rkHNZFwjcoQ@mail.gmail.com>
 <CADDYkjRni4i3QvWo+hOn-Ct4mFoTpL1-ydmE7fbzYJmHFhS3_Q@mail.gmail.com>
 <CADDYkjRYrKaBvTQ4Pe6bfemL7r5W=AU468uy0krFAEJD45syow@mail.gmail.com>
 <20120229144244.GF5054@shiny>
 <CADDYkjSEcktUYS+FzoEQ-FH1yMCvq4as5S2LoJyQBPM9=+CoTw@mail.gmail.com>
 <CADDYkjQ-N2+2sJMb9=DZt1vr1=nWkCCdXB2xJAPgkhAuguEPyg@mail.gmail.com>
 <CAJd=RBAs3KGVO8hdUY3peoG1JuxU7_SZ4Z=H0Uy43wLpUFkh7g@mail.gmail.com>
 <CADDYkjR+d+pFYN-mQ91ZP4KcU4zzwC5jmxj1xxMDrp+X+Z8c6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Hillf Danton <dhillf@gmail.com>, linux-ext4@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org,
	lczerner@redhat.com
To: Jacek Luczak <difrost.kernel@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:36172 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896Ab2CAOSa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Mar 2012 09:18:30 -0500
Content-Disposition: inline
In-Reply-To: <CADDYkjR+d+pFYN-mQ91ZP4KcU4zzwC5jmxj1xxMDrp+X+Z8c6g@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 01, 2012 at 03:03:53PM +0100, Jacek Luczak wrote:
> 2012/3/1 Hillf Danton <dhillf@gmail.com>:
> > On Thu, Mar 1, 2012 at 9:35 PM, Jacek Luczak <difrost.kernel@gmail.com> wrote:
> >>
> >> While I was about to grab acp I've noticed seekwatcher with made my day :)
> >>
> >> seekwatcher run of tar cf to eliminate writes (all done on 3.2.7):
> >> 1) btrfs: http://dozzie.jarowit.net/~dozzie/luczajac/tar_btrfs.png
> >> 2) ext4: http://dozzie.jarowit.net/~dozzie/luczajac/tar_ext4.png
> >> 3) both merged: http://dozzie.jarowit.net/~dozzie/luczajac/tar_btrfs_ext4.png

Whoa, seekwatcher makes it pretty clear.

> >>
> >> I will send acp results soon.
> >>
> > Would you please take reiserfs into account?
> 
> As of now not (lack of time) but I'm pretty close to consider XFS in
> the game. Whenever I will have more time and there won't be a pressure
> on giving host back to production I will redo same tests for reiserfs.
> 
> Now I'm focused on the userspace sorting results.

reiserfs should have results very similar to ext4.  The directory
hashing used by reiserfs is going to result in a very random read
pattern.

XFS will probably beat btrfs in this test.  Their directory indexes
reflect on disk layout very well.

-chris
