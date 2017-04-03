From: NeilBrown <neilb@suse.com>
Subject: Re: [RFC PATCH 0/4] fs: introduce new writeback error tracking infrastructure and convert ext4 to use it
Date: Mon, 03 Apr 2017 14:25:11 +1000
Message-ID: <87fuhqkti0.fsf@notabene.neil.brown.name>
References: <20170331192603.16442-1-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        akpm@linux-foundation.org, tytso@mit.edu, jack@suse.cz,
        willy@infradead.org
To: Jeff Layton <jlayton@redhat.com>, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40336 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751136AbdDCEZv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 3 Apr 2017 00:25:51 -0400
In-Reply-To: <20170331192603.16442-1-jlayton@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 31 2017, Jeff Layton wrote:

> During LSF/MM this year, we had a discussion about the current sorry
> state of writeback error reporting, and what could be done to improve
> the situation. This patchset represents a first pass at the proposal
> I made there.
>
> It first adds a new set of writeback error tracking infrastructure to
> ensure that errors are properly stored and reported at fsync time. It
> also makes a small but significant change to ensure that writeback
> errors are reported on all file descriptors, not just on the first one
> where fsync is called.
>
> Note that this is a _very_ rough draft at this point. I did some by-hand
> testing with dm-error to ensure that it does the right thing there.
> Mostly I'm interested in early feedback at this point -- does this basic
> approach make sense?

I think that having ->wb_err_seq and returning errors to all file
descriptors is a good idea.
I don't like ->wb_err, particularly that you allow it to be set
to zero:
 +	/*
 +	 * This should be called with the error code that we want to return
 +	 * on fsync. Thus, it should always be <=3D 0.
 +	 */
 +	WARN_ON(err > 0);

Why is that ??

Also I think that EIO should always over-ride ENOSPC as the possible
responses are different.  That probably means you need a separate seq
number for each, which isn't ideal.

I don't like that you need to add a 'flush' handler to every filesystem,
most of which just call
 +	return filemap_report_wb_error(file);

Could we just have
	if (filp->f_op->flush)
		retval =3D filp->f_op->flush(filp, id);
+	else
+		retval =3D filemap_report_wb_error(filp);
in flip_close() ??

... or maybe it is wrong to return this error on close().
After all, the file actually does get closed, so no error occurred.
If an application cares about EIO, it should always call fsync() before
close().

Thanks,
NeilBrown


>
> Jeff Layton (4):
>   fs: new infrastructure for writeback error handling and reporting
>   dax: set errors in mapping when writeback fails
>   buffer: set wb errors using both new and old infrastructure for now
>   ext4: wire it up to the new writeback error reporting infrastructure
>
>  Documentation/filesystems/vfs.txt | 14 +++++++--
>  fs/buffer.c                       |  6 +++-
>  fs/dax.c                          |  4 ++-
>  fs/ext4/dir.c                     |  1 +
>  fs/ext4/ext4.h                    |  1 +
>  fs/ext4/file.c                    |  1 +
>  fs/ext4/fsync.c                   | 15 +++++++---
>  fs/ext4/inode.c                   |  2 +-
>  fs/ext4/page-io.c                 |  4 +--
>  fs/open.c                         |  3 ++
>  include/linux/fs.h                |  5 ++++
>  mm/filemap.c                      | 61 +++++++++++++++++++++++++++++++++=
++++++
>  12 files changed, 106 insertions(+), 11 deletions(-)
>
> --=20
> 2.9.3

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljhzqcACgkQOeye3VZi
gbn/eA//YICjBeWNjIu+IC93SwSMPKcPehN4LIk0vY2I8SCt48E0rNBhpupZnaoG
y2qmwKjoQdJZqIz1YdL1M13WWW21hywSt/vTx74e86G8q52dlH6kUZS7tuhpEx+B
MXa3XM92wm/VyvpjuhTH8u7Qvzp7CbMGOF1RbG8NJ+6AQWPebygQSsh+nAz8kPnN
toxknZuQDt9sEl7iya8HXjPoKfmHHwtDGE8P4FYXSMUeBy/xnOis026s4RNQsRQ4
GZ4jn9s9dosS+Ol/laLNZ144EEm4xApYFg71tOFu3zjqC2nBVozA77mZAhqyG4Gq
TdR8BBY/17RdvgbguFkt7FpMaOGZ+M5GNymz/xxEz9MM+AsiuR72qBh/4b8IJxb4
W8gVGwhSa5cs2M/ZpDWwfaqIhe6B77SbBbPed0pQBLPXxY+T1HNxXK6Cl2/B31hc
aDjX3nDxMmAMaORBQkSBAh83eUZquII0T7P6xD/NAvpfRDnYUmgbdZ2t0BT5JmYL
UsipOLDF9gHBNrDwWnCYLqjwAbaWHoVBvsGlLFZ8OdIEHFV/quezzr+QZjfEcPor
adwAo14sF4N1GKeinQXuUzr4RopZK1HSUv/KllaNhRHcgrxLHj5mGDaIfPyknA4H
HiAxIAw92csM9ia4Y3SQmoBhMI1WNnU0LTSQQJOBHk2t76fIhSE=
=tMCC
-----END PGP SIGNATURE-----
--=-=-=--
