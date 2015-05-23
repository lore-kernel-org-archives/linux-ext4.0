From: Phillip Susi <psusi@ubuntu.com>
Subject: resize2fs minimum size wrong
Date: Sat, 23 May 2015 17:18:41 -0400
Message-ID: <5560EEB1.8070003@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:32389 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751324AbbEWVSn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 23 May 2015 17:18:43 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

So I have a filesystem with nothing beyond group 16 used ( including
metadata ), so it should be able to shrink to ~524288 blocks, yet
resize2fs claims the minimum size is 770083 blocks.  Resize debug output
follows:

resize2fs 1.43-WIP (29-Mar-2015)
fs has 52108 inodes, 7 groups required.
fs requires 492169 data blocks.
With 7 group(s), we have 218842 blocks available.
Added 9 extra group(s), blks_needed 492169, data_blocks 513754,
last_start 224238
Last group's overhead is 10534
Need 267931 data blocks in last group
Final size of last group is 278465
Estimated blocks needed: 769985
Extents safety margin: 98
Estimated minimum size of the filesystem: 770083

So clearly it thinks only 16 block groups are enough, then somehow leaps
from there to 24.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCgAGBQJVYO6xAAoJENRVrw2cjl5RDSUH/1bCpLZ/oxj/zoeFnLgjHDvI
UMiR4sJhtEC2pYxBFatz9DOg3iDsEQvN+tJ3lcVb4l8rn6pFepGaNljxiMk8uWae
U784u/jd5UNbYSftKtC/Y9MkH9bfcWKR9wAmWvGz9gSjJXb5SeqGo4yQZTFkhPK8
vW3jvJ7YCCWqLh/VGGunq6jJaGPGVsstlMOEKvQjdEdd0zhXp3YyMy2+GfBlsvkd
PO1780FjG07s+VS4DRwktNNrWIB8TFxM0TsslDrd8ImB6xSssbbPbVI5T81MrhR1
QwO4q/ql4XAwy57rzmxmzf75HhpjUN69ySBm6VA5N2eyiJqOqY3sBz6wZ01LG/I=
=dht/
-----END PGP SIGNATURE-----
