From: Eric Sandeen <sandeen@redhat.com>
Subject: Bigalloc ENOSPC woes
Date: Mon, 30 Jan 2012 15:19:05 -0600
Message-ID: <4F270949.30800@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63807 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936Ab2A3VTG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Jan 2012 16:19:06 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0ULJ6Dh018391
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 30 Jan 2012 16:19:06 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id q0ULJ5iK011715
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 30 Jan 2012 16:19:06 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I got nervous when I tried this on an -O bigalloc -C 65536 fs:

# echo foo > blah; du -hc blah; sync; du -hc blah
4.0K blah
4.0K total
64K blah
64K total

Seems that du should never report less than the cluster size, should it?

And that made me wonder about ENOSPC handling - are we tracing delalloc allocations correctly?

>From running xfstest 204 on a similarly-created fs, it really seems that we are not.

A manual test of creating 4-byte files until ENOSPC (which was really when I ran out of inodes) and then issuing a sync led to a storm of kernel messages about allocation failures:

[  482.154538] EXT4-fs (sdb6): delayed block allocation failed for inode 1664 at logical offset 0 with max blocks 1 with error -28
[  482.154540] EXT4-fs (sdb6): This should not happen!! Data will be lost

<ad infinitum, or at least 600 or so in my case>

and an end result of a bunch of 4 byte long files with no extents.  Almost like files full of NULLs.  Careful - that is hard to live down.  :)

Ted, are you aware of those issues in bigalloc?

-Eric
