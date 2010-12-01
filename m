From: Lukas Czerner <lczerner@redhat.com>
Subject: [PARCH 0/1 RFC] e2image: Add support for QCOW2 image format
Date: Wed,  1 Dec 2010 18:41:48 +0100
Message-ID: <1291225309-10750-1-git-send-email-lczerner@redhat.com>
Cc: adilger@dilger.ca, sandeen@redhat.com, lczerner@redhat.com,
	linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18484 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755515Ab0LAS2z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 1 Dec 2010 13:28:55 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi, all

As Ted suggested on LPC I started to play with e2image to add support for
exporting images in QCOW2 format (http://en.wikipedia.org/wiki/Qcow2). The
advantage of this format is mainly that the resulting image is quite small
(because we write only the metadata blocks) and it is not sparse unlike
"sparse" image format.

I am presenting you an initial parch, which works for me quite nicely, however
so far it did received just limited testing. Nevertheless you can try it simply
by invoking e2image with '-q' parameter like this:

	e2image -q /dev/sda1 myimage

or you can add '-s' option so the file names are scrambled. To mount that qcow2
image I usually use 'qemu-nbd':

	modprobe nbd max_part=8
	qemu-nbd --connect=/dev/nbd0 myimage
	mount -o ro /dev/nbd0 /mnt/test/

However I have experienced some problems with qemu-nbd from time to time. Also
for some reason, when you mount the image read-write, you'll destroy it. So far
I was not able to figure out why (I did not tried at all to be honest), it may
be problem in my image format or even in qemu itself, so if you have any idea,
please let me know.

QCOW2 format supports other neat features like compression, encryption and
snapshots. None of those feature are supported in this patch and the question
is, do we need it ? I can imagine for example snapshots to be useful for
roll-back changes made by e2fsck, but this is hardly problem of e2image itself.

So, please look at the patch, try it and let me know what else you thing is
useful to implement, or what would you like to change.

Anny comments appreciated.

Thanks!

-Lukas
