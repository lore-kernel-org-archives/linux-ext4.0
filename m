From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: fstrim has no effect on a just-mounted filesystem
Date: Wed, 12 Mar 2014 10:17:44 +0000
Message-ID: <20140312100507.GA19635@redhat.com>
References: <20140311213932.GA19176@redhat.com>
 <531F8456.2020404@redhat.com>
 <20140311220013.GV1346@redhat.com>
 <531F8953.1030702@redhat.com>
 <20140311225932.GW1346@redhat.com>
 <20140311230715.GA19648@redhat.com>
 <531F97A8.2020905@redhat.com>
 <20140311233047.GX1346@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="lc9FT7cWel8HagAv"
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>, pbonzini@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162AbaCLKRq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Mar 2014 06:17:46 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s2CAHkua002388
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 12 Mar 2014 06:17:46 -0400
Content-Disposition: inline
In-Reply-To: <20140311233047.GX1346@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--lc9FT7cWel8HagAv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 11, 2014 at 11:30:47PM +0000, Richard W.M. Jones wrote:
> On Tue, Mar 11, 2014 at 06:09:28PM -0500, Eric Sandeen wrote:
> > On Tue, Mar 11, 2014, Richard W.M. Jones wrote:
> > > However just the act of doing the tracing *caused* the trim to happen
> > > properly in the underlying disk.
> > 
> > that sounds very strange...
> 
> Thanks Eric.
> 
> FYI the libguestfs / virt-sparsify patch series that motivates this is
> here:
> 
> https://www.redhat.com/archives/libguestfs/2014-March/thread.html#00091
> 
> Even with the greatly reduced set of traces (see attached), just the
> act of tracing seems to have made trimming work properly.  The output
> file has been trimmed properly from 926 MB to 819 MB:

I did a bit more testing on this.

It appears we are sure that the ext4 ioctl FITRIM is sending discard
requests.

However fstrim doesn't happen reliably.

  fstrim + blktrace       works reliably
  fstrim + fsync          unreliable, usually fails to trim
  fstrim + sync           unreliable, usually fails to trim
  fstrim + umount         unreliable, usually fails to trim
  fstrim + sleep 10       unreliable, usually fails to trim
  ( fstrim + sleep 10 ) x 3  unreliable, usually fails to trim
  fstrim on its own       unreliable, usually fails to trim

Somewhere, the discard requests are disappearing in the stack (or more
likely, being delayed).  blktrace/trace-cmd somehow forces them out.
But fsync/sync/umount/sleep does not.  They might be stuck in qemu too ...

Is there any further test I can try here?

Is there a way to force out discard requests?

qemu cache mode is set to writeback.

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
virt-top is 'top' for virtual machines.  Tiny program with many
powerful monitoring features, net stats, disk stats, logging, etc.
http://people.redhat.com/~rjones/virt-top

--lc9FT7cWel8HagAv
Content-Type: application/x-perl
Content-Disposition: attachment; filename="test-fstrim.pl"
Content-Transfer-Encoding: quoted-printable

#!/usr/bin/perl=0A# Copyright (C) 2014 Red Hat Inc.=0A#=0A# This program is=
 free software; you can redistribute it and/or modify=0A# it under the term=
s of the GNU General Public License as published by=0A# the Free Software F=
oundation; either version 2 of the License, or=0A# (at your option) any lat=
er version.=0A#=0A# This program is distributed in the hope that it will be=
 useful,=0A# but WITHOUT ANY WARRANTY; without even the implied warranty of=
=0A# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the=0A# GNU =
General Public License for more details.=0A#=0A# You should have received a=
 copy of the GNU General Public License=0A# along with this program; if not=
, write to the Free Software=0A# Foundation, Inc., 51 Franklin Street, Fift=
h Floor, Boston, MA 02110-1301 USA.=0A=0A# Test that fstrim works.=0A=0Ause=
 strict;=0Ause warnings;=0A=0Ause Sys::Guestfs;=0A=0A# Since we read error =
