From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: New warning: Unable to get device geometry for [filename]
Date: Fri, 27 Jan 2012 22:53:46 +0000
Message-ID: <20120127225346.GA7449@amd.home.annexia.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30378 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751530Ab2A0Wxs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Jan 2012 17:53:48 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0RMrmQ1003589
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Fri, 27 Jan 2012 17:53:48 -0500
Received: from localhost (vpn1-5-1.ams2.redhat.com [10.36.5.1])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q0RMrlXU001048
	for <linux-ext4@vger.kernel.org>; Fri, 27 Jan 2012 17:53:47 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


I've just noticed that with the latest e2fsprogs, kernel 3.3.0 and
blkid (util-linux 2.20.1), I see this spurious warning when using
mke2fs on a file:

  $ truncate -s 4G test1.img
  $ mke2fs -t ext2 -q -F test1.img 
  warning: Unable to get device geometry for test1.img

Oddly this *doesn't* happen except on the very bleeding edge latest
versions of everything.  I've not (yet) worked out exactly what
component has to be upgraded to see it ...

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
libguestfs lets you edit virtual machines.  Supports shell scripting,
bindings from many languages.  http://libguestfs.org
