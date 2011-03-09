From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 4/4] e2fsck: Add QCOW2 support
Date: Wed, 9 Mar 2011 17:30:23 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1103091721120.5562@dhcp-27-109.brq.redhat.com>
References: <1298638173-25050-1-git-send-email-lczerner@redhat.com> <1298638173-25050-4-git-send-email-lczerner@redhat.com> <20110226164442.GD2924@thunk.org> <alpine.LFD.2.00.1103011103200.3874@dhcp-27-109.brq.redhat.com> <AANLkTikOzaC=rSReQx18xSBHAtY5rrQ0Ap22+pWgYsTy@mail.gmail.com>
 <alpine.LFD.2.00.1103071331250.5084@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Amir Goldstein <amir73il@gmail.com>, "Ted Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, sandeen@redhat.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56242 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755047Ab1CIQa3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Mar 2011 11:30:29 -0500
In-Reply-To: <alpine.LFD.2.00.1103071331250.5084@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--snip--
> > 
> > Did you consider the possibility to use QCOW2 format for doing a "tryout"
> > fsck on the filesystem with the option to rollback?
> > 
> > If QCOW2 image is created with the 'backing_file' option set to the origin
> > block device (and 'backing_fmt' is set to 'host_device'), then qemu-nbd
> > will be able to see the exported image metadata as well as the filesystem
> > data.
> > 
> > You can then do an "intrusive" fsck run on the NBD, mount your filesystem
> > (from the NBD) and view the results.
> > 
> > If you are satisfied with the results, you can apply the fsck changes to the
> > origin block device (there is probably a qemu-img command to do that).
> > If you are unsatisfied with the results, you can simply discard the image
> > or better yet, revert to a QCOW2 snapshot, which you created just before
> > running fsck.
> 
> But this is something you can do even now. You can mount the qcow2
> metadata image without any problems, you just will not see any data. But
> I can take a look at this functionality, it seems simple enough.

So I have done this and it works as expected as long as the device
you've created the image from is present in the system, which might not
be true, especially in the case you are transferring the image to the
another machine (bug report).

If the device with the same name as the original does not exist in the
system qemu-nbd is not smart enough to just ignore that fact and mount
the image anyway. And looking at the man page there is no way to do it.

So, the result is I am not going to include this into my patches (if
someone does not change my mind:)) as I do not want to create just-another
switch for e2image. Also I fail to see the benefit if it anyway:).

Thanks!
-Lukas


> 
> > 
> > Can you provide the performance figures for running fsck over NBD?
> 
> Well, unfortunately I do not have access to the same machine anymore,
> but I have simple results which has been done elsewhere, but due to lack
> of proper storage this has been done on loop device (should not affect
> raw and qcow2 results).
> 
> [+] fsck raw image
> real    0m30.176s
> user    0m22.397s
> sys     0m2.289s
> 
> [+] fsck NBD exported qcow2 image
> real    0m31.667s
> user    0m21.561s
> sys     0m3.293s
> 
> So you can see that performance here is a bit worse (5%).
> 
> Thanks!
> -Lukas
> 
--snip--
