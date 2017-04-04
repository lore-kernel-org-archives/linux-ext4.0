From: NeilBrown <neilb@suse.com>
Subject: Re: [RFC PATCH 0/4] fs: introduce new writeback error tracking infrastructure and convert ext4 to use it
Date: Tue, 04 Apr 2017 13:03:22 +1000
Message-ID: <87h924kh6t.fsf@notabene.neil.brown.name>
References: <20170331192603.16442-1-jlayton@redhat.com> <87fuhqkti0.fsf@notabene.neil.brown.name> <1491215318.2724.3.camel@redhat.com> <20170403143257.GA30811@bombadil.infradead.org> <1491241657.2673.10.camel@redhat.com> <20170403191602.GF30811@bombadil.infradead.org> <1491250577.2673.20.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, akpm@linux-foundation.org,
        tytso@mit.edu, jack@suse.cz
To: Jeff Layton <jlayton@redhat.com>,
        Matthew Wilcox <willy@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1491250577.2673.20.camel@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 03 2017, Jeff Layton wrote:

> On Mon, 2017-04-03 at 12:16 -0700, Matthew Wilcox wrote:
>> On Mon, Apr 03, 2017 at 01:47:37PM -0400, Jeff Layton wrote:
>> > > I wonder whether it's even worth supporting both EIO and ENOSPC for a
>> > > writeback problem.  If I understand correctly, at the time of write(=
),
>> > > filesystems check to see if they have enough blocks to satisfy the
>> > > request, so ENOSPC only comes up in the writeback context for thinly
>> > > provisioned devices.
>> >=20
>> > No, ENOSPC on writeback can certainly happen with network filesystems.
>> > NFS and CIFS have no way to reserve space. You wouldn't want to have to
>> > do an extra RPC on every buffered write. :)
>>=20
>> Aaah, yes, network filesystems.  I would indeed not want to do an extra
>> RPC on every write to a hole (it's a hole vs non-hole question, rather
>> than a buffered/unbuffered question ... unless you're WAFLing and not
>> reclaiming quickly enough, I suppose).
>>=20
>> So, OK, that makes sense, we should keep allowing filesystems to report
>> ENOSPC as a writeback error.  But I think much of the argument below
>> still holds, and we should continue to have a prior EIO to be reported
>> over a new ENOSPC (even if the program has already consumed the EIO).
>>=20
>
> I'm fine with that (though I'd like Neil's thoughts before we decide
> anything) there.

I'd like there be a well defined time when old errors were forgotten.
It does make sense for EIO to persist even if ENOSPC or EDQUOT is
received, but not forever.
Clearing the remembered errors when put_write_access() causes
i_writecount to reach zero is one option (as suggested), but I'm not
sure I'm happy with it.

Local filesystems, or network filesystems which receive strong write
delegations, should only ever return EIO to fsync.  We should
concentrate on them first, I think.  As there is only one possible
error, the seq counter is sufficient to "clear" it once it has been
reported to fsync() (or write()?).

Other network filesystems could return a whole host of errors: ENOSPC
EDQUOT ESTALE EPERM EFBIG ...
Do we want to limit exactly which errors are allowed in generic code, or
do we just support EIO generically and expect the filesystem to sort out
the details for anything else?

One possible approach a filesystem could take is just to allow a single
async writeback error.  After that error, all subsequent write()
system calls become synchronous. As write() or fsync() is called on each
file descriptor (which could possibly have sent the write which caused
the error), an error is returned and that fact is counted.  Once we have
returned as many errors as there are open file descriptors
(i_writecount?), and have seen a successful write, the filesystem
forgets all recorded errors and switches back to async writes (for that
inode).   NFS does this switch-to-sync-on-error.  See nfs_need_check_write(=
).

The "which could possibly have sent the write which caused the error" is
an explicit reference to NFS.  NFS doesn't use the AS_EIO/AS_ENOSPC
flags to return async errors.  It allocates an nfs_open_context for each
user who opens a given inode, and stores an error in there.  Each dirty
pages is associated with one of these, so errors a sure to go to the
correct user, though not necessarily the correct fd at present.

When we specify the new behaviour we should be careful to be as vague as
possible while still saying what we need.  This allows filesystems some
flexibility.

  If an error happens during writeback, the next write() or fsync() (or
  ....) on the file descriptor to which data was written will return -1
  with errno set to EIO or some other relevant error.  Other file
  descriptors open on the same file may receive EIO or some other error
  on a subsequent appropriate system call.
  It should not be assumed that close() will return an error.  fsync()
  must be called before close() if writeback errors are important to the
  application.


Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljjDPoACgkQOeye3VZi
gbndIA//YgTZ3y6uCO5ziAYokQ6zEqnkH5Xp+qgttnOVS9RVefTULvYVV+cSjzOf
C5jejRGe6hT+7LYubT+YZ+YZCc6KOlKg16Z0SGNe0A8zByG9FR0jE+fsCXeexLUq
fJu7p4n50kFjwRUYQuI2zHDxwR9HTa4XbbmUvQOz9UnhjVXkaT+Oz6x4xsOul5bM
r2yEzYWn1N6oB35pDO377nKFRQC0tU3gxi6i6Kzoli7i8lvzlW/G+1Pj8cz9/kgJ
MPpqNCsMvivDPBmo3044qHiosanwRrBRX398ojsSxCA03GUuQtA4Q11lIQXkjt59
d779wEvUpqneKVuBxIcLmIa98s3AuYzb0yjaRv5xgPaQeuTOzz7FDSDr3jaOX7Xc
4f7aGyYI8UVMeFftEvon3K9e4xZF2Cl+sztF2BWoumAiOILpVN3vOom51yxZdEeB
C5qwpEysbB+YZkjWiuUviQdDbUvxlh7DyzFBliNwx6CH5KzY/UsP6nbQPFfi+ccJ
gpEZyR4mxnVp7LOT/NFSg9/JaZb6jKaoeBIf2/Wv06I6H0oGuV5O+V5ZXG3vtipm
cfX2IxjpCVNhBMSWAF/hX/0j/FA10SVBAwpIAXb6Qa05+1uQyBYvH1oy61V9R4TC
mEykTuMNEqVrsfJF/xMwbMHpl5Cd3iaMFjdakVxum0E9B1hUpfc=
=epHB
-----END PGP SIGNATURE-----
--=-=-=--
