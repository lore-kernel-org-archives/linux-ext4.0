From: Jan Kara <jack@suse.cz>
Subject: Re: VMs are pausing with ENOSPC
Date: Mon, 11 Nov 2013 13:22:49 +0100
Message-ID: <20131111122249.GA22408@quack.suse.cz>
References: <1383912032.27016.4.camel@pc.interlinx.bc.ca>
 <20131111094329.GF28264@stefanha-thinkpad.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, kvm@vger.kernel.org,
	"Brian J. Murrell" <brian@interlinx.bc.ca>
To: Stefan Hajnoczi <stefanha@gmail.com>
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131111094329.GF28264@stefanha-thinkpad.redhat.com>
Sender: kvm-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon 11-11-13 10:43:29, Stefan Hajnoczi wrote:
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
  OK, likely a bug in RHEL 6.4 kernel. But since that is 2.6.32 with lots
of patches, I suggest you contact RHEL support to debug that further.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
