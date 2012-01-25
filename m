From: Andreas Dilger <aedilger@gmail.com>
Subject: Re: Does Ext4 support parallel write similar to XFS?
Date: Wed, 25 Jan 2012 11:06:29 -0700
Message-ID: <D5446EEA-D3AF-43BB-B862-6C9A741B0DC9@gmail.com>
References: <CADDb1s2w9ZwMXn38n8TcxhFNrUsXN1Gnxq-suAP2-M+R7YhFsg@mail.gmail.com> <4F202F2E.9000608@redhat.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Amit Sahrawat <amit.sahrawat83@gmail.com>,
	"xfs@oss.sgi.com" <xfs@oss.sgi.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	ChristophHellwig <hch@infradead.org>,
	Dave Chinner <david@fromorbit.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:59151 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750885Ab2AYSGS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Jan 2012 13:06:18 -0500
In-Reply-To: <4F202F2E.9000608@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-01-25, at 9:34, Eric Sandeen <sandeen@redhat.com> wrote:
> On 1/24/12 11:19 PM, Amit Sahrawat wrote:
>> In XFS we can write parallel (i.,e we can make use of allocation
>> groups for writing process). If the files are kept in individual
>> directories, there is a possibility that first the blocks for that
>> files be used from individual allocation groups. If I start =E2=80=98=
4=E2=80=99
>> writing process(cp 100MB_file /<dirnum>/) =E2=80=93 after writing is=
 finished
>> =E2=80=93 if I check the bmap =E2=80=93 it does shows that initial a=
llocation was from
>> individual allocation groups.
>> Even though in Ext4 also we do have groups =E2=80=93 but I am not ab=
le to get
>> behavior similar to XFS.
>> If I check the file extents =E2=80=93 the extents are in mixed form,=
 the
>> allocation pattern is also very fragmented.
>>=20
>> Please share more on this. Also, if there is a possible exact test
>> case to check for parallel writes support.
>=20
> It seems that you are asking more about allocation policy than parall=
elism
> in general?  With either filesystem, you could use preallocation to w=
ind
> up with more contiguous files when you write them in parallel, though
> that requires some idea of the file size ahead of time.
>=20
> ext4 doesn't have that exact dir::group heuristic that xfs uses,
> but it does have other mechanisms and heuristics to try to get good
> file and directory layout.
>=20
> In general, ext4 tries to put new root directories into new groups, s=
ee
> comments above find_group_orlov().  Other directories tend to stay ne=
ar
> their parent directory.  So it's really the roots of dir trees that
> get spread across the disk in general.  New non-dir inodes also tend =
to
> stay close to their parent.  (I think I have that all right ...)

Note that this policy of new subdirectory placement (and indirectly the=
 placement of files created therein) can be tuned by userspace by setti=
ng the "topdir" flag via setattr on the parent directory.=20

This will push new subdirs created in that dir to a new group, which wo=
uld In turn allow the files to allocate from that group. It is intended=
 to be set on directories like /home where files within the subdirs are=
 unrelated.

Whether that is enough for your usage is unclear.=20

> The test you describe above does result in more contiguous allocation=
 on
> xfs than on ext4, though - a quick check on kernel 3.2 yielded 2-3
> extents per file on ext4, 1 extent per file for xfs.
>=20
> -Eric
>=20
>> Thanks & Regards,
>> Amit Sahrawat
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
