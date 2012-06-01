From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: [PATCH v2 1/4] ext4: Remove useless marking of superblock dirty
Date: Fri, 01 Jun 2012 20:48:06 +0300
Message-ID: <1338572886.2053.6.camel@koala>
References: <1333367140-28370-1-git-send-email-artem.bityutskiy@linux.intel.com>
	 <1333367140-28370-2-git-send-email-artem.bityutskiy@linux.intel.com>
	 <1334215249.13842.36.camel@sauron.fi.intel.com>
	 <1335775045.2584.3.camel@sauron.fi.intel.com>
	 <1338558820.2536.151.camel@sauron.fi.intel.com>
	 <20120601151601.GA13826@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-yzYaBE60ZFRSOu3nMSzP"
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37817 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933432Ab2FARsp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Jun 2012 13:48:45 -0400
In-Reply-To: <20120601151601.GA13826@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-yzYaBE60ZFRSOu3nMSzP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-06-01 at 11:16 -0400, Ted Ts'o wrote:
> I'm very sorry, this has been completely my fault; this has been an
> absolutely crazy month this past May, and this just slipped off my
> radar, and we're just out of time.  I will make sure this patchset
> gets reviewed and queued for 3.5.

No problem, thanks for reply. I think it would be safer if could take it
to your tree (providing it is OK) and it would go through the normal
cycle and hit 3.6, not 3.5. There is no rush with this - I need to take
care of several other file-systems before the whole kernel thread can be
killed anyway.

--=20
Best Regards,
Artem Bityutskiy

--=-yzYaBE60ZFRSOu3nMSzP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPyQBWAAoJECmIfjd9wqK0IwsQAIHWhqt7AwwkYoj/2N85HMGX
h+eT/t1LMm7qpWC7Os5jBjjnSwFgslT8Lxid6mdR2A2emkiXdAKUdQti93ujWEQ8
RK8HgpV+Y5GQtYS7IGz5VC1ftKXPM5tuuYDr+13PbUhls7Awpp7CV/+6r+7N/CRw
ptKELSPeTBbA1XsWEZH0FMBNbaB2xnneVQOxeB6ofaMm0t3cmptNKsrshSOUDYJ5
rhPYh6ZBe12zdjeWUJVij72T9LyykP5YyRysP7eGDDhD7tKevAWVApTw0mSuYWop
n9OaR6DIYxmTLiXw0oXl5/MGhi+mptb8YaDd+1DGdzrq+I8sUvM0wLDcrMVxajOq
00DLAaFe4/H5ksr49oMeHSDVYt85BM9sRBphzH2633hRq5OEYt6VH3lbhZmMzCcf
Jgc7LnYxU224dSHl0zpndIILE9aUWelKK+Xgul8nNdx+BAv3LhZTjFT4BcabMnmR
0Jd+IhVx0npVRYRIQGTPDZspEQbiG2mRPOzePFxZnwNxecvImBxlE2gPB2xG/Qfs
YRW8fxPN5StPhj/GiQfEZ2MT1LwItkaiIxCt6UNdQT08zeY+EFTt9TEcVfDkAHSo
eGVoIYWcSznsOQ2H5Mv2W25Ak8rfdpriTnZab/prs+h+33+3C0+er57qewcGKhPC
H65ulcAtN3awglNsIBMK
=suIB
-----END PGP SIGNATURE-----

--=-yzYaBE60ZFRSOu3nMSzP--

