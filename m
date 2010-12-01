From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PARCH 0/1 RFC] e2image: Add support for QCOW2 image format
Date: Wed, 1 Dec 2010 21:16:52 +0200
Message-ID: <AANLkTinkZeBPxazH3MxKcXhxQ+7P00dfus-1WrAR12bG@mail.gmail.com>
References: <1291225309-10750-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, adilger@dilger.ca, sandeen@redhat.com,
	linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58775 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756511Ab0LATQx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Dec 2010 14:16:53 -0500
Received: by qwb7 with SMTP id 7so7420005qwb.19
        for <linux-ext4@vger.kernel.org>; Wed, 01 Dec 2010 11:16:53 -0800 (PST)
In-Reply-To: <1291225309-10750-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 1, 2010 at 7:41 PM, Lukas Czerner <lczerner@redhat.com> wro=
te:
> Hi, all
>
> As Ted suggested on LPC I started to play with e2image to add support=
 for
> exporting images in QCOW2 format (http://en.wikipedia.org/wiki/Qcow2)=
=2E The
> advantage of this format is mainly that the resulting image is quite =
small
> (because we write only the metadata blocks) and it is not sparse unli=
ke
> "sparse" image format.
>
> I am presenting you an initial parch, which works for me quite nicely=
, however
> so far it did received just limited testing. Nevertheless you can try=
 it simply
> by invoking e2image with '-q' parameter like this:
>
> =A0 =A0 =A0 =A0e2image -q /dev/sda1 myimage
>
> or you can add '-s' option so the file names are scrambled. To mount =
that qcow2
> image I usually use 'qemu-nbd':
>
> =A0 =A0 =A0 =A0modprobe nbd max_part=3D8
> =A0 =A0 =A0 =A0qemu-nbd --connect=3D/dev/nbd0 myimage
> =A0 =A0 =A0 =A0mount -o ro /dev/nbd0 /mnt/test/
>
> However I have experienced some problems with qemu-nbd from time to t=
ime. Also
> for some reason, when you mount the image read-write, you'll destroy =
it. So far
> I was not able to figure out why (I did not tried at all to be honest=
), it may
> be problem in my image format or even in qemu itself, so if you have =
any idea,
> please let me know.
>
> QCOW2 format supports other neat features like compression, encryptio=
n and
> snapshots. None of those feature are supported in this patch and the =
question
> is, do we need it ? I can imagine for example snapshots to be useful =
for
> roll-back changes made by e2fsck, but this is hardly problem of e2ima=
ge itself.
>
> So, please look at the patch, try it and let me know what else you th=
ing is
> useful to implement, or what would you like to change.
>

Hi Lukas,

This is very cool :-)
My wish is to export next3/ext4 snapshots as qcow2 snapshots.
I actually thought of implementing e2image -x <snapid> as a way to
export a snapshot image,
but using qcow2, file system can be exported with all of it's snapshots=
=2E
It should be quite trivial since next3 snapshots contain a map of chang=
ed blocks
and I suppose qcow2 snapshots should be the same.
Now I only need to find the time to do it...

Amir.


> Anny comments appreciated.
>
> Thanks!
>
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
