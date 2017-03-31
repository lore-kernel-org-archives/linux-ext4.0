From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: 4.10.7: systemd-fsck: data: Inode 14681437 Erweiterung tree (at
 level 1) could be shorter. IGNORIERT
Date: Fri, 31 Mar 2017 18:48:24 +0200
Message-ID: <0cc538f9-7277-1f77-0f56-ea0fd930251c@thelounge.net>
References: <4c156024-0570-0c05-3a72-ffe3f34a878a@thelounge.net>
 <20170331161914.GB4853@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.thelounge.net ([91.118.73.15]:24921 "EHLO
        mail.thelounge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933476AbdCaQs2 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 31 Mar 2017 12:48:28 -0400
In-Reply-To: <20170331161914.GB4853@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



Am 31.03.2017 um 18:19 schrieb Darrick J. Wong:
> On Fri, Mar 31, 2017 at 01:30:18PM +0200, Reindl Harald wrote:
>> what are the messages below for which i get when reboot with /forcefsck at
>> least on kernel 4.10.7?
>> ___________________________________________________
>>
>> and no, i can't unmount the device because after repeated "umount /dev/md2"
>> which are unmounting some bind-mounts i get the following message while
>> nothing (lsof, fuser with all sort of options) shows any open filehandle and
>> all processes are stopped - so no way just enter "fsck" with params and that
>> issue exists for years
>
> Some services ask systemd to run in their own private fs namespaces
> (ProtectSystem=true) and so even though you umount the fs in the regular
> namespace that doesn't unmount the fs in the private namespace, which
> means that e2fsck & friends report that the fs is still mounted.  You
> can find out if this is the case by grepping for the mountpoint in
> /proc/*/mounts after unmounting the fs from the shell.
>
> (And yes, this, uh, quirk has visited me many times.)

but my *data* partition when all services are stopped which would have 
namespaces there for ReadOnly/ReadWrite/Deny?

some "umount --force" would be really cool since after "systemctl 
isolate rescue.target" that all should be gone

>> target is busy (In some cases useful info about processes that use the
>> device is found by lsof(8) or fuser(1).
>> ___________________________________________________
>>
>> Mar 31 12:55:40 rh systemd-fsck: system: clean, 214548/1921360 files,
>> 1888521/7679232 blocks
>> Mar 31 12:55:43 rh systemd-fsck: Please pass 'fsck.mode=force' on the kernel
>> command line rather than creating /forcefsck on the root file system.
>> Mar 31 12:55:43 rh systemd-fsck: Please pass 'fsck.mode=force' on the kernel
>> command line rather than creating /forcefsck on the root file system.
>> Mar 31 12:55:43 rh systemd-fsck: boot: 375/128016 Dateien (1.3% nicht
>> zusammenhängend), 50000/511988 Blöcke
>> Mar 31 12:55:47 rh systemd-fsck: data: Inode 14681437 Erweiterung tree (at
>> level 1) could be shorter.  IGNORIERT.
>
> My ability to interpret "deutschglish" isn't all that good, but I'm
> pretty sure this is e2fsck complaining about unnecessarily large and
> sparse extent trees, though it's clearly not optimizing them

oh, no nothing really bad
