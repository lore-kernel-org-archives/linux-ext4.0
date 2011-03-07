From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 4/4] e2fsck: Add QCOW2 support
Date: Mon, 7 Mar 2011 12:40:01 +0200
Message-ID: <AANLkTikOzaC=rSReQx18xSBHAtY5rrQ0Ap22+pWgYsTy@mail.gmail.com>
References: <1298638173-25050-1-git-send-email-lczerner@redhat.com>
	<1298638173-25050-4-git-send-email-lczerner@redhat.com>
	<20110226164442.GD2924@thunk.org>
	<alpine.LFD.2.00.1103011103200.3874@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Ted Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	sandeen@redhat.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34614 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755798Ab1CGKkD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Mar 2011 05:40:03 -0500
Received: by ywj3 with SMTP id 3so1559674ywj.19
        for <linux-ext4@vger.kernel.org>; Mon, 07 Mar 2011 02:40:02 -0800 (PST)
In-Reply-To: <alpine.LFD.2.00.1103011103200.3874@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 1, 2011 at 1:42 PM, Lukas Czerner <lczerner@redhat.com> wro=
te:
> On Sat, 26 Feb 2011, Ted Ts'o wrote:
>
>> On Fri, Feb 25, 2011 at 01:49:33PM +0100, Lukas Czerner wrote:
>> > This commit adds QCOW2 support for e2fsck. In order to avoid creat=
ing
>> > real QCOW2 image support, which would require creating a lot of co=
de, we
>> > simply bypass the problem by converting the QCOW2 image into raw i=
mage
>> > and than let e2fsck work with raw image. Conversion itself can be =
quite
>> > fast, so it should not be a serious slowdown.
>> >
>> > Add '-Q' option to specify path for the raw image. It not specifie=
d the
>> > raw image will be saved in /tmp direcotry in format
>> > <qcow2_filename>.raw.XXXXXX, where X chosen randomly.
>> >
>> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
>>
>> If we're just going to convert the qcow2 image into a raw image, tha=
t
>> means that if someone sends us a N gigabyte QCOW2 image, it will lot=
s
>> of time (I'm not sure I agree with the "quite fast part"), and consu=
me
>> an extra N gigabytes of free space to create the raw image.
>>
>> In that case, I'm not so sure we really want to have a -Q option to
>> e2fsck. =A0We might be better off simply forcing the use of e2image =
to
>> convert the image back.
>>
>> Note that the other reason why it's a lot better to be able to allow
>> e2fsck to be able to work on the raw image directly is that if a
>> customer sends a qcow2's metadata-only image from their 3TB raid
>> array, we won't be able to expand that to a raw image because of
>> ext2/3/4's 2TB maximum file size limit. =A0The qcow2 image might be =
only
>> a few hundreds of megabytes, so being able to have e2fsck operate on
>> that image directly would be a huge win.
>>
>> Adding iomanager support would also allow debugfs to access the qcow=
2
>> image directly --- also a win.
>>
>> Whether or not we add the io_manager support right away (eventually =
I
>> think it's a must have feature), I don't think having a "decompress =
a
>> qcow2 image to a sparse raw image" makes sense as an explicit e2fsck
>> option. =A0It just clutters up the e2fsck option space, and people m=
ight
>> be confused because now e2fsck could break because there wasn't enou=
gh
>> free space to decompress the raw image. =A0Also, e2fsck doesn't dele=
te
>> the /tmp file afterwards, which is bad --- but if it takes a large
>> amount of time to create the raw image, deleting afterwards is a bit
>> of waste as well. =A0Probably better to force the user to manage the
>> converted raw file system image.
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 - Ted
>>
>
> Hi Ted,
>
> sorry for late answer, but I was running some benchmarks to have some
> numbers to throw at you :). Now let's see how "qite fast" it actually=
 is
> in comparison:
>
> I have 6TB raid composed of four drives and I flooded it with lots an=
d
> lots of files (copying /usr/share over and over again) and even creat=
ed
> some big files (1M, 20M, 1G, 10G) so the number of used inodes on the
> filesystem is 10928139. I am using e2fsck form top of the master bran=
ch.
>
> Before each step I run:
> sync; echo 3 > /proc/sys/vm/drop_caches
>
> exporting raw image:
> time .//misc/e2image -r /dev/mapper/vg_raid-lv_stripe image.raw
>
> =A0 =A0 =A0 =A0real =A0 =A012m3.798s
> =A0 =A0 =A0 =A0user =A0 =A02m53.116s
> =A0 =A0 =A0 =A0sys =A0 =A0 3m38.430s
>
> =A0 =A0 =A0 =A06,0G =A0 =A0image.raw
>
> exporting qcow2 image
> time .//misc/e2image -Q /dev/mapper/vg_raid-lv_stripe image.qcow2
> e2image 1.41.14 (22-Dec-2010)
>
> =A0 =A0 =A0 =A0real =A0 =A011m55.574s
> =A0 =A0 =A0 =A0user =A0 =A02m50.521s
> =A0 =A0 =A0 =A0sys =A0 =A0 3m41.515s
>
> =A0 =A0 =A0 =A06,1G =A0 =A0image.qcow2
>
> So we can see that the running time is essentially the same, so there=
 is
> no crazy overhead in creating qcow2 image. Note that qcow2 image is
> slightly bigger because of all the qcow2 related metadata and it's si=
ze
> really depends on the size of the device. Also I tried to see how lon=
g
> does it take to export bzipped2 raw image, but it is running almost o=
ne
> day now, so it is not even comparable.
>
> e2fsck on the device:
> time .//e2fsck/e2fsck -fn /dev/mapper/vg_raid-lv_stripe
>
> =A0 =A0 =A0 =A0real =A0 =A03m9.400s
> =A0 =A0 =A0 =A0user =A0 =A00m47.558s
> =A0 =A0 =A0 =A0sys =A0 =A0 0m15.098s
>
> e2fsck on the raw image:
> time .//e2fsck/e2fsck -fn image.raw
>
> =A0 =A0 =A0 =A0real =A0 =A02m36.767s
> =A0 =A0 =A0 =A0user =A0 =A00m47.613s
> =A0 =A0 =A0 =A0sys =A0 =A0 0m8.403s
>
> We can see that e2fsck on the raw image is a bit faster, but that is
> obvious since the drive does not have to seek so much (right?).
>
> Now converting qcow2 image into raw image:
> time .//misc/e2image -r image.qcow2 image.qcow2.raw
>
> =A0 =A0 =A0 =A0real =A0 =A01m23.486s
> =A0 =A0 =A0 =A0user =A0 =A00m0.704s
> =A0 =A0 =A0 =A0sys =A0 =A0 0m22.574s
>
> It is hard to say if it is "quite fast" or not. But I would say it is
> not terribly slow either. Just out of curiosity, I have tried to conv=
ert
> raw->qcow2 with qemu-img convert tool:
>
> time qemu-img convert -O raw image.qcow2 image.qemu.raw
> ..it is running almost an hour now, so it is not comparable as well :=
)
>
> e2fsck on the qcow2 image.
> time .//e2fsck/e2fsck -fn -Q ./image.qcow2.img.tmp image.qcow2
>
> =A0 =A0 =A0 =A0real =A0 =A02m47.256s
> =A0 =A0 =A0 =A0user =A0 =A00m41.646s
> =A0 =A0 =A0 =A0sys =A0 =A0 0m28.618s
>
> Now that is surprising. Well, not so much actually.. We can see that
> e2fsck check on the qcow2 image, including qcow2->raw conversion is a
> bit slower than checking raw image (by 7% which is not much) but it i=
s
> still faster than checking device itself. Now, the reason is probably
> that the raw image we are creating is partially loaded into memory, h=
ence
> accelerate e2fsck. So I do not think that converting image before che=
ck
> is such a bad idea (especially when you have enough memory:)).
>
> I completely agree that having io_manager for the qcow2 format would =
be
> cool, if someone is willing to do that, but I am not convinced that i=
t
> is worth it. Your concerns are all valid and I agree, however I do no=
t
> think e2image is used by regular unexperienced users, so it should no=
t
> confuse them, but that is just stupid assumption :).
>
> Also, remember that if you really do not want to convert the image
> because of file size limit, or whatever, you can always use qemu-nbd =
to
> attach qcow2 image into nbd block device and use that as regular devi=
ce.

