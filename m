From: Kalpak Shah <Kalpak.Shah@Sun.COM>
Subject: [PATCH][0/15] Lustre e2fsprogs patch series
Date: Mon, 06 Oct 2008 15:40:12 +0530
Message-ID: <1223287812.4007.55.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: TheodoreTso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sineb-mail-1.sun.com ([192.18.19.6]:37836 "EHLO
	sineb-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164AbYJFKKJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Oct 2008 06:10:09 -0400
Received: from fe-apac-06.sun.com (fe-apac-06.sun.com [192.18.19.177] (may be forged))
	by sineb-mail-1.sun.com (8.13.6+Sun/8.12.9) with ESMTP id m96AA6Uv003228
	for <linux-ext4@vger.kernel.org>; Mon, 6 Oct 2008 10:10:06 GMT
Received: from conversion-daemon.mail-apac.sun.com by mail-apac.sun.com
 (Sun Java System Messaging Server 6.2-6.01 (built Apr  3 2006))
 id <0K8B00B01AWSTP00@mail-apac.sun.com>
 (original mail from Kalpak.Shah@Sun.COM) for linux-ext4@vger.kernel.org; Mon,
 06 Oct 2008 18:10:06 +0800 (SGT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

This is the patchset containing the e2fsprogs patches that are used for
Lustre e2fsprogs. The patches are based on e2fsprogs-1.41.2.

This patch series does not contain the regression tests for "extents",
"nlinks", "journal checksum", etc since these are large and have been
submitted earlier.

You can access all the patches, series and regression tests directly
from the Lustre CVS:
$ cvs -d :pserver:anonymous@cvs.lustre.org:/lustre login
$ cvs -d :pserver:anonymous@cvs.lustre.org:/lustre co lustre-e2fsprogs

This patch series contains following patches:
e2fsprogs-specdotin.patch
e2fsprogs-config-before-cmdline.patch
e2fsprogs-new-opt-shrdblks.patch
e2fsprogs-SLES10--m-support.patch
e2fsprogs-uninit-fixes.patch
e2fsprogs-expand-extra-isize.patch
e2fsprogs-tests-f_expisize.patch
e2fsprogs-tests-f_expisize_ea_del.patch
e2fsprogs-ibadness-counter.patch
e2fsprogs-tests-f_ibadness.patch
e2fsprogs-tests-f_random_corruption.patch
e2fsprogs-mmp.patch
e2fsprogs-i_size-corruption.patch
e2fsprogs-fiemap.patch
e2fsprogs-e2freefrag.patch

Thanks,
Kalpak

