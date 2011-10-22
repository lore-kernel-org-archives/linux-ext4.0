From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Bug In ext4 in kernels > 2.6.39 - Not mounting with
 arguments/options I specify in fstab on root remount
Date: Sat, 22 Oct 2011 01:00:31 -0400
Message-ID: <20111022050031.GC4196@thunk.org>
References: <4E6F1B49.3010803@gmail.com>
 <CABeR262=5V1wuXPDVr_qLTeFTc4zDSFKVYKvO_+1w60XmwJvKA@mail.gmail.com>
 <4E6F6D89.5040905@redhat.com>
 <CABeR260PEDEF1cyX5JPs3VC0hpThmKNtDAhDd-sPDZ2grtL+=g@mail.gmail.com>
 <20111009234433.GU7948@thunk.org>
 <4EA0E72D.8020305@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Matt Parnell <mparnell@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:51263 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751883Ab1JVHtQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 22 Oct 2011 03:49:16 -0400
Content-Disposition: inline
In-Reply-To: <4EA0E72D.8020305@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 20, 2011 at 10:29:49PM -0500, Matt Parnell wrote:
> The output of /proc/cmdline on 3.0.7:
> 
> BOOT_IMAGE=/boot/vmlinuz26-zen root=/dev/sdb1 ro rootfstype=ext4
> rootflags=data=writeback noatime nodiratime barrier=0 discard
> noinitrd
> 
> 
> On 10/09/2011 06:44 PM, Ted Ts'o wrote:
> >On Sun, Oct 09, 2011 at 05:10:54PM -0500, Matt Parnell wrote:
> >>/proc/mounts (as you can see it's not being remounted rw for some
> >>reason - /dev/sdc1 is the flash drive I used to pipe this info onto):
> >>
> >>rootfs / rootfs rw 0 0
> >>/dev/root / ext4 ro,relatime,barrier=1 0 0

I haven't had a chance to check on v3.0 (I'm currently travelling and
penning this from an airplane), but on v3.1-rc3, it works for me under
KVM.  I fire up kvm-qemu this way:

$QEMU -enable-kvm -boot order=c $NET \
      -drive file=$ROOT_QCOW2,if=virtio$SNAPSHOT \
      -drive file=$VDB,cache=none,if=virtio \
      -drive file=$VDC,cache=none,if=virtio \
      -drive file=$VDD,cache=none,if=virtio \
      -nographic -smp $NR_CPU -m $MEM \
      --kernel $KERNEL \
      --append "root=/dev/vda console=ttyS0,115200 rootflags=data=writeback" |\
tee $LOGFILE

with this in /proc/cmdline:

candygram:~# cat /proc/cmdline 
root=/dev/vda console=ttyS0,115200 rootflags=data=writeback maint

... and this is what I have in /proc/mounts:

candygram:~# head -2 /proc/mounts
rootfs / rootfs rw 0 0
/dev/root / ext4 rw,noatime,user_xattr,acl,barrier=1,data=writeback 0 0

... and what I have in /etc/fstab:

UUID=ce4d6b98-2aa9-42d4-a127-995a795a0b02	/	ext4    noatime,data=writeback 0 1

The kvm image I'm using is using Debian unstable image generated using
debootstrap, and uses no modules or initrd's --- which makes it easier
for me to boot since $KERNEL is set to:

    /tyt/linux/ext4/arch/x86/boot/bzImage

This allows me to fire up test kernel right from my build tree,
without needing to set up any kind of initrd nonsense.  :-)

		       	      	      	     		- Ted
