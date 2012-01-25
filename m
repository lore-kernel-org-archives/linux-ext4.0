From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Does Ext4 support parallel write similar to XFS?
Date: Wed, 25 Jan 2012 10:34:54 -0600
Message-ID: <4F202F2E.9000608@redhat.com>
References: <CADDb1s2w9ZwMXn38n8TcxhFNrUsXN1Gnxq-suAP2-M+R7YhFsg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: xfs@oss.sgi.com, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <david@fromorbit.com>
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37510 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752648Ab2AYQfJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Jan 2012 11:35:09 -0500
In-Reply-To: <CADDb1s2w9ZwMXn38n8TcxhFNrUsXN1Gnxq-suAP2-M+R7YhFsg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 1/24/12 11:19 PM, Amit Sahrawat wrote:
> In XFS we can write parallel (i.,e we can make use of allocation
> groups for writing process). If the files are kept in individual
> directories, there is a possibility that first the blocks for that
> files be used from individual allocation groups. If I start =914=92
> writing process(cp 100MB_file /<dirnum>/) =96 after writing is finish=
ed
> =96 if I check the bmap =96 it does shows that initial allocation was=
 from
> individual allocation groups.
> Even though in Ext4 also we do have groups =96 but I am not able to g=
et
> behavior similar to XFS.
> If I check the file extents =96 the extents are in mixed form, the
> allocation pattern is also very fragmented.
>=20
> Please share more on this. Also, if there is a possible exact test
> case to check for parallel writes support.

It seems that you are asking more about allocation policy than parallel=
ism
in general?  With either filesystem, you could use preallocation to win=
d
up with more contiguous files when you write them in parallel, though
that requires some idea of the file size ahead of time.

ext4 doesn't have that exact dir::group heuristic that xfs uses,
but it does have other mechanisms and heuristics to try to get good
file and directory layout.

In general, ext4 tries to put new root directories into new groups, see
comments above find_group_orlov().  Other directories tend to stay near
their parent directory.  So it's really the roots of dir trees that
get spread across the disk in general.  New non-dir inodes also tend to
stay close to their parent.  (I think I have that all right ...)

The test you describe above does result in more contiguous allocation o=
n
xfs than on ext4, though - a quick check on kernel 3.2 yielded 2-3
extents per file on ext4, 1 extent per file for xfs.

-Eric

> Thanks & Regards,
> Amit Sahrawat
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
