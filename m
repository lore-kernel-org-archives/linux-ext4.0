From: Stefan Hajnoczi <stefanha@gmail.com>
Subject: Re: VMs are pausing with ENOSPC
Date: Mon, 11 Nov 2013 10:43:29 +0100
Message-ID: <20131111094329.GF28264@stefanha-thinkpad.redhat.com>
References: <1383912032.27016.4.camel@pc.interlinx.bc.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kvm@vger.kernel.org, "Brian J. Murrell" <brian@interlinx.bc.ca>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ea0-f180.google.com ([209.85.215.180]:49038 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831Ab3KKJnd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Nov 2013 04:43:33 -0500
Content-Disposition: inline
In-Reply-To: <1383912032.27016.4.camel@pc.interlinx.bc.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 08, 2013 at 07:00:32AM -0500, Brian J. Murrell wrote:
> On RHEL 6.4 I have a number of kvms using qemu raw disks.  They are all
> on a filesystem which has reached 500G (of 1TB) of usage.  None of the
> qemu images are full as reported by qemu-img info.  Yet my VMs are all
> pausing with:
> 
> block I/O error in device 'drive-virtio-disk0': No space left on device (28)
> 
> in their logs
> i.e.: # qemu-img info /var/lib/libvirt/images/mgmt1-disk0 
> image: /var/lib/libvirt/images/mgmt1-disk0
> file format: raw
> virtual size: 120G (128849018880 bytes)
> disk size: 52G
> 
> and:
> 
> # df -h /var/lib/libvirt/images/
> Filesystem Size Used Avail Use% Mounted on
> /dev/mapper/vg_00-virt--images 1.0T 500G 473G 52% /var/lib/libvirt/images

Added linux-ext4 mailing list and more info from an IRC debugging
session with Brian:

The image file is on an ext4 file system.  The QEMU userspace process is
performing a pwritev() system call that fails with ENOSPC.

The particular pwritev() that failed had ~600 iovecs covering about 2.4
MB of data.  The file is opened O_DIRECT.

The VMs are all hitting ENOSPC when they write to the file system but
df(1) shows there should still be 48% (~473 GB) available.

Any ideas why writes produce ENOSPC on an ext4 file system with
sufficient space free?

Stefan
