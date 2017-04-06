From: NeilBrown <neilb@suse.com>
Subject: Re: [RFC PATCH 0/4] fs: introduce new writeback error tracking infrastructure and convert ext4 to use it
Date: Thu, 06 Apr 2017 10:02:48 +1000
Message-ID: <87efx6tnbr.fsf@notabene.neil.brown.name>
References: <1491215318.2724.3.camel@redhat.com> <20170403143257.GA30811@bombadil.infradead.org> <1491241657.2673.10.camel@redhat.com> <20170403191602.GF30811@bombadil.infradead.org> <1491250577.2673.20.camel@redhat.com> <87h924kh6t.fsf@notabene.neil.brown.name> <20170404115358.GH30811@bombadil.infradead.org> <1491308268.20445.4.camel@redhat.com> <20170404161247.GJ30811@bombadil.infradead.org> <1491323146.309.1.camel@redhat.com> <20170404170909.GK30811@bombadil.infradead.org> <1491421792.18658.20.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, akpm@linux-foundation.org,
        tytso@mit.edu, jack@suse.cz
To: Jeff Layton <jlayton@redhat.com>,
        Matthew Wilcox <willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1491421792.18658.20.camel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 06 2017, Jeff Layton wrote:

> On Tue, 2017-04-04 at 10:09 -0700, Matthew Wilcox wrote:
>> On Tue, Apr 04, 2017 at 12:25:46PM -0400, Jeff Layton wrote:
>> > That said, I think giving more specific errors where we can is useful.
>> > When your program is erroring out and writing 'I/O error' to the logs,
>> > then how much time will your admins burn before they figure out that it
>> > really failed because the filesystem was full?
>>=20
>> df is one of the first things I check ... a few years ago, I also learned
>> to check df -i ... ;-)
>>=20
>> Anyway, given the decision to simply report the last error lets us do th=
is
>> implementation:
>>=20
>> void filemap_set_wb_error(struct address_space *mapping, int err)
>> {
>> 	struct inode *inode =3D mapping->host;
>> 	unsigned int wb_err;
>>=20
>> 	if (!err)
>> 		return;
>> 	/*
>> 	 * This should be called with the error code that we want to return
>> 	 * on fsync. Thus, it should always be <=3D 0.
>> 	 */
>> 	WARN_ON(err > 0 || err < -MAX_ERRNO);
>>=20
>> 	spin_lock(&inode->i_lock);
>> 	wb_err =3D ((mapping->wb_err & ~MAX_ERRNO) + (1 << 12)) | -err;
>> 	WRITE_ONCE(mapping->wb_err, wb_err);
>> 	spin_unlock(&inode->i_lock);
>> }
>>=20
>
> I like this idea of being able to store arbitrary error codes there.
> That should be used judiciously of course, but we already allow
> returning arbitrary errors via the ->fsync op anyway.
>
> I'll plan to incorporate something like that into the next set (with
> judicious comments and constants).
>
> One question...is the i_lock the right way to protect this? I think we
> could do this locklessly too (cmpxchg in a loop, for instance). I'm not
> worried about performance here -- it's just nice to be able to call
> simple stuff like this without worrying about locking.

I like the idea of using cmpxchg.


>
>> int filemap_report_wb_error(struct file *file)
>> {
>> 	struct inode *inode =3D file_inode(file);
>> 	unsigned int wb_err =3D READ_ONCE(mapping->wb_err);
>>=20
>> 	if (file->f_wb_err =3D=3D wb_err)
>> 		return 0;
>> 	return -(wb_err & 4095);
>> }
>>=20
>> That only gives us 20 bits of counter, but I think that's enough.
>
> 2^20 is 1048576, which seems a little small to me.
>
> We may end up bumping the counter on every failed I/O. How fast can we
> generate 1M failed I/Os? :)

Do we need to count all of those if no-one sees them?
i.e. use one bit to say "this error hasn't been seen".
If an error occurs with has the name error code as is currently stored,
and the bit is set, don't make a change.  Otherwise make the change,
inc the counter, set the bit.
When checking for an error, if the bit is set, clear it first.
Then you can count 500,000 errors-returned-to-some-thread, which is
probably enough.

>
> 2^52 however is 4503599627370496 (4Tios or so) ... that might take a
> little longer to overflow. Is it worth the cost here to ensure that
> this won't occur?
>
> Actually...we could put this field in the inode instead of the mapping.
> I know we've traditionally tracked this in the mapping, but is that
> required here?

What if the address_space is shared by two inodes?  That is the whole
point of the i_mapping pointer.  This would make it harder for the
"other" inode to get the error.
(Does anyone actually use fs/coda ??
 Actually, block devices use i_mapping too.
 If two block device inodes have the same major/minor number, they
 end up having i_mapping point to the same place)

If you are concerned about space in 'struct address_space', just prune
some wastage.
The "host" field brings no value.  It is only ever assigned in
inode_init_always():

	struct address_space *const mapping =3D &inode->i_data;
......
	mapping->host =3D inode;

So you could change all references to use
   container_of(mapping, struct inode, i_data)

NeilBrown



>
> If we put this field in the inode then perhaps we can union it with
> something and mitigate the cost of a larger counter...maybe in the
> i_pipe union? I don't think S_ISREG inodes use anything in there, do
> they?
> --=20
> Jeff Layton <jlayton@redhat.com>

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljlhagACgkQOeye3VZi
gbnTBBAAkylU5/FpDBlM6VSpBHxH9rezLLW5LrgUXBoy6KXUOwfeiASGhWoMGRUp
aSUgiH4YTHO2BWN7bMBclOZrNXdHT5Tj+mWW3XJPbme7AvtZ38qSjpvUhdPXkkhE
4um+5gm9eifoPrJRg3Mj7EZMlXQDfRHMplw3L+gKfGfsPukfvhsXavGyViGXvcIm
1wfJRXH8l60LsI6F+1LfDIvi0GUIJHpsTPNHeghUMCDKV4vJuWSg53f1HKBKLXZb
UxtRc5Qc0+98XRno+/LpVtWOpi+vXBteo+5neCP1eXA9/nPZhNuwxmykl35XLH9h
d8qbZsATn9hKxUQtiFDSUXqFUnMWa+QvFlHeTA6RCICpHOa3P3AFNojdFTpPC3Vx
mEoDbIuT/Il/X0ulTuiQlc0EACB0axvahncugQCpRJNxFojQks6vFBX+vb48UogT
TjLOCgTDQHpMH4Hr/1pC2R/FDT9YkZM3LubvdewVstvXH5jYWgTMKaOllEdSi3a4
lzY1dfC64nrITdcrdahMsvkZzSHuIh+5qQ/vpyo/EAf0noHGxkFHUL3AXHVLDEU0
w9Qzicz/OIWIjaCX8XTqliKNm8FftoEbf3ipIZVAhOHiocFVEbIiY3bvTkAvK+36
a9WtFnZ2ogKVUSMt9IOYQUiVmckzmxxCSuKnJYrP0A47zjUr3as=
=RSMh
-----END PGP SIGNATURE-----
--=-=-=--
