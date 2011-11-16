From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: Difference in statvfs(2) block count with ext2 and very recent Linux
 3.2.0 kernels
Date: Wed, 16 Nov 2011 09:54:18 +0000
Message-ID: <20111116095418.GA8054@amd.home.annexia.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: meyering@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9024 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754776Ab1KPJyX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Nov 2011 04:54:23 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAG9sMEA026777
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 16 Nov 2011 04:54:22 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hi,

We do some automated testing of the kernel and ext2/3/4 filesystems,
and noticed that the block count returned by statvfs(2) for plain
*ext2* filesystems has changed with the latest 3.2.0rc1 kernel.

This is probably just because of more accurate block accounting, but I
just wanted to check that it isn't a bug.

This posting contains the numbers and a reproducer:

  https://www.redhat.com/archives/libguestfs/2011-November/msg00051.html

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
virt-df lists disk usage of guests without needing to install any
software inside the virtual machine.  Supports Linux and Windows.
http://et.redhat.com/~rjones/virt-df/
