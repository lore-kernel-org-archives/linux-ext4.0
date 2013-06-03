From: Autif Khan <autif.mlist@gmail.com>
Subject: Misbehaving SSDs - FTL corruption
Date: Mon, 3 Jun 2013 14:02:10 -0400
Message-ID: <CADzUK1JDVJfs_iCe6hk1VFsFmTBCdLtbWCr0aRRa-dGVpxCtLQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:38433 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883Ab3FCSIE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Jun 2013 14:08:04 -0400
Received: by mail-la0-f43.google.com with SMTP id gw10so1308881lab.2
        for <linux-ext4@vger.kernel.org>; Mon, 03 Jun 2013 11:08:02 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a followup and continued efforts to get to the bottom of why
we get corruption when we yank the power cable.

The old thread is here: http://marc.info/?l=linux-ext4&m=136873103003976&w=2

Thanks to Eric and Ted, we have something that works for our case. But
we still can't get over something.

Once again to refresh our scenario:

Our embedded Linux device is not battery backed and the SOP to power
down the device is to yank the power cable. To protect against this,
we mount all partitions read only. We write to the partitions using
the following script:

<start to script>
sudo mount -o remount,rw,barrier=1 /koko

#perform all sorts of write operations. for example
cp -f $SOURCE $TARGET

sudo sync
sudo sleep 2
sudo hdparm -f /dev/sda

sudo mount -o remount,ro /koko
<end of script>

We found that a relatively expensive Intel Enterprise SSD works perfectly.

Some relatively inexpensive Crucial, OCZ and Sandisk SSDs do not.

dumpe2fs -h /dev/sda says (for inexpensive SSDs)
Filesystem features:      has_journal ext_attr resize_inode dir_index
filetype extent flex_bg sparse_super large_file huge_file uninit_bg
dir_nlink extra_isize

Here is what we really do not understand with respect the inexpensive disks:

Using the steps outlined in the script, we write about 800MB of files
(copying, untarring etc) on the /koko partition. If at this time, we
yank the power cable, everything is fine - for all the inexpensive
disks. This script is executed at boot from /etc/rc.local as root.

After a while - if we write some configuration/calibration data to the
/koko partition (usually 30 bytes or so), and then yank the power
cable, we get an fsck error, check forced, etc etc. dumpe2fs -h says
"clean with errors" - fsck -n /dev/sda5 does not reveal anything. The
write script is executed as a normal user with sudo permissions
(NOPASSWD option is set, so, there is no prompt for password).

Again - we use the same steps in both the cases - remount,rw with
barriers, perform write, sync, flush and remount,ro.

Why does this work when we write 800MBs and does not when we write
just 30 bytes?

I actually tried to artificially write 512 bytes, 2048 bytes and 400MB
just to see if that would make a difference - it does not.

Is there a separate command/syscall to tell the SSD to flush its FTL?

Are there any logs/outputs of commands etc that I can provide that can
help here?

Thanks

Autif
