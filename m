From: Jamie Lokier <jamie@shareable.org>
Subject: Re: Plans to evaluate the reliability and integrity of ext4 against power failures.
Date: Thu, 2 Jul 2009 03:12:19 +0100
Message-ID: <20090702021219.GA18372@shareable.org>
References: <d1c7fadd0906301627v44fa4a23x6b60726f8ce672c1@mail.gmail.com> <f3177b9e0907011107q17507be5icae2c1105faf4800@mail.gmail.com> <532480950907011131o7e9fc8bdn64002f130cc9615d@mail.gmail.com> <4A4BAEA2.6000101@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Michael Rubin <mrubin@google.com>,
	Chris Worley <worleys@gmail.com>,
	Shaozhi Ye <yeshao@google.com>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail2.shareable.org ([80.68.89.115]:33295 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755889AbZGBCMU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Jul 2009 22:12:20 -0400
Content-Disposition: inline
In-Reply-To: <4A4BAEA2.6000101@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ric Wheeler wrote:
> One way to test this with reasonable, commodity hardware would be 
> something like the following:
> 
> (1) Get an automated power kill setup to control your server

etc.  Good plan.

Another way to test the entire software stack, but not the physical
disks, is to run the entire test using VMs, and simulate hard disk
write caching and simulated power failure in the VM.  KVM would be a
great candidate for that, as it runs VMs as ordinary processes and the
disk I/O emulation is quite easy to modify.

As most issues probably are software issues (kernel, filesystems, apps
not calling fsync, or assuming barrierless O_DIRECT/O_DSYNC are
sufficient, network fileserver protocols, etc.), it's surely worth a look.

It could be much faster than the physical version too, in other words
more complete testing of the software stack given available resources.

With the ability to "fork" a running VM's state by snapshotting it and
continuing, it would even be possible to simulate power failure cache
loss scenarios at many points in the middle of a stress test, with the
stress test continuing to run - no full reboot needed at every point.
That way, maybe deliberate trace points could be placed in the
software stack at places where power failure cache loss seems likely
to cause a problem.

-- Jamie
