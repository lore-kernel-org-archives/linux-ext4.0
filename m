From: Andreas Dilger <adilger@sun.com>
Subject: Re: Tool to view extent metadata
Date: Mon, 13 Jul 2009 13:27:15 -0600
Message-ID: <20090713192715.GN12939@webber.adilger.int>
References: <23904f640907091517w10608fa4y9b3b8b3a631217c@mail.gmail.com>
 <20090709225507.GH5073@webber.adilger.int>
 <23904f640907130803w20089c79md6f6ceef54ff8f8e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Manuel Benitez <rickyb@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:57626 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbZGMT1n (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Jul 2009 15:27:43 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n6DJRSoe029921
	for <linux-ext4@vger.kernel.org>; Mon, 13 Jul 2009 12:27:40 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KMQ00B00J9KDK00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Mon,
 13 Jul 2009 12:27:28 -0700 (PDT)
In-reply-to: <23904f640907130803w20089c79md6f6ceef54ff8f8e@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jul 13, 2009  08:03 -0700, Manuel Benitez wrote:
> Thank you for the reply. I wrote a program that uses FIEMAP to see
> what I could get from it. It gives the same information that you can
> extract from FIBMAP except that it is much more efficient (one ioctl
> call per extent rather than one call per block). Unfortunately, it
> does not give much insight into the structure of the metadata, so
> there is no way to tell how efficiently the metadata represents the
> file (depth of extent tree, number of internal and leaf nodes, etc.).

It would also be possible to extend the FIEMAP interface to return
metadata by adding a new FIEMAP_FLAG_METADATA and then have the
metadata "extents" be marked with a new FIEMAP_EXTENT_METADATA.

In my previous musings on this topic, I thought it would make sense
to have the "extent" of e.g. an index block be the the logical range
of the file that this index block covers.  The inode itself might be
marked with FIEMAP_EXTENT_INODE|FIEMAP_EXTENT_METADATA and cover the
entire logical range of the file.

This would essentially allow the caller to generate a tree of the
metadata by heirarchical ordering of the extent ranges.


> On Thu, Jul 9, 2009 at 3:55 PM, Andreas Dilger<adilger@sun.com> wrote=
:
> > On Jul 09, 2009 =A015:17 -0700, Manuel Benitez wrote:
> >> I'm currently evaluating the ext4 allocator and one thing I've com=
e
> >> across is the lack of a tool that displays the exact structure of =
the
> >> extents making up a file. I've found plenty of tools that will tel=
l me
> >> how many contiguous segments a file contains, but nothing so far t=
o
> >> let me see the actual makeup of the extents that map the inode to =
the
> >> blocks that comprise the file. Have I just missed something obviou=
s,
> >> or would this be something worth me spending some time doing?
> >>
> >> If so, one option would be to either modify the stat command or ad=
d a
> >> similar command in debugfs to show the extents from the roots thro=
ugh
> >> the root down to the leafs. Anyone have preferences or opinions?
> >
> > The "filefrag" tool in recent e2fsprogs should provide such informa=
tion,
> > using the FIEMAP ioctl to extract extent information from the kerne=
l.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
