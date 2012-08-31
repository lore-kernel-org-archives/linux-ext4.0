From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Kernel panic from corrupt journal
Date: Fri, 31 Aug 2012 01:53:49 -0400
Message-ID: <20120831055349.GA18086@thunk.org>
References: <20120830092212.GB12981@nsrc.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Brian Candler <B.Candler@pobox.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48043 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120Ab2HaFxy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 31 Aug 2012 01:53:54 -0400
Content-Disposition: inline
In-Reply-To: <20120830092212.GB12981@nsrc.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 30, 2012 at 10:22:12AM +0100, Brian Candler wrote:
> I have a system where just replaying the journal causes a kernel panic. If I
> boot into recovery mode and then type
> 
> With "debugfs /dev/sda8", then:
> 
>     logdump /tmp/sda8.dmp      -> this works OK, writes out a list of blocks
>     logdump -ac /tmp/sda8.dmp  -> this also causes a kernel panic!

I'm going to guess that there is some kind of hardware failure which
is returning an I/O error that the device driver can't handle, and so
you're getting a kernel panic.  That's because if you get it while
accessing the data blocks on the disk which contains the journal from
a userspace program such as debugfs, there is no ext4 kernel code
which is involved.

Taking a screen shot with the scratch information is useful, but it
will almost certainly (especially when you are running the journal via
e2fsck or debugfs) show a kernel strack trace that doesn't involve the
ext4 code paths at all.

> (1) the fact that I can cause a kernel panic is a bug, and if I can help fix
> it I will; however I'm not sure how I can pass on any useful information
> given that even dumping the journal causes a kernel panic.  Can I get the
> journal by dd'ing at a specific offset?
> 
> (2) I'd also like to be able to recover this filesystem, e.g. by clearing
> the journal, but I haven't been able to find out how to do this.

What kind of device is /dev/sda?  You might want to try removing the
disk and connecting it to another computer, and then copying the
entire disk image to a new disk using dd_rescue (which will create a
block-by-block copy of the disk image).  You could try copying the
disk using dd_rescue on your current computer. but it will almost
certainly crash as well.  It seems likely that the mere act of trying
to read the data block in question is causing an I/O error which is
causing the device driver to crash.

Regards,

							- Ted
