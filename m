From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: [PATCH v1 0/9] do not use s_dirt in ext4
Date: Fri, 30 Mar 2012 18:43:15 +0300
Message-ID: <1333122195.5440.60.camel@sauron.fi.intel.com>
References: <1332254489-2300-1-git-send-email-dedekind1@gmail.com>
	 <20120322095342.GC14485@quack.suse.cz>
	 <1332410747.18717.12.camel@sauron.fi.intel.com>
	 <20120322103309.GA14484@quack.suse.cz>
	 <1332854998.31549.40.camel@sauron.fi.intel.com>
	 <20120327201401.GF5020@quack.suse.cz>
	 <1333121035.5440.49.camel@sauron.fi.intel.com>
	 <20120330153530.GH5587@quack.suse.cz>
Reply-To: dedekind1@gmail.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-SUsM4MwbD4bL9dz+dA+g"
Cc: Ted Tso <tytso@mit.edu>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:7069 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393Ab2C3Pke (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 30 Mar 2012 11:40:34 -0400
In-Reply-To: <20120330153530.GH5587@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-SUsM4MwbD4bL9dz+dA+g
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-03-30 at 17:35 +0200, Jan Kara wrote:
> > [23500.239442]  [<ffffffff811ab59d>] write_dirty_buffer+0x4d/0x80
> > [23500.239442]  [<ffffffff8123be1d>] __flush_batch+0x4d/0xa0
> > [23500.239442]  [<ffffffff8123c605>] jbd2_log_do_checkpoint+0xf5/0x4f0
> > [23500.239442]  [<ffffffff8123ca89>] __jbd2_log_wait_for_space+0x89/0x1=
90
> > [23500.239442]  [<ffffffff81237a98>] start_this_handle+0x3a8/0x4e0
> > [23500.239442]  [<ffffffff810799e0>] ? remove_wait_queue+0x50/0x50
> > [23500.239442]  [<ffffffff81237c93>] jbd2__journal_start+0xc3/0x100
> > [23500.239442]  [<ffffffff81237ce3>] jbd2_journal_start+0x13/0x20
> > [23500.239442]  [<ffffffff8121743f>] ext4_journal_start_sb+0x7f/0x1d0
> > [23500.239442]  [<ffffffff81224a24>] ? ext4_fallocate+0x1a4/0x530
> > [23500.239442]  [<ffffffff811f64c5>] ? ext4_meta_trans_blocks+0xa5/0xb0
> > [23500.239442]  [<ffffffff81224a24>] ext4_fallocate+0x1a4/0x530
> > [23500.239442]  [<ffffffff8117a092>] do_fallocate+0xf2/0x160
> > [23500.239442]  [<ffffffff8117a14b>] sys_fallocate+0x4b/0x70
> > [23500.239442]  [<ffffffff815e6d69>] system_call_fastpath+0x16/0x1b
> > [23500.239442] Code: ee 44 89 e7 e8 35 1f 0f 00 49 8b 5d 18 4c 89 ef e8=
 19 4e 00 00 48 83 c4 08 c1 e3 18 c1 fb 1f 83 e3 a1 89 d8 5b 41 5c 41 5d 5d=
 c3 <0f> 0b 0f 0b 0f 0b 0f 0b 0f 0b 66 0f 1f 84 00 00 00 00 00 55 48=20
> > [23500.239442] RIP  [<ffffffff811a9add>] submit_bh+0x10d/0x120
> > [23500.239442]  RSP <ffff880273a41b58>
> > [23500.261657] ---[ end trace 3db7a7a7ae953551 ]---
>   Hmm, looks like we tried to checkpoint BH_Unwritten buffer. That looks
> like a bug in fallocate() support. Not really related but definitely wort=
h
> reporting.

Well, I ran vanilla the tests in vanilla 3.3 overnight, they were fine.
But may be I was lucky. I'll try to run the tests with vanilla kernel
some more. I mean, it would make more sense to report something against
vanilla 3.3, not a patched 3.3.

Any hints how to properly report an ext4 bug?

--=20
Best Regards,
Artem Bityutskiy

--=-SUsM4MwbD4bL9dz+dA+g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPddSTAAoJECmIfjd9wqK0DrMP/0lAMmGzzu/GCNR7hcMdCnJ9
pIO8HY+3LekQO44m0oZTKDcUY4iDewfO+NszE/4MQn7fA6pdWrvn6tutyIYdRMkm
RW9QrlQSxWwFp0EUr4XAHbuiEQd+NMf/+aYh3tbKdznP1TsZUls+hXLXe805EpsI
B6jgQli01+5oWo8+rBhRCnZU8kbyYlPgnnOUB+ebHce171Cf0ovjslw2rHxZF0Eh
BbMfGv2P5E3vLcPm6zPWj5TWBIiV4qQnTwpJFVwuMsPNRPIntYOxBeKQXbrYYHFA
wMhS0m8JWIsVt1iD57slrIKLV8+ytsEXd1H1eFdgKQcjt3rFwYBCfuqjyuGODTaK
q8ci5kRjVeTJp3bKy7p2t1ALEf50D/RJhPIYFxg3EwqgkP6us+X4Hf9EFaMUq0CT
mrg1FSWwbG+VU+5HDpc1DHo9ZV5KLIfmaj4VwB1w7WLqDmeFPjt5MkfvzHxO9fuQ
Cy93RXvcqtUxcynYisYowqiS73o/fzsxhAZ+mUFLuWyxW8fJ8GySc/PPQI/dPlv+
UcINTnzQWO1pW0XuxMfvIAnSyi07Hufj3lB3h5ZILtvjToZBosAyAKyKwIFNxuXt
cNga7qKW6jTT+9By5PHmEc0ABUqdSaIIyYnEsQC7TJFg33/MFxqne8f/lxMDwOyl
/wmt/Eg5YXBtlPQQrX2J
=FgRr
-----END PGP SIGNATURE-----

--=-SUsM4MwbD4bL9dz+dA+g--

