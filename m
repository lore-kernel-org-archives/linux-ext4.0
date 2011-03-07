From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 4/4] e2fsck: Add QCOW2 support
Date: Mon, 7 Mar 2011 13:40:32 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1103071331250.5084@dhcp-27-109.brq.redhat.com>
References: <1298638173-25050-1-git-send-email-lczerner@redhat.com> <1298638173-25050-4-git-send-email-lczerner@redhat.com> <20110226164442.GD2924@thunk.org> <alpine.LFD.2.00.1103011103200.3874@dhcp-27-109.brq.redhat.com>
 <AANLkTikOzaC=rSReQx18xSBHAtY5rrQ0Ap22+pWgYsTy@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1671297533-1299501635=:5084"
Cc: Lukas Czerner <lczerner@redhat.com>, "Ted Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, sandeen@redhat.com
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41760 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927Ab1CGMki (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Mar 2011 07:40:38 -0500
In-Reply-To: <AANLkTikOzaC=rSReQx18xSBHAtY5rrQ0Ap22+pWgYsTy@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1671297533-1299501635=:5084
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Mon, 7 Mar 2011, Amir Goldstein wrote:

> On Tue, Mar 1, 2011 at 1:42 PM, Lukas Czerner <lczerner@redhat.com> wrote:
> > On Sat, 26 Feb 2011, Ted Ts'o wrote:
> >
> >> On Fri, Feb 25, 2011 at 01:49:33PM +0100, Lukas Czerner wrote:
> >> > This commit adds QCOW2 support for e2fsck. In order to avoid creating
> >> > real QCOW2 image support, which would require creating a lot of code, we
> >> > simply bypass the problem by converting the QCOW2 image into raw image
> >> > and than let e2fsck work with raw image. Conversion itself can be quite
> >> > fast, so it should not be a serious slowdown.
> >> >
> >> > Add '-Q' option to specify path for the raw image. It not specified the
> >> > raw image will be saved in /tmp direcotry in format
> >> > <qcow2_filename>.raw.XXXXXX, where X chosen randomly.
> >> >
> >> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> >>
> >> If we're just going to convert the qcow2 image into a raw image, that
> >> means that if someone sends us a N gigabyte QCOW2 image, it will lots
> >> of time (I'm not sure I agree with the "quite fast part"), and consume
> >> an extra N gigabytes of free space to create the raw image.
> >>
> >> In that case, I'm not so sure we really want to have a -Q option to
> >> e2fsck.  We might be better off simply forcing the use of e2image to
> >> convert the image back.
> >>
> >> Note that the other reason why it's a lot better to be able to allow
> >> e2fsck to be able to work on the raw image directly is that if a
> >> customer sends a qcow2's metadata-only image from their 3TB raid
> >> array, we won't be able to expand that to a raw image because of
> >> ext2/3/4's 2TB maximum file size limit.  The qcow2 image might be only
> >> a few hundreds of megabytes, so being able to have e2fsck operate on
> >> that image directly would be a huge win.
> >>
> >> Adding iomanager support would also allow debugfs to access the qcow2
> >> image directly --- also a win.
> >>
> >> Whether or not we add the io_manager support right away (eventually I
> >> think it's a must have feature), I don't think having a "decompress a
> >> qcow2 image to a sparse raw image" makes sense as an explicit e2fsck
> >> option.  It just clutters up the e2fsck option space, and people might
> >> be confused because now e2fsck could break because there wasn't enough
> >> free space to decompress the raw image.  Also, e2fsck doesn't delete
> >> the /tmp file afterwards, which is bad --- but if it takes a large
> >> amount of time to create the raw image, deleting afterwards is a bit
> >> of waste as well.  Probably better to force the user to manage the
> >> converted raw file system image.
> >>
> >>                                       - Ted
> >>
> >
> > Hi Ted,
> >
> > sorry for late answer, but I was running some benchmarks to have some
> > numbers to throw at you :). Now let's see how "qite fast" it actually is
> > in comparison:
> >
> > I have 6TB raid composed of four drives and I flooded it with lots and
> > lots of files (copying /usr/share over and over again) and even created
> > some big files (1M, 20M, 1G, 10G) so the number of used inodes on the
> > filesystem is 10928139. I am using e2fsck form top of the master branch.
> >
> > Before each step I run:
> > sync; echo 3 > /proc/sys/vm/drop_caches
> >
> > exporting raw image:
> > time .//misc/e2image -r /dev/mapper/vg_raid-lv_stripe image.raw
> >
> >        real    12m3.798s
> >        user    2m53.116s
> >        sys     3m38.430s
> >
> >        6,0G    image.raw
> >
> > exporting qcow2 image
> > time .//misc/e2image -Q /dev/mapper/vg_raid-lv_stripe image.qcow2
> > e2image 1.41.14 (22-Dec-2010)
> >
> >        real    11m55.574s
> >        user    2m50.521s
> >        sys     3m41.515s
> >
> >        6,1G    image.qcow2
> >
> > So we can see that the running time is essentially the same, so there is
> > no crazy overhead in creating qcow2 image. Note that qcow2 image is
> > slightly bigger because of all the qcow2 related metadata and it's size
> > really depends on the size of the device. Also I tried to see how long
> > does it take to export bzipped2 raw image, but it is running almost one
> > day now, so it is not even comparable.
> >
> > e2fsck on the device:
> > time .//e2fsck/e2fsck -fn /dev/mapper/vg_raid-lv_stripe
> >
> >        real    3m9.400s
> >        user    0m47.558s
> >        sys     0m15.098s
> >
> > e2fsck on the raw image:
> > time .//e2fsck/e2fsck -fn image.raw
> >
> >        real    2m36.767s
> >        user    0m47.613s
> >        sys     0m8.403s
> >
> > We can see that e2fsck on the raw image is a bit faster, but that is
> > obvious since the drive does not have to seek so much (right?).
> >
> > Now converting qcow2 image into raw image:
> > time .//misc/e2image -r image.qcow2 image.qcow2.raw
> >
> >        real    1m23.486s
> >        user    0m0.704s
> >        sys     0m22.574s
> >
> > It is hard to say if it is "quite fast" or not. But I would say it is
> > not terribly slow either. Just out of curiosity, I have tried to convert
> > raw->qcow2 with qemu-img convert tool:
> >
> > time qemu-img convert -O raw image.qcow2 image.qemu.raw
> > ..it is running almost an hour now, so it is not comparable as well :)
> >
> > e2fsck on the qcow2 image.
> > time .//e2fsck/e2fsck -fn -Q ./image.qcow2.img.tmp image.qcow2
> >
> >        real    2m47.256s
> >        user    0m41.646s
> >        sys     0m28.618s
> >
> > Now that is surprising. Well, not so much actually.. We can see that
> > e2fsck check on the qcow2 image, including qcow2->raw conversion is a
> > bit slower than checking raw image (by 7% which is not much) but it is
> > still faster than checking device itself. Now, the reason is probably
> > that the raw image we are creating is partially loaded into memory, hence
> > accelerate e2fsck. So I do not think that converting image before check
> > is such a bad idea (especially when you have enough memory:)).
> >
> > I completely agree that having io_manager for the qcow2 format would be
> > cool, if someone is willing to do that, but I am not convinced that it
> > is worth it. Your concerns are all valid and I agree, however I do not
> > think e2image is used by regular unexperienced users, so it should not
> > confuse them, but that is just stupid assumption :).
> >
> > Also, remember that if you really do not want to convert the image
> > because of file size limit, or whatever, you can always use qemu-nbd to
> > attach qcow2 image into nbd block device and use that as regular device.
> 
> Did you consider the possibility to use QCOW2 format for doing a "tryout"
> fsck on the filesystem with the option to rollback?
> 
> If QCOW2 image is created with the 'backing_file' option set to the origin
> block device (and 'backing_fmt' is set to 'host_device'), then qemu-nbd
> will be able to see the exported image metadata as well as the filesystem
> data.
> 
> You can then do an "intrusive" fsck run on the NBD, mount your filesystem
> (from the NBD) and view the results.
> 
> If you are satisfied with the results, you can apply the fsck changes to the
> origin block device (there is probably a qemu-img command to do that).
> If you are unsatisfied with the results, you can simply discard the image
> or better yet, revert to a QCOW2 snapshot, which you created just before
> running fsck.

