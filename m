From: Coly Li <colyli@gmail.com>
Subject: What is fragment in ext3/4 ?
Date: Thu, 02 Aug 2007 17:55:05 +0800
Message-ID: <46B1A9F9.3050901@gmail.com>
Reply-To: colyli@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.190]:36226 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782AbXHBKAg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Aug 2007 06:00:36 -0400
Received: by fk-out-0910.google.com with SMTP id z23so391173fkz
        for <linux-ext4@vger.kernel.org>; Thu, 02 Aug 2007 03:00:34 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

These days, when I read the source code of mke2fs, I found an option -f
to set the fragment size.

But I can not find any explaining for ext3/4 framgment from google,
excepting someone saying ext2/3 does not support this feature.

Can anyone tell me what is the function or purpose of fragment of ext
file system ?

Thanks in advance :-)

Coly
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFGsan5uTp8cyZ5lTERAvNJAJ0RVII/NFrq8V37AB+tNZ7r291hggCgltef
PC9UiC9elgGZGAMdbHKAz9s=
=pgty
-----END PGP SIGNATURE-----
