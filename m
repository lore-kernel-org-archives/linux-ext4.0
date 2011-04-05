From: Coly Li <i@coly.li>
Subject: Re: [PATCH, RFC 00/12] bigalloc patchset
Date: Wed, 06 Apr 2011 01:23:19 +0800
Message-ID: <4D9B5007.8050403@coly.li>
References: <1300570117-24048-1-git-send-email-tytso@mit.edu>
Reply-To: i@coly.li
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:46243 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753603Ab1DEQye (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Apr 2011 12:54:34 -0400
In-Reply-To: <1300570117-24048-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011=E5=B9=B403=E6=9C=8820=E6=97=A5 05:28, Theodore Ts'o Wrote:
> This is an initial patchset of the bigalloc patches to ext4.  This pa=
tch
> adds support for clustered allocation, so that each bit in the ext4
> block allocation bitmap addresses a power of two number of blocks.  F=
or
> example, if the file system is mainly going to be storing large files=
 in
> the 4-32 megabyte range, it might make sense to set a cluster size of=
 1
> megabyte.  This means that each bit in the block allocaiton bitmap wo=
uld
> now address 256 4k blocks, and it means that the size of the block
> bitmaps for a 2T file system shrinks from 64 megabytes to 256k.  It a=
lso
> means that a block group addresses 32 gigabytes instead of 128
> megabytes, also shrinking the amount of file system overhead for
> metadata.
>
> The cost is increased disk space efficiency.  Directories will consum=
e
> 1T, as will extent tree blocks.  (I am on the fence as to whether I
> should add complexity so that in the rare case that an inode needs mo=
re
> than 344 extents --- a highly fragmented file indeed --- and need a
> second extent tree block, we can avoid allocating any cluster and
> instead use another block from the cluster used by the inode.  The
> concern is the amount of complexity this adds to the e2fsck, not just=
 to
> the kernel.)
>
> To test these patches, I have used an *extremely* kludgy set of patch=
es
> to e2fsprogs, which are attached below.  These patches need *extensiv=
e*
> revision before I would consider them clean enough suitable for
> committing into e2fsprogs, but they were sufficient for me to do the
> kernel-side changes --- mke2fs, dumpe2fs, and debugfs work.  E2fsck m=
ost
> definitely does _not_ work at this stage.
>
> Please comment!  I do not intend for these patches to be merged durin=
g
> the 2.6.39 merge window.  I am targetting 2.6.40, 3 months from now,
> since these patches are quite extensive.

Hi Ted,

Is it possible to open a git repo/branch for both kernel and user space=
 tools ? So others can follow, help or provide=20
performance number in time :-)

Thanks.

Coly

--=20
Coly Li
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
