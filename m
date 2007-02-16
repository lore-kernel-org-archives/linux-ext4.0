From: Cordenner jean noel <jean-noel.cordenner@bull.net>
Subject: Re: i_version_1_vfs_layer
Date: Fri, 16 Feb 2007 17:00:15 +0100
Message-ID: <45D5D50F.5090100@bull.net>
References: <20070215002656.a163dee9.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Ts'o <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:48198 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945956AbXBPQBw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Feb 2007 11:01:52 -0500
In-Reply-To: <20070215002656.a163dee9.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andrew Morton a =E9crit :
> This:
>=20
> ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/2.6.2=
0-ext4-1/broken-out/i_version_1_vfs_layer
>=20
> significantly deoptimises file_update_time() for major filesystems (e=
g, ext3).
>=20
> The changelog offers no reason for this alteration.  In fact the chan=
gelog
> basically says nothing at all and needs a lot of work.
>=20
> What is this patch doing and why does it need to make that change?
>=20

Actually, this set of patches are still in progress. I recently profile=
=20
them. It shows that the CPU usage is really huge, so it has to be impro=
ved.

The i_version field is a counter that is set on every inode creation an=
d
that is incremented every time the inode data is modified (similarly to
the "ctime" time-stamp).
The aim is to fulfill NFSv4 requirements for rfc3530.
=46or the moment, the counter is only a 32bit value but it is planned t=
o=20
be 64bit as required.

The patch is divided into 3 parts, the vfs layer, the ext4 specific cod=
e
and an user part to check i_version changes via stat.

(cf http://permalink.gmane.org/gmane.comp.file-systems.ext4/923)
