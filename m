From: Eric Sandeen <sandeen@redhat.com>
Subject: How should e2fsck clear s_errno/j_errno on an ro mount?
Date: Fri, 20 Jul 2012 18:13:50 -0500
Message-ID: <5009E62E.3020608@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37635 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752508Ab2GTXNw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Jul 2012 19:13:52 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q6KNDqEe000319
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Fri, 20 Jul 2012 19:13:52 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q6KNDpMj012770
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 20 Jul 2012 19:13:51 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I'm looking at a situation where a root filesystem encountered an error and shut down, and therefore the error was stored in the journal.

But for the root fs, it seems that nothing can clear it.

If we do e2fsck -fy on a readonly mounted filesystem, then remount,rw the error persists:

[25124.319387] EXT4-fs warning (device loop3): ext4_clear_journal_err:4281: Filesystem error recorded from previous mount: IO failure
[25124.331140] EXT4-fs warning (device loop3): ext4_clear_journal_err:4282: Marking fs in need of filesystem check.

ad infinitum.

It may be my fever-addled brain this week but I'm having a hard time following how this error is supposed to get set & cleared, especially if e2fsck has modified it while mounted ro.

As soon as I mount rw again, load_superblock() sees the journal superblock has an error set, and copies it back into the journal->j_errno.

After Ted's "e2fsck: correctly propagate error from journal to superblock" in e2fsprogs, at least an unmounted fs gets cleaned up, but I'm not sure what to do to fix this when it's mounted.  

Am I missing something obvious?

Thanks,
-Eric
