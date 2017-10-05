From: Kilian Cavalotti <kilian.cavalotti.work@gmail.com>
Subject: Recover from a "deleted inode referenced" situation
Date: Thu, 5 Oct 2017 14:31:59 -0700
Message-ID: <CAJz=VjEUqxMNo6zShYaV5ffioxaj6+a5Av0imtfdtCDf7wqY=A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:54021 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751388AbdJEVcV (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Oct 2017 17:32:21 -0400
Received: by mail-wm0-f45.google.com with SMTP id q132so4615040wmd.2
        for <linux-ext4@vger.kernel.org>; Thu, 05 Oct 2017 14:32:20 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dear ext4 experts,

TL;DR: I messed up a large filesystem, which now references deleted
inodes. What's the best way to recover from this and hopefully
reconstruct at least part of the directory hierarchy?

Full version:

I'm writing as a last recourse before committing data seppuku. I
failed to observe rule #1 of disaster recovery (sit on your hands) and
made a bad situation significantly worse. So I'm trying to figure out
how badly I'm screwed, and if there's any hope of salvation.

To set the stage, I have (sniff, *had*) an ext4 filesystem sitting on
a LVM logical volume, on top of a RAID5 dmraid volume. The dmraid
volume was expanded, then the LVM logical volume, and the ext4
filesystem was resize2fs'ed. Except somewhere in the process,
something failed and the ext4 filesystem was damaged. I unfortunately
don't really know much more about the failure.

At that point, the filesystem could be mounted read-only by using a
backup superblock (mount -o ro,sb=131072), and a quick glance at it
showed a decent directory structure, with at least top-level
directories intact.

So I jumped on it and started exfiltrating data from the damaged
filesystem to an external system. Now, and that's what will cause me
sorrow forever, I inadvertently remounted that filesystem read-write
while the transfer was running...

Of course, it soon started to throw errors about deleted inodes, like this:

EXT4-fs error (device dm-0): ext4_lookup:1644: inode #2: comm rsync:
deleted inode referenced: 1517

At that point, listing the root of the filesystem generated I/O errors
and dreadful question marks, where it displayed a valid directory
before the r/w remount:

$ ls /vol
ls: cannot access backup: Input/output error
drwxr-xr-x 2 root root 4096 Sep 28 11:10 .
drwxr-xr-x 4 root root 4096 Sep 14  2013 ..
-????????? ? ?    ?       ?            ? backup
[...]

I re-remounted read-only as soon as I realized my mistake, but the
filesystem stayed mounted r/w for a few minutes.

That's where I'm at right now. I'm dd'ing the LVM device to another
system before doing anything else, and while this is running (it will
take a few days, as the filesystem size is close to 20TB), I'm
pondering options.

I guess the next logical step would be to run fsck, but I'm very
worried that I will end up with mess of detached inodes in /lost+found
without any way to figure out their original location in the
filesystem...

I read about ways to run fsck without touching the underlying
filesystem (or image) with a LVM snapshots, or getting a copy of the
metadata information with e2image, but I'm not really sure how to
proceed.

Could anybody provide pointers or advice on what to do next? Is there
a way to undo the latest modifications done while the filesystem was
mounted r/w? Do I have any chance to recover the initial structure and
contents of my filesystem?

I can obviously provide all the required information, just didn't want
to make an already long email even longer.


Thanks!
-- 
Kilian
