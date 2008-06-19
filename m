From: Arjan van de Ven <arjan@linux.intel.com>
Subject: kerneloops.org: 2.6.26-rc possible regression in ext3
Date: Wed, 18 Jun 2008 22:34:26 -0700
Message-ID: <4859EFE2.2090202@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga10.intel.com ([192.55.52.92]:31324 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750736AbYFSFee (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Jun 2008 01:34:34 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In the kerneloops.org stats, a new oops is rapidly climbing the charts.
The oops is a page fault in the ext3 "do_slit" function, and the first
report of it was with 2.6.26-rc6-git3.

It happens with various applications; the backtraces are at:

http://www.kerneloops.org/search.php?search=do_split

but are generally of this pattern:

*do_split
ext3_add_entry
ext3_rename
vfs_rename
... <various paths into vfs_rename> ...

or

*do_split
? add_dirent_to_buf
ext3_add_entry
ext3_new_inode
ext3_add_nondir
ext3_create
vfs_create
....


did we change anything in ext3 this cycle?
