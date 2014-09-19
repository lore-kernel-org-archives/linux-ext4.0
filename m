From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Reserved GDT inode: blocks vs extents
Date: Fri, 19 Sep 2014 13:48:24 -0600
Message-ID: <ACA922D4-F6A6-4BD6-92CE-39CA97538B1E@dilger.ca>
References: <BAY406-EAS150EB9E4098E2894ADA30B7FDB40@phx.gbl>,<20140919163649.GQ26995@thunk.org> <BAY179-W495E3AE101B78A7CAA43BAFDB40@phx.gbl>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: multipart/signed; boundary="Apple-Mail=_16895796-C6E5-4DBA-A79B-7BED3F79BE65"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Theodore Ts'o <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: TR Reardon <thomas_reardon@hotmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:41231 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080AbaISTr7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Sep 2014 15:47:59 -0400
Received: by mail-pd0-f169.google.com with SMTP id w10so546036pde.28
        for <linux-ext4@vger.kernel.org>; Fri, 19 Sep 2014 12:47:58 -0700 (PDT)
In-Reply-To: <BAY179-W495E3AE101B78A7CAA43BAFDB40@phx.gbl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_16895796-C6E5-4DBA-A79B-7BED3F79BE65
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=iso-8859-1

On Sep 19, 2014, at 11:26 AM, TR Reardon <thomas_reardon@hotmail.com> =
wrote:
>> Date: Fri, 19 Sep 2014 12:36:49 -0400
>> From: tytso@mit.edu
>> To: thomas_reardon@hotmail.com
>> CC: linux-ext4@vger.kernel.org
>> Subject: Re: Reserved GDT inode: blocks vs extents
>>=20
>> On Fri, Sep 19, 2014 at 11:54:39AM -0400, TR Reardon wrote:
>>> Hello all: there's probably a good reason for this, but I'm =
wondering why inode#7 (reserved GDT blocks) is always created with a =
block map rather than extent?
>>>=20
>>> [see ext2fs_create_resize_inode()]
>>=20
>> But that may be moot, since one of the things that I've been
>> considering is to stop pinning the block group descriptors in memory,
>> and just start reading in memory as they are needed. The rationale is
>> that for a 4TB disk, we're burning 8 MB of memory. And if you have
>> two dozen disks attached to your system, then you're burning 192
>> megabytes of memory, which starts to fairly significant amounts of
>> memory, especially for bookcase NAS servers.
>=20
> But I'd argue that in many use cases, in particular bookcase NAS =
servers,=20
> ext4+vfs should optimize for avoiding spinups rather than reducing RAM =
usage.=20
> Would this change increase spinups when scanning for changes, say via =
rsync?

I think not pinning the group descriptors would be a bad thing.  If
we consider that reading block allocation bitmaps to be slow, then it
would be twice as slow having to read the group descriptor from disk
before even knowing which groups have free space for allocation.

I think this kind of change only makes sense if there is some other
in-memory structure (e.g. rbtree) to describe the free space in the
filesystem.  That would be a net win, since we wouldn't have to scan
potentially thousands of groups to find free space.

Cheers, Andreas






--Apple-Mail=_16895796-C6E5-4DBA-A79B-7BED3F79BE65
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVByIiHKl2rkXzB/gAQLY3w/9H8ej1tYHGj86bBvhIraxnIrnA7i7HYbV
ch/vka9WVsw8vJjAIIOVccsqg00Sb4fL5MWVZ1fgZvDyh3OOYg4p52inZGrhtaOz
+L4OLdvMByc1EAlHcDsJvvoH2ExhaNz90yGgEh4hNONwYAUwgYmiV/emYkuGzZpD
DR2Q1AAuPWRBpRBROpQX9SBPTxSpYANhkmwvX5S2wGmR3eSsOY7qw+Yo+A60U6AP
EKySan3kXKfCOrk6QGd7e9XHm5WQRW9EVupCk7ev5iGOYqrrzaG+ik3xTSSbAI4i
VNE6jPebBo705YuGEaqzn092vXhsw6vwSkQxXh9JnzQblV3oTw25UQafsR7I4w4n
56J4u5XDRyjLqrSgVU2Zb4s9xhfd9lcurcSu4npB2b894jjRz3RRQDJXryfDMvt1
2Ai0QQEFnNDn3gQzVSB+6uSDEKvUy4mD37tcBFpGaGw29ewwFl+BrrkT4q9VgrlF
HG2Kk5inHHUuXnhlKQcDTb+PUh/z7mvr4JjpZLqWt3KxeQ3q3ezTIMGdV6fwd9t1
2kJtW7s6rxTmnsbRPikL3UwfVadP0MMWzoVC8YZkHjMKylEA+hCrEM5wp5FSR34+
/8+lT2iV2leX6YbLz7dh7RRsTdAcveKahVjsxufLRbCA+6ohtv1FiWvKeJRP6Oc6
5LRs8rB3o9s=
=xbO3
-----END PGP SIGNATURE-----

--Apple-Mail=_16895796-C6E5-4DBA-A79B-7BED3F79BE65--