messages, we want to ensure they are printed=0A# in English, hence:=0A$ENV{=
"LANG"} =3D "C";=0A=0A$| =3D 1;=0A=0Aif ($ENV{SKIP_TEST_FSTRIM_PL}) {=0A   =
 print "$0: skipped test because environment variable is set\n";=0A    exit=
 77;=0A}=0A=0Amy $g =3D Sys::Guestfs->new ();=0A=0A# Discard is only suppor=
ted when using qemu.=0Aif ($g->get_backend () ne "libvirt" &&=0A    $g->get=
_backend () !~ /^libvirt:/ &&=0A    $g->get_backend () ne "direct") {=0A   =
 print "$0: skipped test because discard is only supported when using qemu\=
n";=0A    exit 77;=0A}=0A=0A# You can set this to "raw" or "qcow2".=0Amy $f=
ormat =3D "raw";=0A=0A# Size needs to be at least 32 MB so we can fit an ex=
t4 filesystem on it.=0Amy $size =3D 64 * 1024 * 1024;=0A=0Amy $disk;=0Amy @=
args;=0Aif ($format eq "raw") {=0A    $disk =3D "test-fstrim.img";=0A    @a=
rgs =3D ( preallocation =3D> "sparse" );=0A} elsif ($format eq "qcow2") {=
=0A    $disk =3D "test-fstrim.qcow2";=0A    @args =3D ( preallocation =3D> =
"off", compat =3D> "1.1" );=0A} else {=0A    die "$0: invalid disk format: =
$format\n";=0A}=0A=0A# Create a disk and add it with discard enabled.  This=
 is allowed to=0A# fail, eg because qemu is too old, but libguestfs must te=
ll us that=0A# it failed (since we're using 'enable', not 'besteffort').=0A=
$g->disk_create ($disk, $format, $size, @args);=0AEND { unlink ($disk); };=
=0A=0Aeval {=0A    $g->add_drive ($disk, format =3D> $format, readonly =3D>=
 0, discard =3D> "enable");=0A    $g->launch ();=0A};=0Aif ($@) {=0A    if =
($@ =3D~ /discard cannot be enabled on this drive/) {=0A        # This is O=
K.  Libguestfs says it's not possible to enable=0A        # discard on this=
 drive (eg. because qemu is too old).  Print=0A        # the reason and ski=
p the test.=0A        print "$0: skipped test: $@\n";=0A        exit 77;=0A=
    }=0A    die # propagate the unexpected error=0A}=0A=0A# Is fstrim avail=
able in the appliance?=0Aunless ($g->feature_available (["fstrim"])) {=0A  =
  print "$0: skipped test because fstrim is not available\n";=0A    exit 77=
;=0A}=0A=0A# At this point we've got a disk which claims to support discard=
=2E=0A# Let's test that theory.=0A=0Amy $orig_size =3D (stat ($disk))[12];=
=0Aprint "original size:\t$orig_size (blocks)\n";=0A#system "du -sh $disk";=
=0A=0A# Write a filesystem onto the disk and fill it with data.=0A=0A$g->mk=
fs ("ext4", "/dev/sda");=0A# Use nodiscard here so the 'rm' below doesn't d=
iscard data.=0A$g->mount_options ("nodiscard", "/dev/sda", "/");=0A$g->fill=
 (33, 10000000, "/data");=0A$g->sync ();=0A=0Amy $full_size =3D (stat ($dis=
k))[12];=0Aprint "full size:\t$full_size (blocks)\n";=0A#system "du -sh $di=
sk";=0A=0Adie "surprising result: full size <=3D original size"=0A    if $f=
ull_size <=3D $orig_size;=0A=0A# Remove the file and then try to trim the f=
ilesystem.=0A=0A$g->rm ("/data");=0A$g->fstrim ("/");=0A$g->sync ();=0A$g->=
close ();=0A=0Amy $trimmed_size =3D (stat ($disk))[12];=0Aprint "trimmed si=
ze:\t$trimmed_size (blocks)\n";=0A#system "du -sh $disk";=0A=0Adie "looks l=
ike the fstrim operation did not work"=0A    if $trimmed_size >=3D $full_si=
ze;=0A
--lc9FT7cWel8HagAv--
