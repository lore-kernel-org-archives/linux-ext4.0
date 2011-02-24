From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: fsck performance.
Date: Thu, 24 Feb 2011 10:59:23 +0200
Message-ID: <AANLkTinv-JPaiPzKC4xSqh0shmzjf4rKeQShRwiOznoz@mail.gmail.com>
References: <C5662C0F-10E3-4AC3-8ACA-4CBBF4F36D70@dilger.ca>
	<20110222102056.GH21917@bitwizard.nl>
	<20110222133652.GI21917@bitwizard.nl>
	<20110222135431.GK21917@bitwizard.nl>
	<386B23FA-CE6E-4D9C-9799-C121B2E8C3BB@dilger.ca>
	<20110222221304.GH2924@thunk.org>
	<20110223044427.GM21917@bitwizard.nl>
	<DC8EC4D5-BB64-4908-985B-C6D3EDA955E3@mit.edu>
	<20110223205309.GA16661@bitwizard.nl>
	<F03E2EAC-9D44-4D8E-93AC-902FDFC22B92@dilger.ca>
	<20110224072945.GE16661@bitwizard.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: Rogier Wolff <R.E.Wolff@bitwizard.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:41779 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699Ab1BXI71 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Feb 2011 03:59:27 -0500
Received: by qwd7 with SMTP id 7so242753qwd.19
        for <linux-ext4@vger.kernel.org>; Thu, 24 Feb 2011 00:59:26 -0800 (PST)
In-Reply-To: <20110224072945.GE16661@bitwizard.nl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 24, 2011 at 9:29 AM, Rogier Wolff <R.E.Wolff@bitwizard.nl> =
wrote:
> On Wed, Feb 23, 2011 at 03:24:18PM -0700, Andreas Dilger wrote:
>
>> The dircount can be extracted from the group descriptors, which
>> count the number of allocated directories in each group. =A0Since th=
e
>
> OK.
>
>> superblock "free inodes" count is no longer updated except at
>> unmount time, the code would need to walk all of the group
>> descriptors to get this number anyway.
>
> No worries. It matters a bit for performance, but if that free inode
> count in the superblock is outdated, we'll just use that outdated
> one. The one case that I'm afraid of is that someone creates a new
> filesystem (superblock inodes-in-use =3D~=3D 0), then copies on milli=
ons
> of files, and then crashes his system....
>
> I'll add a minimum of 999931, causing an overhead of around 4Mb of
> disk space usage if this was totally unneccesary.
>
>> If you have the opportunity, I wonder whether the entire need for
>> tdb can be avoided in your case by using swap and the icount
>> optimization patches previously posted? =A0I'd really like to get th=
at
>> patch included upstream, but it needs testing in an environment like
>> yours where icount is a significant factor. =A0This would avoid all =
of
>> the tdb overhead.
>
> First: I don't think it will work. The largest amount of memory that
> e2fsck had allocated was 2.5Gb. At that point it also had around 1.5G
> of disk space in use for tdb's for a total of 4G. On the other hand,
> we've established that the overhead in tdb is about 24bytes per 8
> bytes of real data.... So maybe we would only have needed 200M of
> in-memory datastructures to handle this. Two of those 400M together
> with the dircount (tdb =3D750M, assume same ratio) total 600M still
> above 3G.
>
> Second: e2fsck is too fragile as it is. It should be able to handle
> big filesystems on little systems. I have a puny little 2GHz Athlon
> system that currently has 3T of disk storage and 1G RAM. Embedded
> Linux systems can be running those amounts of storage with only 64
> or 128 Mb of RAM.
>
> Even if MY filesystem happens to pass, with a little less memory-use,
> then there is a slightly larger system that won't.
>
> I have a server that has 4x2T instead of the server that has 4*1T. It
> uses the same backup strategy, so it too has lots and lots of files.
> In fact it has 84M inodes in use. (I thought 96M inodes would be
> plenty... wrong! I HAVE run out of inodes on that thing!)
>
> That one too may need to fsck the filesystem...
>
> I remember hearing about a tool that would extract all the filesystem
> meta-info, so that I can make an image that I can then test e.g. fsck
> upon? Inodes, directory blocks, indirect blocks etc.?
>

That tool is e2image -r, which creates a sparse file image of your fs
(only metadata is written, the rest is holes), so you need to be carefu=
l
when copying/transferring it to another machine to do it wisely
(i.e. bzip or dd directly to a new HDD)
Not sure what you will do if fsck fixes errors on that image...
Mostly (if it didn't clone multiply claimed blocks for example), you wo=
uld
be able to write the fixed image back onto your original fs,
but that would be risky.

> Then I could make an image where I could test this. I don't really
> want to put this offline again for multiple days.
>
>
> =A0 =A0 =A0 =A0Roger.
>
>
> --
> ** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-26009=
98 **
> ** =A0 =A0Delftechpark 26 2628 XH =A0Delft, The Netherlands. KVK: 272=
39233 =A0 =A0**
> *-- BitWizard writes Linux device drivers for any device you may have=
! --*
> Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous state=
ment.
> Does it sit on the couch all day? Is it unemployed? Please be specifi=
c!
> Define 'it' and what it isn't doing. --------- Adapted from lxrbot FA=
Q
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
