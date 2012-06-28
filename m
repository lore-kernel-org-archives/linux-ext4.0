From: Phillip Susi <psusi@ubuntu.com>
Subject: Max blocks per group?
Date: Thu, 28 Jun 2012 11:16:31 -0400
Message-ID: <4FEC754F.5000907@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:6384 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab2F1PQc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Jun 2012 11:16:32 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I notice that mke2fs refuses to allow more than 8 * block size blocks
per group.  Why is this?  Is it not permissible to have more than one
block for the block allocation bitmap?

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJP7HVPAAoJEJrBOlT6nu75X0cIAJCQnJRhmCh4KhkeEzc+zkMw
u1LZ2FodigtJQ5GrhZUrj4X6ZvxL6rXuGYkIenNUYo+V29TGCqUu+infGb/8dkGG
yZkGx3HiuLqLl+fY5sJwz7brykbHYhZMZ6AP/t98ppd+u/3ZiPQpj8tY9rYF6daM
+m+Rkzl8IL7U24JnZ8wAAEUSNkA2b9nEo/rJvh43HdQOtqFGrGui6tBG94xFiHPI
l5XcdRu1rL6ltmpdktYX/6B+peQwhWnVWWi+Nb8zq7l7maIqMpHFPeZ563b/nhR2
xH4OX/jCU/Ys/kbUu+/pvWrjDmwqST48mBG4M/N8UcaacXWoe1HJKBm/kQ302Gc=
=vtLz
-----END PGP SIGNATURE-----
