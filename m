From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: Question on block group allocation
Date: Wed, 29 Apr 2009 15:29:55 -0700
Message-ID: <6601abe90904291529o5aaab638i73bd34c1a6d54c74@mail.gmail.com>
References: <20090423190817.GN3209@webber.adilger.int>
	 <20090427021411.GA9059@mit.edu>
	 <6601abe90904262229w602e17d8s51ceae05c2895ce5@mail.gmail.com>
	 <20090427224052.GC22104@mit.edu> <20090429191646.GF14264@mit.edu>
	 <6601abe90904291138r6e24c04dj4b2efcdba22bf84@mail.gmail.com>
	 <20090429193744.GA17797@mit.edu>
	 <6601abe90904291321u3f13d8b0p88b9a9eba5bc03a1@mail.gmail.com>
	 <20090429212043.GB24749@mit.edu> <20090429215032.GC24749@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@sun.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:32246 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755400AbZD2WaB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 29 Apr 2009 18:30:01 -0400
Received: from spaceape24.eur.corp.google.com (spaceape24.eur.corp.google.com [172.28.16.76])
	by smtp-out.google.com with ESMTP id n3TMTwB0008843
	for <linux-ext4@vger.kernel.org>; Wed, 29 Apr 2009 15:29:59 -0700
Received: from wa-out-1112.google.com (wahv27.prod.google.com [10.114.248.27])
	by spaceape24.eur.corp.google.com with ESMTP id n3TMTu2X028525
	for <linux-ext4@vger.kernel.org>; Wed, 29 Apr 2009 15:29:56 -0700
Received: by wa-out-1112.google.com with SMTP id v27so552217wah.22
        for <linux-ext4@vger.kernel.org>; Wed, 29 Apr 2009 15:29:55 -0700 (PDT)
In-Reply-To: <20090429215032.GC24749@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted:

On Wed, Apr 29, 2009 at 2:50 PM, Theodore Tso <tytso@mit.edu> wrote:
> Oh --- one more question. =A0You did these tests on your 2.6.26-based
> kernel with ext4 backports, right? =A0Not 2.6.30 mainline kernel? =A0=
Did
> you backport the changes to the block and inode allocators? =A0i.e.,
> this patch (plus a 1 or 2 subsequent bug fixes)?
>
>
> commit a4912123b688e057084e6557cef8924f7ae5bbde
> Author: Theodore Ts'o <tytso@mit.edu>
> Date: =A0 Thu Mar 12 12:18:34 2009 -0400
>
> =A0 =A0ext4: New inode/block allocation algorithms for flex_bg filesy=
stems

Yes, we have this patch.  I'm not sure if we have the "1 or 2" bug
fixes you refer to above; do you have commits for these?

I'm regen'ing the e2fsck and debugfs output for the 3 "dd" sequence
above, for our stock kernel and for this + Andreas' patch.

Thanks,
Curt

>
> =A0 =A0The find_group_flex() inode allocator is now only used if the
> =A0 =A0filesystem is mounted using the "oldalloc" mount option. =A0It=
 is
> =A0 =A0replaced with the original Orlov allocator that has been updat=
ed for
> =A0 =A0flex_bg filesystems (it should behave the same way if flex_bg =
is
> =A0 =A0disabled). =A0The inode allocator now functions by taking into=
 account
> =A0 =A0each flex_bg group, instead of each block group, when deciding=
 whether
> =A0 =A0or not it's time to allocate a new directory into a fresh flex=
_bg.
>
> =A0 =A0The block allocator has also been changed so that the first bl=
ock
> =A0 =A0group in each flex_bg is preferred for use for storing directo=
ry
> =A0 =A0blocks. =A0This keeps directory blocks close together, which i=
s good for
> =A0 =A0speeding up e2fsck since large directories are more likely to =
look
> =A0 =A0like this:
>
> =A0 =A0debugfs: =A0stat /home/tytso/Maildir/cur
> =A0 =A0Inode: 1844562 =A0 Type: directory =A0 =A0Mode: =A00700 =A0 Fl=
ags: 0x81000
> =A0 =A0Generation: 1132745781 =A0 =A0Version: 0x00000000:0000ad71
> =A0 =A0User: 15806 =A0 Group: 15806 =A0 Size: 1060864
> =A0 =A0File ACL: 0 =A0 =A0Directory ACL: 0
> =A0 =A0Links: 2 =A0 Blockcount: 2072
> =A0 =A0Fragment: =A0Address: 0 =A0 =A0Number: 0 =A0 =A0Size: 0
> =A0 =A0 ctime: 0x499c0ff4:164961f4 -- Wed Feb 18 08:41:08 2009
> =A0 =A0 atime: 0x499c0ff4:00000000 -- Wed Feb 18 08:41:08 2009
> =A0 =A0 mtime: 0x49957f51:00000000 -- Fri Feb 13 09:10:25 2009
> =A0 =A0crtime: 0x499c0f57:00d51440 -- Wed Feb 18 08:38:31 2009
> =A0 =A0Size of extra inode fields: 28
> =A0 =A0BLOCKS:
> =A0 =A0(0):7348651, (1-258):7348654-7348911
> =A0 =A0TOTAL: 259
>
> =A0 =A0Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0- Ted
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
