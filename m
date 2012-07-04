From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: ext4_fallocate
Date: Tue, 03 Jul 2012 21:15:16 -0400
Message-ID: <4FF39924.7070602@ubuntu.com>
References: <20120625191744.GB9688@thunk.org> <4FE9B57F.4030704@redhat.com> <4FE9F9F4.7010804@zoho.com> <4FEA0DD1.8080403@gmail.com> <4FEA1415.8040809@redhat.com> <4FEA1F18.6010206@redhat.com> <20120627193034.GA3198@thunk.org> <4FEB9115.6090309@redhat.com> <20120702031611.GB2406@gmail.com> <4FF1CD5D.8010904@redhat.com> <20120702174421.GM6679@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>, Theodore Ts'o <tytso@mit.edu>,
	Fredrick <fjohnber@zoho.com>, Ric Wheeler <rwheeler@redhat.com>,
	linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>,
	wenqing.lz@taobao.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:8936 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932541Ab2GDBPS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Jul 2012 21:15:18 -0400
In-Reply-To: <20120702174421.GM6679@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 07/02/2012 01:44 PM, Jan Kara wrote:
>   Yes, that option is broken and basically unfixable for data=ordered mode
> (see http://comments.gmane.org/gmane.comp.file-systems.ext4/30727). For
> data=writeback it works fine AFAICT.

Does data=writeback with barriers fix this fallocate problem?

I can see that writing small random bits into a very large uninitialized file would cause a lot of updates to the extent tree, but with a sufficiently large cache, shouldn't many of the small, random writes become coalesced into fewer, larger extent updates that are done at delayed flush time?  Are you sure that the extent tree updates are not being done right away and blocking the writing application, instead of being delayed?


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJP85kgAAoJEJrBOlT6nu75pnEIAM1qX1PeoZOiWJumgv9yA0te
C61813Vx2cVz5UpRZLO/YpAPTtei1ry2uLdN/TlmiH8TBc/fexipJwZGucYH7b9w
iwE4u19eixYCDV8iVJYVZ6NI6dp9McKNxqrvhcrBUCRiG+/q0Qp5dsD0Gu4PAnOy
rZzMvDU6Ln12nBH0M+UqE7VVZR6FR89tgpklSCDliPbDc0xWNUZQW0CRUkMVaAXu
jFJlNMiMBg7Cu0QzGVj7EzY+GtFGcEEVE5Us2c04bdm6nbvS567Pq6LfwyOM5IVe
q+/dwIN0Sdj3nneyPvrIfaFvQAKmtRnd6vkPxUnZgYSniq+hD0uf6J4nU1IKhw8=
=i9g7
-----END PGP SIGNATURE-----
