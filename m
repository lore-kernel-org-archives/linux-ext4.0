From: Phillip Susi <psusi@ubuntu.com>
Subject: e2image doesn't get backup superblocks?
Date: Mon, 20 Feb 2012 10:35:27 -0500
Message-ID: <4F42683F.3070409@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:14516 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696Ab2BTPf2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Feb 2012 10:35:28 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I've noticed that e2image doesn't get the backup superblocks and group
descriptors.  Is this intentional or an oversight?  Is there a way to
resync the backups from the master copy?  e2fsck doesn't seem to do it.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJPQmg/AAoJEJrBOlT6nu75XqsH/2sZKmffNTRSGIdM3DWi01Kf
aSrDy9rGcyiXd1L8ZhqdXkajCaLuweXBgUfM45mCvdXfd2T5ZgTkg5djc5xuOdPi
qyz4DmJwksMVtrGGliwnFXG6wypiHDdpO3ntVcudCOSkXPO+ESYFKlQV4cX3Dx70
0r+n2hjNHBIuwcBsIdOVzOc4tL0mDqVub/owHSAgI84KDEnCxsIievKS0PYMQpEr
zY64x6KB2Oh8Q8UXZyMZ7ddJpbYFSm/Dpr5eFwFpqRsSTMSV4Z5vYcvVYmuxWBbX
XSbT2D9LsAbuHCGld7X4vSmfFRYij6xR/+5DXIK9kawFvKcxmjNWywu0ZlbuvCY=
=t5up
-----END PGP SIGNATURE-----
