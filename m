From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [RFC 0/6] vfs: Add timestamp range check support
Date: Thu, 3 Nov 2016 18:27:26 -0600
Message-ID: <1206C36E-9CB4-47B3-A891-8EA94C3220E0@dilger.ca>
References: <1478099096-25637-1-git-send-email-deepa.kernel@gmail.com> <20161102224827.GJ14023@dastard> <20161103204357.r7lgvbsv3euujijn@thunk.org>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_7555ADD9-00D2-495B-BE1E-9122E46C620B"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: Dave Chinner <david@fromorbit.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, arnd@arndb.de,
        tglx@linutronix.de, gregkh@linuxfoundation.org,
        akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        y2038@lists.linaro.org, linux-afs@lists.infradead.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161103204357.r7lgvbsv3euujijn@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_7555ADD9-00D2-495B-BE1E-9122E46C620B
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii


> On Nov 3, 2016, at 2:43 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> 
> On Thu, Nov 03, 2016 at 09:48:27AM +1100, Dave Chinner wrote:
>> 
>> We're going to need regression tests for this to ensure that it
>> works properly and that we don't inadvertantly break it in future.
>> Can you write some xfstests that exercise this functionality and
>> validate that the mount behaviour, clamping and range limiting is
>> working as intended?
> 
> In order to have automated regression tests which are file system
> independent, we need a way to query what are the timestamps that a
> particular mounted file systme supports.  One approach would be to use
> fsinfo, which David Howells had been working on, but which has been
> bike-shedded to death for the last n years, and I'd hate to block this
> patch series behind a proposed new fsinfo(2) system call.

I wish we could just get the fsinfo and statx calls landed, but I agree
it would be a DOS to block any other patches waiting for that to land...

or maybe we _should_ block other patches behind that patch, and force it
to be landed... :-)

> Alternatively, we can just create a specialized ioctl to return that
> information which is non-ideal in other dimensions.
> 
> The last option, which is admittedly ugly, would be to create an shell
> function which knows how to figure out the max_timestamp and
> min_timestamp by using the file system name and querying the
> superblock using dumpe2fs, xfs_db, etc.
> 
> I'd argue for the last option because once we do get a programmtic way
> to get the information via a system call such as fsinfo(2), we can
> convert xfstests to use it, where as if we add an ioctl to return this
> information, we'll have to support the ioctl forever.
> 
> Does this make sense?   Any objections?

Realistically, there are only a handful of filesystems being tested by
xfstests, and it is simple enough to hard-code these limits into the
test script for ext4, xfs, btrfs, etc. since the limits will not be
changing very often (and it is noteworthy when they do).  If and when
there is an interface to query these values from the kernel, it may
still make sense to keep the hard-coded limits to verify the syscall
against...

Cheers, Andreas






--Apple-Mail=_7555ADD9-00D2-495B-BE1E-9122E46C620B
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBWBvV73Kl2rkXzB/gAQg1dA//evM5EM0PQ6bY0OuNpWymm8763XmxucNP
RteSuPiwthTUbHCp1QlYRkn1S5GqGDR9W2TCt0J+Y3SHVQnDglfFfakRISR1IZEU
CKxDbZM/Aff1SIqQDm+MkWHkt+hgzxAQFS6nV0xji2AsLXNkC0BN68nIsuI65N6E
psWxlLj8MPtBh9YsS7pvMKgLzNnUL3KAaxnEA/gtKfuCFL7J2Xtf+avgIp/nmmeT
H0YurCg2TEf80UwtjGmtOZrxSoscNn1h/8pDbcpXO7alSUZ3S1nUG7tQRwXvsAOY
5kDEe9R1LHkvDEJ1SbYWP7RnyLkCkSIiZOZx3pzd+XI9mMCJpHis1YxxPWYb5FUB
MPbpZ9nO4531yrYxBtd6bpjLcuXGn7WP0X7VN8791E9m6XPcWsNgwDULE3EH9SxO
BjUDj7Jwqv07rCyAoCjHFg5gOVbHzGGYpbK8WMzwl2Gvt/emmpGXzmaaSFAJ06zP
6dgPWUgp2UxlrbwF2mPf61bnuc0GtfCrIwOy6+NblxB6UcNiVd00UBCYpZ6jx2IJ
muYkt/0LlnMfkiJIfeB9ioTSk4zFHaYDde+OvNS62ZedusQkQ1jr1tDwSnZ8jj/c
qQsMHx5JdnaZ/Itzfao3/BB0plAo/WP+mTDEaZTrrs6GvMixZB+/b275C2xmVOa9
HuZaavEAgG8=
=TSoT
-----END PGP SIGNATURE-----

--Apple-Mail=_7555ADD9-00D2-495B-BE1E-9122E46C620B--
