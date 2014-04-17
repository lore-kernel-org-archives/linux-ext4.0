From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 74171] Attempting to build recent version of e2fsprogs from git
 repo gives config.h missing
Date: Thu, 17 Apr 2014 18:40:48 +0000
Message-ID: <bug-74171-13602-GExacktWkT@https.bugzilla.kernel.org/>
References: <bug-74171-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:34077 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159AbaDQSkv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Apr 2014 14:40:51 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 3A86A20364
	for <linux-ext4@vger.kernel.org>; Thu, 17 Apr 2014 18:40:50 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id CE27E202FF
	for <linux-ext4@vger.kernel.org>; Thu, 17 Apr 2014 18:40:48 +0000 (UTC)
In-Reply-To: <bug-74171-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=3D74171

--- Comment #3 from George R. Goffe <grgoffe@yahoo.com> ---
Theodore,

I disabled make clean for now.

Next error:=20

gcc -I. -I../../lib -I../../../lib -g -O2 -checker -g -o
checker/error_message.o -c ../../../lib/et/error_message.c
gcc: error: unrecognized command line option =E2=80=98-checker=E2=80=99

I get this with my Fedora 19 gcc version AND the experimental gcc from =
the gcc
trunk. I have used the --enable-checker option in configure.


Commented out the checker option and now am getting:

=2E./../../lib/ext2fs/ext2fs.h:573:3: warning: #warning "Compression su=
pport is
experimental" [-Wcpp]
  #warning "Compression support is experimental"
   ^
=2E./../../lib/ext2fs/crc32c.c:71:26: fatal error: crc32c_table.h: No s=
uch file
or directory
 #include "crc32c_table.h"
                          ^
compilation terminated.
make[2]: *** [crc32c.o] Error 1
make[2]: Leaving directory
`/sdc1/exphome/clipper/export/home/tools/e2fsprogs/e2fsprogs/build/lib/=
ext2fs'
make[1]: *** [all-libs-recursive] Error 1
make[1]: Leaving directory
`/sdc1/exphome/clipper/export/home/tools/e2fsprogs/e2fsprogs/build'
make: *** [all] Error 2


It just keeps getting better doesn't it?


Regards,

George...

--=20
You are receiving this mail because:
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
