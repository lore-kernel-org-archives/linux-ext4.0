From: Phillip Susi <psusi@ubuntu.com>
Subject: Battery backed ramdisk for fs journal
Date: Mon, 04 Mar 2013 23:23:46 -0500
Message-ID: <51357352.70804@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:42026 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758759Ab3CEEXs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Mar 2013 23:23:48 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

It seems to me that the ideal device to hold an external journal is a
battery backed RAM based MTD device.  Does such a beast exist?

As an alternative, has anyone considered or implemented a more
conventional ramdisk that would be preserved across a kexec crash, in
conjunction with an oversized UPS and NUT configured to suspend the
system with plenty of battery power left?

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQEcBAEBAgAGBQJRNXNSAAoJEJrBOlT6nu75oAAH/1KgYC4jOb78+Oe2DKA5vrAv
Lnq/x5Y8RhNRKjFsBIGgqfQzWjxFw3emGccTiGysQh8cleBpyMSVGzKU1PDbnIbq
vm0nxu05uhWsbqAcfVdO/BwuJHbckJ0HKOv+xKXg6YkGtmJm9S3RFX/tSbBquJpx
DgDtMZLKN2oZCvuhLThYJGcNxlAS1oxfCEGPHaJXiNPfyO2ikU0suyPB9FbC8RNM
gm/VwwS/FO7561HRUqUIjM46DKcpZnN8b2Hgtd3eCy3R3Vjaf988PWsM6Nz8GR86
KWXzNAci0LIz/5KaQeDj4unlXJ4jf4rhx3m9WR6vNU4HG3Pd+GuEN3xiNmznfa0=
=HGFK
-----END PGP SIGNATURE-----
