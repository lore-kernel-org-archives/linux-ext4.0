From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Creating a >32bit blocks filesystem.
Date: Wed, 09 May 2007 12:18:37 -0500
Message-ID: <4642026D.3040401@redhat.com>
References: <20070503140804.463b20e1@naruto> <463B4A1B.4070201@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Jose R. Santos" <jrs@us.ibm.com>, linux-ext4@vger.kernel.org
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:55818 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755356AbXEIRVQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 May 2007 13:21:16 -0400
In-Reply-To: <463B4A1B.4070201@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Valerie Clement wrote:

> Get the new version of e2fsprogs at
> ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs-interim/=
e2fsprogs-1.39-tyt3
> and apply the patchset in attachment.
>=20
> Hope this helps,
>     Val=E9rie

Val=E9rie, this looks a bit odd in 02_use_64bit_io, in debugfs.c:

@@ -149,13 +149,13 @@ void do_open_filesys(int argc, char **ar
                        data_filename =3D optarg;
                        break;

                case 'b':
-                       blocksize =3D parse_ulong(optarg, argv[0],
+                       blocksize =3D parse_ullong(optarg, argv[0],
                                                "block size", &err);

and same for similar code in main() in debugfs.c.

Surely the block *size* doesn't need to be 64 bits :)  I guess that got
accidentally inherited from e2fsprogs-1.39 where blocksize is type
blk_t, which turned into 64 bits now... I think "int" will be fine.  :)

Thanks,
-Eric
