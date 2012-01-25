From: Dave Chinner <david@fromorbit.com>
Subject: Re: Does Ext4 support parallel write similar to XFS?
Date: Thu, 26 Jan 2012 09:55:35 +1100
Message-ID: <20120125225535.GU15102@dastard>
References: <CADDb1s2w9ZwMXn38n8TcxhFNrUsXN1Gnxq-suAP2-M+R7YhFsg@mail.gmail.com>
 <4F202F2E.9000608@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Amit Sahrawat <amit.sahrawat83@gmail.com>, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:19600 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750832Ab2AYWzi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Jan 2012 17:55:38 -0500
Content-Disposition: inline
In-Reply-To: <4F202F2E.9000608@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 25, 2012 at 10:34:54AM -0600, Eric Sandeen wrote:
> On 1/24/12 11:19 PM, Amit Sahrawat wrote:
> > In XFS we can write parallel (i.,e we can make use of allocation
> > groups for writing process). If the files are kept in individual
> > directories, there is a possibility that first the blocks for that
> > files be used from individual allocation groups. If I start =E2=80=98=
4=E2=80=99
> > writing process(cp 100MB_file /<dirnum>/) =E2=80=93 after writing i=
s finished
> > =E2=80=93 if I check the bmap =E2=80=93 it does shows that initial =
allocation was from
> > individual allocation groups.
> > Even though in Ext4 also we do have groups =E2=80=93 but I am not a=
ble to get
> > behavior similar to XFS.
> > If I check the file extents =E2=80=93 the extents are in mixed form=
, the
> > allocation pattern is also very fragmented.
> >=20
> > Please share more on this. Also, if there is a possible exact test
> > case to check for parallel writes support.
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

XFs has different allocation policies according to mount options
used.  inode32 (default for > 1TB), inode64 (default for <1TB) and
filestreams. Each will give you different layouts for the same test
depending on the size of your filesystem and the amount of free
space you have available in it.

If XFS does what you want, then use it. There is no good reason for
trying to make ext4 do everything XFS does because it simply can't.
Especially when it comes to allocation strategies and policies...

Cheers,

Dave.
--=20
Dave Chinner
david@fromorbit.com
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
