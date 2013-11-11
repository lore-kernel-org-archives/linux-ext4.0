From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: VMs are pausing with ENOSPC
Date: Mon, 11 Nov 2013 13:17:16 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1311111311440.2620@localhost.localdomain>
References: <1383912032.27016.4.camel@pc.interlinx.bc.ca> <20131111094329.GF28264@stefanha-thinkpad.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, kvm@vger.kernel.org,
	"Brian J. Murrell" <brian@interlinx.bc.ca>
To: Stefan Hajnoczi <stefanha@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10370 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753287Ab3KKMRf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Nov 2013 07:17:35 -0500
In-Reply-To: <20131111094329.GF28264@stefanha-thinkpad.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I think that you should consider filing a ticket with your Red Hat
support for this issue to make sure it gets fixed quickly.

Thanks!
-Lukas

On Mon, 11 Nov 2013, Stefan Hajnoczi wrote:

> Date: Mon, 11 Nov 2013 10:43:29 +0100
> From: Stefan Hajnoczi <stefanha@gmail.com>
> To: linux-ext4@vger.kernel.org
> Cc: kvm@vger.kernel.org, Brian J. Murrell <brian@interlinx.bc.ca>
> Subject: Re: VMs are pausing with ENOSPC
> 
> On Fri, Nov 08, 2013 at 07:00:32AM -0500, Brian J. Murrell wrote:
> > On RHEL 6.4 I have a number of kvms using qemu raw disks.  They are all
> > on a filesystem which has reached 500G (of 1TB) of usage.  None of the
> > qemu images are full as reported by qemu-img info.  Yet my VMs are all
> > pausing with:
> > 
> > block I/O error in device 'drive-virtio-disk0': No space left on device (28)
> > 
> > in their logs
> > i.e.: # qemu-img info /var/lib/libvirt/images/mgmt1-disk0 
> > image: /var/lib/libvirt/images/mgmt1-disk0
> > file format: raw
> > virtual size: 120G (128849018880 bytes)
> > disk size: 52G
> > 
> > and:
> > 
> > # df -h /var/lib/libvirt/images/
> > Filesystem Size Used Avail Use% Mounted on
> > /dev/mapper/vg_00-virt--images 1.0T 500G 473G 52% /var/lib/libvirt/images
> 
> Added linux-ext4 mailing list and more info from an IRC debugging
> session with Brian:
> 
> The image file is on an ext4 file system.  The QEMU userspace process is
> performing a pwritev() system call that fails with ENOSPC.
> 
> The particular pwritev() that failed had ~600 iovecs covering about 2.4
> MB of data.  The file is opened O_DIRECT.
> 
> The VMs are all hitting ENOSPC when they write to the file system but
> df(1) shows there should still be 48% (~473 GB) available.
> 
> Any ideas why writes produce ENOSPC on an ext4 file system with
> sufficient space free?
> 
> Stefan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
