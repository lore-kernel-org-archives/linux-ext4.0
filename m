From: Bernd Schubert <bs_lists@aakef.fastmail.fm>
Subject: ext4_clear_journal_err: Filesystem error recorded from previous mount: IO failure
Date: Fri, 22 Oct 2010 15:33:29 +0200
Message-ID: <201010221533.29194.bs_lists@aakef.fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Bernd Schubert <bschubert@ddn.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:57187 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751446Ab0JVNdc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Oct 2010 09:33:32 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

is is really a good idea to allow the filesystem to mount if something like
that comes up? I really would prefer if mount would abort.

Oct 22 12:37:36 vm7 kernel: [ 1227.814294] LDISKFS-fs warning (device sfa0074): ldiskfs_clear_journal_err: Filesystem error recorded from p
revious mount: IO failure
Oct 22 12:37:36 vm7 kernel: [ 1227.814314] LDISKFS-fs warning (device sfa0074): ldiskfs_clear_journal_err: Marking fs in need of filesystem
 check.

(please ignore "ldiskfs", it was just renamed to that by Lustre, but is 
ext4 based as in RHEL5.5, so 2.6.32-ish).


I'm testing with a DDN prototype storage system, which still has some issues
and IO errors come up on certain storage side operations.

We have pacemaker resource agent, that already refuses mount to mount,
if the superblock has the error flag. But obviously that cannot work,
if the flag is only set at mount time. The device was mounted read-only before, 
but somehow no error flag was set in the superblock

Oct 22 12:10:39 vm7 kernel: [55827.998615] LDISKFS-fs (sfa0074): Remounting filesystem read-only
Oct 22 12:10:39 vm7 kernel: [55827.998619] LustreError: 2569:0:(filter.c:190:filter_finish_transno()) wrote trans 416613470762 for client 9
c62eca5-08e4-d60d-9883-2a2140085b6c at #15: err = -30


Other devices that also have been mounted read-only do get the flag
however. Maybe it couldn't set the flag due to the IO error?


Thanks,
Bernd

-- 
Bernd Schubert
DataDirect Networks
