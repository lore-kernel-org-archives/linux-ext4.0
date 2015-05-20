From: Phillip Susi <psusi@ubuntu.com>
Subject: Unused block group, but all blocks not free?
Date: Tue, 19 May 2015 21:10:12 -0400
Message-ID: <555BDEF4.1020704@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:13302 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751866AbbETBKN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 May 2015 21:10:13 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

I broke out the old e2defrag for an experiment today ( wondering why
resize2fs refuses to shrink a volume below half its size even though
it is only 33% used; thought I would try packing all files as far to
the left as possible and try again ) and it bailed out because the
free block count listed in the superblock does not match what the
block allocation bitmaps indicate.  It turns out this is due to some
block groups that are unused, and thus have uninitialized allocation
bitmaps, yet somehow claim to not have all of their blocks free.  The
stats output from debugfs shows this:

 Group 25: block bitmap at 524297, inode bitmap at 524313, inode table
at 528928
           32383 free blocks, 8192 free inodes, 0 used directories,
8192 unused inodes
           [Inode not init, Block not init, Checksum 0x45a8]


How on earth can this be?  The block allocation bitmap is
uninitialized, therefore all bits are assumed to be clear.  Yet the
free blocks count is only 32383 instead of 32768.  How can a block
group be totally unused, and yet not have all of its blocks free?

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCgAGBQJVW970AAoJENRVrw2cjl5RU5cH/2CM88pWTMD52KXWAT+1RfK8
oTuwSRdIyLlNF63kYicHAyd0TKHJ/qUJwmyZMJUfdDxbraMSYsGNtzUOaaL5hcgJ
qwJfDXO3UmSLILSt8xGpgBH0TfybPLsBSzzrnyvq1Wk79a2HNAnOzTZJX+g7iDhP
iePN3QEmG78xYK/V9gsiFO/PFh5KBXjhsdlLHkZgHLKUzWncfEzgtGU8m47PQLWq
w4NEn+KBXr6k8jxx/btB3halgH0+70eejVNdM34SHx4ZvcckStz71aNT4six3os2
euOMLMQol8fgKCu/eCRSIT/oruF5F7op467Q3gP3JHp3e7V+21jW8f1ykO9xG8Y=
=DhLq
-----END PGP SIGNATURE-----
