From: NeilBrown <neilb@suse.com>
Subject: Re: [RFC PATCH 0/4] fs: introduce new writeback error tracking infrastructure and convert ext4 to use it
Date: Wed, 05 Apr 2017 08:50:35 +1000
Message-ID: <87k26ziy84.fsf@notabene.neil.brown.name>
References: <1491215318.2724.3.camel@redhat.com> <20170403143257.GA30811@bombadil.infradead.org> <1491241657.2673.10.camel@redhat.com> <20170403191602.GF30811@bombadil.infradead.org> <1491250577.2673.20.camel@redhat.com> <87h924kh6t.fsf@notabene.neil.brown.name> <20170404115358.GH30811@bombadil.infradead.org> <1491308268.20445.4.camel@redhat.com> <20170404161247.GJ30811@bombadil.infradead.org> <1491323146.309.1.camel@redhat.com> <20170404170909.GK30811@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, akpm@linux-foundation.org,
        tytso@mit.edu, jack@suse.cz
To: Matthew Wilcox <willy@infradead.org>,
        Jeff Layton <jlayton@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170404170909.GK30811@bombadil.infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

--=-=-=
Content-Type: text/plain

On Tue, Apr 04 2017, Matthew Wilcox wrote:

> On Tue, Apr 04, 2017 at 12:25:46PM -0400, Jeff Layton wrote:
>> That said, I think giving more specific errors where we can is useful.
>> When your program is erroring out and writing 'I/O error' to the logs,
>> then how much time will your admins burn before they figure out that it
>> really failed because the filesystem was full?
>
> df is one of the first things I check ... a few years ago, I also learned
> to check df -i ... ;-)
>
> Anyway, given the decision to simply report the last error lets us do this
> implementation:
>
> void filemap_set_wb_error(struct address_space *mapping, int err)
> {
> 	struct inode *inode = mapping->host;
> 	unsigned int wb_err;
>
> 	if (!err)
> 		return;
> 	/*
> 	 * This should be called with the error code that we want to return
> 	 * on fsync. Thus, it should always be <= 0.
> 	 */
> 	WARN_ON(err > 0 || err < -MAX_ERRNO);
>
> 	spin_lock(&inode->i_lock);
> 	wb_err = ((mapping->wb_err & ~MAX_ERRNO) + (1 << 12)) | -err;

Seriously?  You are missing "MAX_ERRNO" (4095) together with "1 << 12"
(4096) in the one expression without a big comment saying why?

Surely:
>       BUILD_BUG_ON_NOT_POWER_OF_2(MAX_ERRNO+1);
> 	wb_err = ((mapping->wb_err & ~MAX_ERRNO) + (MAX_ERRNO+1)) | -err;

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljkIzsACgkQOeye3VZi
gbnAEhAAtzYHxQTnVsr2mdYzmIBrt9eV6MVZx2GRMo3ZDBZOaEg+0sigW5O8vpuO
WhgW1nzV3Y//hvpb8m5y+Tttlj24s8HH/PyIi8kB1YaTAwAGk5LbP9KZIhFfN2s+
8J42uqtt4RPOaQD72LfCEMq7mky0ISxllueJG2B2LXwtUgcH+uq7VDKKVzsCn8W1
hDa4Q6C/rMTkkT/5VErudWg5tUuDPsaObfWbsSV2R0HXaGbQCKTe6rNjaktgP1sP
yy+jbOHVmQLYNemlLI2K5fnJ7BMuDa0qwBPw4WYcJ9y5WrVZgWVmirwNaTHSGiWr
ndrms1aOjaJhFFJmlLwQ0RRRqMYl7bTK0bd4wijrrUc+v0JH+bi4pQ6BHSD1510w
ak2fGEFwi6OZDz/sJj/evOvWGaBxOJ3QDL2JA4HfTpgUaMN8iwDlt0WzZH1qjETc
8Fhf+iEkBD8FM+au7OAM5uU1znHKg56Vr/xC/WoQwSnsiz4w175oPBdj9vD9kBea
3zGfnku5Xgtsc8wRH1pgdC9i9kkNzU5Yqe+q1F91ClMjLI6tH0S1n8LXXqheN/Uo
oq1Lhx/MGdwPwm2NlBiKkzUz1mEmxAEQ/GJMd6S7za3e0AlWnkanlCxOAyUnJSef
kZ9w92NiYf2POwywbe2lZsZ7fWy9qwjL75/DfwRrkY2GIr0Mrao=
=1J55
-----END PGP SIGNATURE-----
--=-=-=--
