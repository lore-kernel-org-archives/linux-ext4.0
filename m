From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Next3 snapshots for everyone :-)
Date: Tue, 10 Aug 2010 15:56:05 +0200
Message-ID: <AANLkTimEt6uweU=Cf5-sOi07LF4jBiFFLk-3Cp3fkizK@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Theodore Tso <tytso@mit.edu>,
	Andreas Dilger <andreas.dilger@oracle.com>,
	Jan Kara <jack@suse.cz>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	lwn@lwn.net
To: next3-users@lists.sourceforge.net
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:61527 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439Ab0HJN4H (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Aug 2010 09:56:07 -0400
Received: by pxi10 with SMTP id 10so59270pxi.19
        for <linux-ext4@vger.kernel.org>; Tue, 10 Aug 2010 06:56:07 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi All,

Next3 version 1.0.12 was released today:
http://next3.sf.net/

In this release, the installation process was made simpler and faster:

- There is no need to patch and rebuild the kernel.
- Patched e2fsprogs come pre-compiled with names like mkfs.next3,
  fsck.next3 and can be installed along side the standard e2fsprogs.
- The Makefile has a 'make test' that runs next3 tests on a loop mounted
  image without installing any files on your system (only insmod).

The release was tested on Ubuntu desktop releases 9.10 and 10.4
and can work on any system with kernel versions 2.6.27 to 2.6.33.

I would be glad to know if Next3 was tested on other distributions.
Please send your feedbacks to next3-users@lists.sourceforge.net
and state the distribution and kernel version which you are using.

Thanks for helping me deliver simple and friendly Next3 snapshots to everyone,
Amir.
