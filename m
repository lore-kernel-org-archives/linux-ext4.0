From: Phillip Susi <psusi@ubuntu.com>
Subject: Ext4 tail merging?
Date: Tue, 23 Dec 2014 16:34:29 -0500
Message-ID: <5499DFE5.60508@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qc0-f180.google.com ([209.85.216.180]:55902 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbaLWVed (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Dec 2014 16:34:33 -0500
Received: by mail-qc0-f180.google.com with SMTP id i8so5262415qcq.11
        for <linux-ext4@vger.kernel.org>; Tue, 23 Dec 2014 13:34:32 -0800 (PST)
Received: from [10.1.1.236] (fl-67-77-88-12.sta.embarqhsd.net. [67.77.88.12])
        by mx.google.com with ESMTPSA id f77sm19801764qgd.49.2014.12.23.13.34.31
        for <linux-ext4@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Dec 2014 13:34:31 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Ext4 still does not support tail merging right?  I had a user post
this filefrag output and was surprised to see that it says the merged
flag is set.  How can this be?

$ filefrag -v /boot/grub/grubenv
Filesystem type is: ef53
Filesystem cylinder groups approximately 19
File size of /boot/grub/grubenv is 1024 (1 block of 4096 bytes)
 ext: logical_offset: physical_offset: length: expected: flags:
   0: 0.. 0: 494592.. 494592: 1: merged,eof
/boot/grub/grubenv: 1 extent found, perfection would be -1 extent

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)

iQEcBAEBAgAGBQJUmd/lAAoJENRVrw2cjl5RL1YH+gOPL+fxjD9zUlgOZf40D25l
HgyXP6uXiiLmm/ZUq+htmsvcsM2B7ymT2eZ7mFJfPW90zZbwY9aMXLxf7sSwwu9w
9aETK/s/aMzih+CEii4oDAd2URzpHGzYeQyvH5xPm01JOm7aHMUzw8kMYE5AFvsB
8/HJWboAbZFpdFQO7GRcFWknbEhHAfYwOCOvv7H5Ouks7+Ia07fQD68pzbdVtP90
LDRbml1cg7Us8BJa1Hrc/DfYTa0DcsIpAgFlbCEAu7Mui2C2EW0qDX6TCp9jHM6C
6XGjGqW1f70rgAzK4P2sfMa1UkF/PQQpoTiKjzinZuBbc6Krv7tjJvPXrv7uy1Q=
=GIq0
-----END PGP SIGNATURE-----
