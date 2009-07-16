From: Justin Maggard <jmaggard10@gmail.com>
Subject: Re: >16TB issues
Date: Thu, 16 Jul 2009 11:04:41 -0700
Message-ID: <150c16850907161104j5e059baep988c5f04a0552c8c@mail.gmail.com>
References: <150c16850907021523p25ddae32v2eeea54418d2e6d5@mail.gmail.com>
	 <20090703143729.GJ20343@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f197.google.com ([209.85.222.197]:48141 "EHLO
	mail-pz0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932944AbZGPSEn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Jul 2009 14:04:43 -0400
Received: by pzk35 with SMTP id 35so195387pzk.33
        for <linux-ext4@vger.kernel.org>; Thu, 16 Jul 2009 11:04:41 -0700 (PDT)
In-Reply-To: <20090703143729.GJ20343@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 3, 2009 at 7:38 AM, Andreas Dilger<adilger@sun.com> wrote:
>> - =A0Immediately running e2fsck on the volume before ever mounting i=
t
>> will not complete, and results in the following:
>> # e2fsck -n /dev/md2
>> e2fsck 1.41.7 (29-June-2009)
>> Error reading block 2435874816 (Attempt to read block from filesyste=
m
>> resulted in short read). =A0Ignore error? no
>> /dev/md2: Attempt to read block from filesystem resulted in short re=
ad
>> while reading block 2435874816
>> /dev/md2: Attempt to read block from filesystem resulted in short re=
ad
>> reading journal superblock
>> e2fsck: Attempt to read block from filesystem resulted in short read
>> while checking ext3 journal for /dev/md2
>
> It looks like there may be some problem with the underlying device?
> I posted a program here a few months ago called "ll_ver_dev" which
> can quickly (or slowly) verify that writes and reads to different
> offsets in a block device return consistent data. =A0The quick versio=
n
> will detect such problems as 32-bit overflows, but if you are having
> strange problems you might need to run the full version.
>
> You could also try running with a filesystem just under 16TB and
> verifying that works.
>

Running with a filesystem just under 16TB works fine.  Forgive my
ignorance, but for the life of me I couldn't find an reference
anywhere about your "ll_ver_dev" program.  But doing dd if=3D/dev/zero
across the entire ~18TB didn't report any errors, so I believe the
underlying device is in good shape.

Running e2fsck with an external journal did change the behavior
though.  Basically it no longer chokes on the journal, but it does
somewhere else:

e2fsck 1.41.8 (11-July-2009)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Error reading block 576192512 (Attempt to read block from filesystem
resulted in short read) while reading inode and block bitmaps.  Ignore
error? no

e2fsck: Can't read an block bitmap while retrying to read bitmaps for /=
dev/md2
e2fsck: aborted

>> - =A0Mounting with -o noload does appear to work, and reading and
>> writing seems to work fine.
>
> That's because the journal is not being used, which is what seems to
> be having the problem. =A0I wonder if the journal is beyond 8TB or
> beyond 16TB for some reason and this is causing grief?
>

Perhaps, but I'm not sure.  Using an external journal device also
worked the same as not loading the journal.

-Justin
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
