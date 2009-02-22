From: Theodore Tso <tytso@mit.edu>
Subject: [tytso@MIT.EDU: Ext4 tree backports for 2.6.27.19 and 2.6.28.7]
Date: Sat, 21 Feb 2009 23:32:07 -0500
Message-ID: <20090222043207.GF17066@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="ew6BAiZeqk4r7MaW"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:53454 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753226AbZBVEcL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 21 Feb 2009 23:32:11 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Once more with the correct e-mail address.  :-)

     	       	   	   	  	    - Ted

--ew6BAiZeqk4r7MaW
Content-Type: message/rfc822
Content-Disposition: inline

Return-Path: <tytso@MIT.EDU>
Received: from po14.mit.edu ([unix socket])
	by po14.mit.edu (Cyrus v2.1.5) with LMTP; Sat, 21 Feb 2009 23:07:45 -0500
X-Sieve: CMU Sieve 2.2
Received: from pacific-carrier-annex.mit.edu by po14.mit.edu (8.13.6/4.7) id n1M47iSY003922; Sat, 21 Feb 2009 23:07:44 -0500 (EST)
Received: from mit.edu (W92-130-BARRACUDA-2.MIT.EDU [18.7.21.223])
	by pacific-carrier-annex.mit.edu (8.13.6/8.9.2) with ESMTP id n1M47dII014889
	for <tytso@mit.edu>; Sat, 21 Feb 2009 23:07:39 -0500 (EST)
Received: from thunker.thunk.org (thunk.org [69.25.196.29])
	(using TLSv1 with cipher AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mit.edu (Spam Firewall) with ESMTP id C0488120703B
	for <tytso@mit.edu>; Sat, 21 Feb 2009 23:06:55 -0500 (EST)
Received: from root (helo=closure.thunk.org)
	by thunker.thunk.org with local-esmtp   (Exim 4.50 #1 (Debian))
	id 1Lb5cC-0006uV-Ub; Sat, 21 Feb 2009 23:06:53 -0500
Received: from tytso by closure.thunk.org with local (Exim 4.69)
	(envelope-from <tytso@mit.edu>)
	id 1Lb5cA-00048L-Ln; Sat, 21 Feb 2009 23:06:50 -0500
To: linux-ext4@stable.kernel.org
cc: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>,
        Alexander Beregalov <a.beregalov@gmail.com>
Subject: Ext4 tree backports for 2.6.27.19 and 2.6.28.7
From: "Theodore Ts'o" <tytso@MIT.EDU>
Phone: (781) 391-3464
Message-Id: <E1Lb5cA-00048L-Ln@closure.thunk.org>
Date: Sat, 21 Feb 2009 23:06:50 -0500
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
X-Spam-Score: 0.12
X-Spam-Flag: NO
X-Scanned-By: MIMEDefang 2.42

I've updated the for-stable and for-stable-2.6.27 branches with the
latest ext4 bug fixes that were merged into mainline since 2.6.29-rc5.
The for-stable and for-stable-2.6.27 branches can be found in the ext4
git tree:

   git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git
   http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git

The patches in these branches are attached below; I didn't port commit
2acf2c2 to 2.6.27 since it really requires commit 22208d (ext4: Fix
file fragmentation during large file write), which was judged too
invasive for a 2.6.27.y backport.

If folks can test out the for-stable and/or the for-stable-2.6.27
branches, I would appreciate it before I send these patches to
stable@kernel.org.

						- Ted

mainline 2.6.28 2.6.27
    commit-description
--------------------------------------------------------------------
c88ccea 5e207aa 765ba56
    jbd2: Fix return value of jbd2_journal_start_commit()
9eddacf 97fef01 b9eab5a
    Revert "ext4: wait on all pending commits in ext4_sync_fs()"
7f5aa21 48320fb 19815ad
    jbd2: Avoid possible NULL dereference in jbd2_journal_begin_ordered_t
7be2baa 62cd8c3 b88c4d9
    ext4: Fix to read empty directory blocks correctly in 64k
ba44391 bcc855a 4987213
    ext4: Fix lockdep warning
d794bf8 58cf82c b700ed3
    ext4: Initialize preallocation list_head's properly
2acf2c2 3d9eef3 ------
    ext4: Implement range_cyclic in ext4_da_writepages instead of write_c
0905426 09b7e0c ed858e5
    ext4: Fix NULL dereference in ext4_ext_migrate()'s error handling

--ew6BAiZeqk4r7MaW--
