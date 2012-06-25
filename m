From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: Kernel 3.3.8 breaks accidental ext3 mount of extended partition
Date: Mon, 25 Jun 2012 12:34:57 +0100
Message-ID: <20120625113457.GA1289@amd.home.annexia.org>
References: <4FDEC3C2.4060909@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jmoyer@redhat.com, linux-ext4@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
To: Torsten Hilbrich <torsten.hilbrich@secunet.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64620 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863Ab2FYLfE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Jun 2012 07:35:04 -0400
Content-Disposition: inline
In-Reply-To: <4FDEC3C2.4060909@secunet.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 18, 2012 at 07:59:30AM +0200, Torsten Hilbrich wrote:
> Hello,
> 
> a software that tries to mount each existing partition as ext3 file system started to fail when updating from v3.3.7 to v3.3.8.
> 
> The applications then hangs-up in the mount syscall, here is a snapshot of its stack at this moment:

We just ran into what we think is the same problem.

Note that ext4 fails like this for any 1024 byte sized filesystem (of
zeroes) that you try to mount.  It's really nothing to do with
extended partitions.

Here is a very simple reproducer + stack trace:

  https://bugzilla.redhat.com/show_bug.cgi?id=835019#c4

I will try out the patch suggested later on in this thread.

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
virt-p2v converts physical machines to virtual machines.  Boot with a
live CD or over the network (PXE) and turn machines into Xen guests.
http://et.redhat.com/~rjones/virt-p2v
