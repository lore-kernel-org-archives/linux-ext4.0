From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PARCH 0/1 RFC] e2image: Add support for QCOW2 image format
Date: Thu, 2 Dec 2010 09:23:15 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1012020916490.2874@dhcp-lab-213.englab.brq.redhat.com>
References: <1291225309-10750-1-git-send-email-lczerner@redhat.com> <AANLkTinkZeBPxazH3MxKcXhxQ+7P00dfus-1WrAR12bG@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="571108635-551877925-1291278199=:2874"
Cc: Lukas Czerner <lczerner@redhat.com>, tytso@mit.edu,
	adilger@dilger.ca, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44602 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754677Ab0LBIXY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Dec 2010 03:23:24 -0500
In-Reply-To: <AANLkTinkZeBPxazH3MxKcXhxQ+7P00dfus-1WrAR12bG@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--571108635-551877925-1291278199=:2874
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Wed, 1 Dec 2010, Amir Goldstein wrote:

> On Wed, Dec 1, 2010 at 7:41 PM, Lukas Czerner <lczerner@redhat.com> wrote:
> > Hi, all
> >
> > As Ted suggested on LPC I started to play with e2image to add support for
> > exporting images in QCOW2 format (http://en.wikipedia.org/wiki/Qcow2). The
> > advantage of this format is mainly that the resulting image is quite small
> > (because we write only the metadata blocks) and it is not sparse unlike
> > "sparse" image format.
> >
> > I am presenting you an initial parch, which works for me quite nicely, however
> > so far it did received just limited testing. Nevertheless you can try it simply
> > by invoking e2image with '-q' parameter like this:
> >
> >        e2image -q /dev/sda1 myimage
> >
> > or you can add '-s' option so the file names are scrambled. To mount that qcow2
> > image I usually use 'qemu-nbd':
> >
> >        modprobe nbd max_part=8
> >        qemu-nbd --connect=/dev/nbd0 myimage
> >        mount -o ro /dev/nbd0 /mnt/test/
> >
> > However I have experienced some problems with qemu-nbd from time to time. Also
> > for some reason, when you mount the image read-write, you'll destroy it. So far
> > I was not able to figure out why (I did not tried at all to be honest), it may
> > be problem in my image format or even in qemu itself, so if you have any idea,
> > please let me know.
> >
> > QCOW2 format supports other neat features like compression, encryption and
> > snapshots. None of those feature are supported in this patch and the question
> > is, do we need it ? I can imagine for example snapshots to be useful for
> > roll-back changes made by e2fsck, but this is hardly problem of e2image itself.
> >
> > So, please look at the patch, try it and let me know what else you thing is
> > useful to implement, or what would you like to change.
> >
> 
> Hi Lukas,
> 
> This is very cool :-)
> My wish is to export next3/ext4 snapshots as qcow2 snapshots.
> I actually thought of implementing e2image -x <snapid> as a way to
> export a snapshot image,
> but using qcow2, file system can be exported with all of it's snapshots.
> It should be quite trivial since next3 snapshots contain a map of changed blocks
> and I suppose qcow2 snapshots should be the same.
> Now I only need to find the time to do it...
> 
> Amir.

Hi Amir,

I seems like a cool feature, so when QCOW2 infrastructure is in place
adding snapshots to it should not be a big deal (not that QCOW2
infrastructure is :)), however I was wondering are you planning to
export only metadata, or even data itself ?

Thanks!

-Lukas

> 
> 
> > Anny comments appreciated.
> >
> > Thanks!
> >
> > -Lukas
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
--571108635-551877925-1291278199=:2874--
