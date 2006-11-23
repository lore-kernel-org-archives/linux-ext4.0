From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: Ext4 devel interlock meeting minutes (Nov. 22 2006)
Date: Wed, 22 Nov 2006 18:13:28 -0700
Message-ID: <20061123011328.GI6012@schatzie.adilger.int>
References: <1164232428.29430.27.camel@dyn9047017105.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:18829 "EHLO
	mail.clusterfs.com") by vger.kernel.org with ESMTP id S1757236AbWKWBNb
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 22 Nov 2006 20:13:31 -0500
To: Avantika Mathur <mathur@us.ibm.com>
Content-Disposition: inline
In-Reply-To: <1164232428.29430.27.camel@dyn9047017105.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Nov 22, 2006  13:53 -0800, Avantika Mathur wrote:
> Attendees: Mingming Cao, Eric Sandeen, Suparna Bhattacharya, Takashi =
Sato, Jean-Pierre Dion, Val=E9rie Cl=E9ment, Avantika Mathur

Sorry for missing recent calls, it has been very busy here and I was si=
ck,
so extra sleep won over getting up early for the concall :-/.

> - Online Defrag:
>  -- Last week we determined that ioctl was the preferred=20
> interface for the online defrag.
>  -- Eric will send out an ovreview of the steps completed by XFS for =
file defragmentation.
>  -- Last week Eric said that in XFS defrag implementation, you can't =
defrag a file that is open/being written to.  This was an incorrect ass=
umption. There will be more explanation in his mail.

This is also something CFS is interested in and looking to work on.  We
would be focussing on defragmentation of extent-mapped files.

> - Preallocation:
>  -- We need to decide which interface to use in the implementation
>    * ioctl: simple solution preferred method for defrag and user in r=
eservation
>    * posix_fallocate: writes zero to the first byte of every block; p=
robably preferred solution
>    * ftruncate: consistency across platforms may be an issue

And it also has compatibility issues because e.g. dd will truncate the =
file
to the new size and then start writing, when using "skip=3DNNN":

dd if=3D/dev/zero of=3D/tmp/foo bs=3D4k count=3D1 skip=3D100

open("/dev/null", O_RDONLY|O_LARGEFILE) =3D 0
open("/tmp/foo", O_RDWR|O_CREAT|O_LARGEFILE, 0666) =3D 1
fstat64(1, {st_mode=3DS_IFREG|0664, st_size=3D0, ...}) =3D 0
ftruncate64(1, 409600)                  =3D 0

We don't necessarily want a common tool like dd to start allocating gob=
s
of disk space when trying to make a sparse file.

> - Features we'd like to see in Ext4 before code freeze:
>  -- online defragmentation

Since online defragmentation doesn't require a format change, it likely
doesn't need to affect the ext4 code freeze.  This is doubly true becau=
se
it is a relatively new topic and there is likely significant upstream
opposition by various individuals regardless of how we want to implemen=
t it.

>  -- big block group: Valerie has ported this to 2.6.19-rc6 and will s=
end patches to the list tomorrow, and put updated e2fsprogs patches on =
Bull web site.
>  -- large inode default for ext4

Was inode version proposed for inclusion?

>  -- large file support: Current max file size is 2 TB. Increase limit=
 to 16 TB by changing i_block ( patches have been sent by Takashi), the=
n increase to more than 16 TB.  Changing the i_block to break 2TB limit=
 may cause some application to break.

=46YI, there is already on-disk format changes for this in the e2fsprog=
s
mercurial repo.


Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