But this is something you can do even now. You can mount the qcow2
metadata image without any problems, you just will not see any data. But
I can take a look at this functionality, it seems simple enough.

> 
> Can you provide the performance figures for running fsck over NBD?

Well, unfortunately I do not have access to the same machine anymore,
but I have simple results which has been done elsewhere, but due to lack
of proper storage this has been done on loop device (should not affect
raw and qcow2 results).

[+] fsck raw image
real    0m30.176s
user    0m22.397s
sys     0m2.289s

[+] fsck NBD exported qcow2 image
real    0m31.667s
user    0m21.561s
sys     0m3.293s

So you can see that performance here is a bit worse (5%).

Thanks!
-Lukas

> 
> >
> > Regarding the e2fsck and the qcow2 support (or -Q option), I think it is
> > useful, but I do not really insist on keeping it and as you said we can
> > always force user to use e2image for conversion. It is just, this way it
> > seems easier to do it automatically. Maybe we can ask user whether he
> > wants to keep the raw image after the check or not ?
> >
> > Regaring separate qcow2.h file and "qcow2_" prefix. I have done this
> > because I am using this code from e2image and e2fsck so it seemed
> > convenient to have it in separate header, however I guess I can move it
> > into e2image.c and e2image.h if you want.
> >
> > So what do you think.
> >
> > Thanks!
> > -Lukas
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 

-- 
--8323328-1671297533-1299501635=:5084--
