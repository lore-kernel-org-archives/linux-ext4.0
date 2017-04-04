From: NeilBrown <neilb@suse.com>
Subject: Re: [RFC PATCH 0/4] fs: introduce new writeback error tracking infrastructure and convert ext4 to use it
Date: Wed, 05 Apr 2017 08:41:15 +1000
Message-ID: <87mvbviyno.fsf@notabene.neil.brown.name>
References: <20170331192603.16442-1-jlayton@redhat.com> <87fuhqkti0.fsf@notabene.neil.brown.name> <1491215318.2724.3.camel@redhat.com> <20170403143257.GA30811@bombadil.infradead.org> <1491241657.2673.10.camel@redhat.com> <20170403191602.GF30811@bombadil.infradead.org> <1491250577.2673.20.camel@redhat.com> <87h924kh6t.fsf@notabene.neil.brown.name> <1491306070.20445.2.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, akpm@linux-foundation.org,
        tytso@mit.edu, jack@suse.cz
To: Jeff Layton <jlayton@redhat.com>,
        Matthew Wilcox <willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1491306070.20445.2.camel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 04 2017, Jeff Layton wrote:

> On Tue, 2017-04-04 at 13:03 +1000, NeilBrown wrote:
>> On Mon, Apr 03 2017, Jeff Layton wrote:
>>=20
>> > On Mon, 2017-04-03 at 12:16 -0700, Matthew Wilcox wrote:
>> > > On Mon, Apr 03, 2017 at 01:47:37PM -0400, Jeff Layton wrote:
>> > > > > I wonder whether it's even worth supporting both EIO and ENOSPC =
for a
>> > > > > writeback problem.  If I understand correctly, at the time of wr=
ite(),
>> > > > > filesystems check to see if they have enough blocks to satisfy t=
he
>> > > > > request, so ENOSPC only comes up in the writeback context for th=
inly
>> > > > > provisioned devices.
>> > > >=20
>> > > > No, ENOSPC on writeback can certainly happen with network filesyst=
ems.
>> > > > NFS and CIFS have no way to reserve space. You wouldn't want to ha=
ve to
>> > > > do an extra RPC on every buffered write. :)
>> > >=20
>> > > Aaah, yes, network filesystems.  I would indeed not want to do an ex=
tra
>> > > RPC on every write to a hole (it's a hole vs non-hole question, rath=
er
>> > > than a buffered/unbuffered question ... unless you're WAFLing and not
>> > > reclaiming quickly enough, I suppose).
>> > >=20
>> > > So, OK, that makes sense, we should keep allowing filesystems to rep=
ort
>> > > ENOSPC as a writeback error.  But I think much of the argument below
>> > > still holds, and we should continue to have a prior EIO to be report=
ed
>> > > over a new ENOSPC (even if the program has already consumed the EIO).
>> > >=20
>> >=20
>> > I'm fine with that (though I'd like Neil's thoughts before we decide
>> > anything) there.
>>=20
>> I'd like there be a well defined time when old errors were forgotten.
>> It does make sense for EIO to persist even if ENOSPC or EDQUOT is
>> received, but not forever.
>> Clearing the remembered errors when put_write_access() causes
>> i_writecount to reach zero is one option (as suggested), but I'm not
>> sure I'm happy with it.
>>=20
>> Local filesystems, or network filesystems which receive strong write
>> delegations, should only ever return EIO to fsync.  We should
>> concentrate on them first, I think.  As there is only one possible
>> error, the seq counter is sufficient to "clear" it once it has been
>> reported to fsync() (or write()?).
>>=20
>> Other network filesystems could return a whole host of errors: ENOSPC
>> EDQUOT ESTALE EPERM EFBIG ...
>> Do we want to limit exactly which errors are allowed in generic code, or
>> do we just support EIO generically and expect the filesystem to sort out
>> the details for anything else?
>>=20
>> One possible approach a filesystem could take is just to allow a single
>> async writeback error.  After that error, all subsequent write()
>> system calls become synchronous. As write() or fsync() is called on each
>> file descriptor (which could possibly have sent the write which caused
>> the error), an error is returned and that fact is counted.  Once we have
>> returned as many errors as there are open file descriptors
>> (i_writecount?), and have seen a successful write, the filesystem
>> forgets all recorded errors and switches back to async writes (for that
>> inode).   NFS does this switch-to-sync-on-error.  See nfs_need_check_wri=
te().
>>=20
>> The "which could possibly have sent the write which caused the error" is
>> an explicit reference to NFS.  NFS doesn't use the AS_EIO/AS_ENOSPC
>> flags to return async errors.  It allocates an nfs_open_context for each
>> user who opens a given inode, and stores an error in there.  Each dirty
>> pages is associated with one of these, so errors a sure to go to the
>> correct user, though not necessarily the correct fd at present.
>>=20
>> When we specify the new behaviour we should be careful to be as vague as
>> possible while still saying what we need.  This allows filesystems some
>> flexibility.
>>=20
>>   If an error happens during writeback, the next write() or fsync() (or
>>   ....) on the file descriptor to which data was written will return -1
>>   with errno set to EIO or some other relevant error.  Other file
>>   descriptors open on the same file may receive EIO or some other error
>>   on a subsequent appropriate system call.
>>   It should not be assumed that close() will return an error.  fsync()
>>   must be called before close() if writeback errors are important to the
>>   application.
>>=20
>>=20
>
> A lot in here... :)
>
> While I like the NFS method of switching to sync I/O on error (and
> indeed, I'm copying that in the Ceph ENOSPC patches I have), I'm not
> sure it would really help anything here. The main reason NFS does that
> is to prevent you from dirtying tons of pages that can't be cleaned.=C2=A0

It would help because it means there are no longer any async errors, so
there is no need to try to keep track of them.

If we decided that "last error wins", then that becomes irrelevant.  But
if we do care about any precedence of errors, then going sync is an easy
way to make sure the right error gets to the right place.

>
> While that is a laudable goal, it's not really the problem I'm
> interested in solving here. My goal is simply to ensure that you see a
> writeback error on fsync if one occurred since the last fsync.
>
> I think it just comes down to the fact that I'm not convinced that it
> really matters much _what_ error gets reported, as long as you get one.
> As you've mentioned in earlier discussions, most programs just treat it
> as a fatal error anyway. As long as that error is representative of
> some error that occurred during writeback, do we really care what it
> was?

I don't think I personally care at all, but there might be programs out
there...
I think it would be a good design goal to ensure that the behaviour seen
when there is only one open file descriptor on a file, remains
unchanged.
That means that file the fd is help open, multiple different error codes
can be returned in arbitrary order (unlikely, but possible).

Thanks,
NeilBrown


>
> Suppose we have a bunch of dirty pages on an inode, get an EIO error
> and then ENOSPC on a different write (maybe issued in parallel). We
> send the ENOSPC error back to the application on an fsync (since it
> came in last). Application then cleans out some junk from the fs and
> then reissues the writes. They fail again and then he gets EIO from the
> fsync and aborts.
>
> Ok, so we might not have had to clean out the files and reissue the
> writes there since we were going to give up anyway. Is it worth going
> to extra lengths to avoid that there, given that we're in an error
> condition anyway?
>
> I'm just trying to understand why it matters at all what error you get
> back when there multiple problems. They all seem equally valid to me in
> that situation.
>
> --=20
> Jeff Layton <jlayton@redhat.com>

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljkIQsACgkQOeye3VZi
gbk5xg//XaqSamoyFPcnasHVwzYcEA75Rpe1ehFC63EfJQ8oSbK3AkUQ+dXzwJg+
ja6djqZZJpQDCVqgjENWCL7KSocgYQCQqkpjqEEd5+Xsu7m8QvbZfDHnhf621Qj4
bWfV5yODeyy6I+UhmvslTTfo6Q2rNCtO5a7Ou6mK5oyRAPklaVz47IGKqeRTK833
s2fIml31kL52FEkiwxs/dhXfcBy1UYjUGutZUaqYz2TLyCQ1QKTj1w7d+J5vDvL5
Jf0yiV/TtIlUCL5VMkgLb9z9fg4r6N9w6ZwQPYNz7gihv/KIPmcfAk+bxL1HHXJq
pwbrSov61zkKLlBaooBf0BfGncleJQmdwOFyP1UAf/jmvruDoNvkjBEj16LhoHyD
ksCUewpuIW3wCPvpRjoBYvcL7W9Lo/qCDb2aQrdifeGrsDkGM+juRsiH1Df8n7Uj
I4PQaXgY5Ycq/1WnCCK+VJUTIPlzjIXm326ljrig1nizjqjLj4MhbZyRuNyTPIK3
MUTX/Mku3KuxWrD1Hbef6qgWfsjv5EVXwrGLS1wpAni924gHafL++Nhli+uxgE4Y
xxUo71a0qhKIo/2xpDwun19XhCmFVsaW5z+Mz/Wr/De+W07DDOox2wulox5xPCaB
3eF2Jg7JFiTxDvYUD78y5Otn5/fwwZR5kIqol64u/U5H5OfolbM=
=anxp
-----END PGP SIGNATURE-----
--=-=-=--
