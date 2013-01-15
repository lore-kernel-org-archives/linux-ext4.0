From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [PATCH 3/3] mke2fs: document bigalloc and cluster-size
Date: Tue, 15 Jan 2013 15:38:47 -0500
Message-ID: <50F5BE57.1000305@ubuntu.com>
References: <1358068095-9034-1-git-send-email-wenqing.lz@taobao.com> <1358068095-9034-3-git-send-email-wenqing.lz@taobao.com> <20130115031006.GB31857@thunk.org> <20130115191254.GD17719@thunk.org> <50F5B209.40900@ubuntu.com> <20130115195741.GG17719@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Zheng Liu <gnehzuil.liu@gmail.com>, linux-ext4@vger.kernel.org,
	Zheng Liu <wenqing.lz@taobao.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:49506 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754929Ab3AOUit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Jan 2013 15:38:49 -0500
In-Reply-To: <20130115195741.GG17719@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 1/15/2013 2:57 PM, Theodore Ts'o wrote:
> So bigalloc is basically a hack because it was easier to make this 
> change in the file system than it is to deal with block sizes
> greater than the page size.

If it is only to get around the mm pagesize limit, then why not just
have the fs automatically lie to the kernel about the block size and
shift the references back and forth on the fly when it detects a
larger blocksize?


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJQ9b5XAAoJEJrBOlT6nu75ankH/39qiU2tahSVRekQ6kkyFeaY
RnGMydXcKgSacKAlvmIgP6VOnqPmBCKtdM8oxlob4+orJUksWiLmT7nvMIukUOqs
QGqPzsHtpIzNZnPB6soc6ToRbx+b53EM4fQ+XIt9egnJ4p6gDRiS83xKKjyZnywq
94ZPH5Zg84Xr+zmyUFRqs/cDG2tmbo/6qgkqkVUeFfdLzygq2K4LO/dFpuRg3oqV
ceUqVCieCfEplcjnyClT1uOv3RBrjCcyFW1j46UjEYiHkFENYsCSi/Hk4qOYDls+
i/bETjWABSXz23BMD2/B0wZwhGwkrsX2Y5g1CjtRksgPFthW/rmk0HzvWniC9J4=
=kJ8x
-----END PGP SIGNATURE-----
