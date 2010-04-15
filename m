From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [RFC][PATCH 0/3] ext4: inode preferred block allocation
Date: Thu, 15 Apr 2010 12:22:38 -0400
Message-ID: <g2q87f94c371004150922qb636f468t9cf3b6cb8cfd7b03@mail.gmail.com>
References: <4BC57A1D.9080105@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>,
	linux-fsdevel@vger.kernel.org,
	OHSM-DEV <ohsm-devel@lists.sourceforge.net>,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:45733 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494Ab0DOQWj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Apr 2010 12:22:39 -0400
In-Reply-To: <4BC57A1D.9080105@sx.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dmitry added to cc because of use case at the bottom discussing Project=
ID

2010/4/14 Kazuya Mio <k-mio@sx.jp.nec.com>:
> Hi,
>
> We implemented new two ioctls to allocate preferred blocks using inod=
e PA.
> The old implementation idea is the following (b).
> http://marc.info/?l=3Dlinux-ext4&m=3D124962738211206&w=3D4
>
> One is EXT4_IOC_CONTROL_PA that is to create or discard inode PA, and=
 the
> other is EXT4_IOC_GET_PA that is to get inode PA information.
>
> 1. EXT4_IOC_CONTROL_PA
>
> =A0 EXT4_IOC_CONTROL_PA is used to create new inode PA, or to discard=
 all inode
> =A0 PAs in the target inode. This means that we will be able to alloc=
ate
> =A0 the blocks we want.
> =A0 We have a plan to add a new feature to e4defrag with these ioctls=
=2E This
> =A0 feature improves read throughput when we read the files in the sa=
me
> =A0 directory by reallocating target files near their parent director=
y.
>
> 2. EXT4_IOC_GET_PA
>
> =A0 EXT4_IOC_GET_PA is used to get inode PA information.
>
> Moreover, when we create an inode PA, ext4_mb_new_inode_pa() merges
> contiguous inode PA if possible.
>
> This patch set consists of the following three patches. They can be a=
pplied to
> the ext4 patch queue:
> commit: 1dea5b6f540ad056d51d11cda71fa757cb44cbc4
>
> [RFC][PATCH 0/3] ext4: inode preferred block allocation
> [RFC][PATCH 1/3] ext4: add EXT4_IOC_CONTROL_PA to create/discard inod=
e PA
> [RFC][PATCH 2/3] ext4: sort and merge inode PA
> [RFC][PATCH 3/3] ext4: add EXT4_IOC_GET_PA to get inode PA informatio=
n
>
> Any comments are very welcome.
>
> Best regards,
> Kazuya Mio

Kazuya,

I have a basic understanding how these could be used by e4defrag to
organize stable data blocks / extents, but is the goal to also allow a
working set of dynamic files which allocate new data blocks routinely?

=3D=3D details / example

Assume I know that files owned by a specific user (such as the apache
daemon) need to be collocated to reduce seek times as pages are
displayed.

After the fact, I can see the e4defrag moving all files with UID
apached into a subset of block groups thus increasing locality and
decreasing seeks.

But what if those files themselves are dynamically being created /
extended and thus allocating new data blocks/extents on the fly.   The
need in that situation would be more along the lines of defining a
preferred block group range for all files with the same UID.  And all
of those files would be provided exactly the same block range.

ie. If we have a 1 TB array, but the heavily used dynamic webserver
pages is only 5 GB, so I want to define a 5 GB block group range to
have those files live in.

Anyway, my main question again is if this patchset is only designed
for after the fact file/data locality organization, or if it is also
designed to support dynamic environments.

fyi: Creating locality groups is the use case I see for Dmitry's
Project ID patchset.  A collection of files that are used together can
be assigned a unique ProjectID and then e4defrag can grow the
knowledge to place them within a locality area on the disk.

But I also can see that new files within a directory would inherit the
ProjectID from the directory, and the data blocks allocated from the
correct locality area from the get go.

Dmitry, I haven't studied your patchset, but does it allow for
ProjectID inheritance from the parent directory?

Thanks
Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
