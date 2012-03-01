From: Chris Mason <chris.mason@oracle.com>
Subject: Re: getdents - ext4 vs btrfs performance
Date: Thu, 1 Mar 2012 09:38:59 -0500
Message-ID: <20120301143859.GX5054@shiny>
References: <CADDYkjS5VJeYyHzqumazQ0qKg+HwA6GO+zYSJj7rkHNZFwjcoQ@mail.gmail.com>
 <E15A491F-62E2-4518-939F-07B3AB4C3E65@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jacek Luczak <difrost.kernel@gmail.com>,
	linux-ext4@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <E15A491F-62E2-4518-939F-07B3AB4C3E65@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Feb 29, 2012 at 11:44:31PM -0500, Theodore Tso wrote:
> You might try sorting the entries returned by readdir by inode number=
 before you stat them.    This is a long-standing weakness in ext3/ext4=
, and it has to do with how we added hashed tree indexes to directories=
 in (a) a backwards compatible way, that (b) was POSIX compliant with r=
espect to adding and removing directory entries concurrently with readi=
ng all of the directory entries using readdir.
>=20
> You might try compiling spd_readdir from the e2fsprogs source tree (i=
n the contrib directory):
>=20
> http://git.kernel.org/?p=3Dfs/ext2/e2fsprogs.git;a=3Dblob;f=3Dcontrib=
/spd_readdir.c;h=3Df89832cd7146a6f5313162255f057c5a754a4b84;hb=3Dd9a5d3=
7535794842358e1cfe4faa4a89804ed209
>=20
> =E2=80=A6 and then using that as a LD_PRELOAD, and see how that chang=
es things.
>=20
> The short version is that we can't easily do this in the kernel since=
 it's a problem that primarily shows up with very big directories, and =
using non-swappable kernel memory to store all of the directory entries=
 and then sort them so they can be returned in inode number just isn't =
practical.   It is something which can be easily done in userspace, tho=
ugh, and a number of programs (including mutt for its Maildir support) =
does do, and it helps greatly for workloads where you are calling readd=
ir() followed by something that needs to access the inode (i.e., stat, =
unlink, etc.)
>=20

=46or reading the files, the acp program I sent him tries to do somethi=
ng
similar.  I had forgotten about spd_readdir though, we should consider
hacking that into cp and tar.

One interesting note is the page cache used to help here.  Picture two
tests:

A) time tar cf /dev/zero /home

and

cp -a /home /new_dir_in_new_fs
unmount / flush caches
B) time tar cf /dev/zero /new_dir_in_new_fs

On ext, The time for B used to be much faster than the time for A
because the files would get written back to disk in roughly htree order=
=2E
Based on Jacek's data, that isn't true anymore.

-chris