Did you consider the possibility to use QCOW2 format for doing a "tryou=
t"
fsck on the filesystem with the option to rollback?

If QCOW2 image is created with the 'backing_file' option set to the ori=
gin
block device (and 'backing_fmt' is set to 'host_device'), then qemu-nbd
will be able to see the exported image metadata as well as the filesyst=
em
data.

You can then do an "intrusive" fsck run on the NBD, mount your filesyst=
em
(from the NBD) and view the results.

If you are satisfied with the results, you can apply the fsck changes t=
o the
origin block device (there is probably a qemu-img command to do that).
If you are unsatisfied with the results, you can simply discard the ima=
ge
or better yet, revert to a QCOW2 snapshot, which you created just befor=
e
running fsck.

Can you provide the performance figures for running fsck over NBD?

>
> Regarding the e2fsck and the qcow2 support (or -Q option), I think it=
 is
> useful, but I do not really insist on keeping it and as you said we c=
an
> always force user to use e2image for conversion. It is just, this way=
 it
> seems easier to do it automatically. Maybe we can ask user whether he
> wants to keep the raw image after the check or not ?
>
> Regaring separate qcow2.h file and "qcow2_" prefix. I have done this
> because I am using this code from e2image and e2fsck so it seemed
> convenient to have it in separate header, however I guess I can move =
it
> into e2image.c and e2image.h if you want.
>
> So what do you think.
>
> Thanks!
> -Lukas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
