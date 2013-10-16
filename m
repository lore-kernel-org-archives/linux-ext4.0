From: Carlos Carvalho <carlos@fisica.ufpr.br>
Subject: Re: 3.10.10: quota problems
Date: Tue, 15 Oct 2013 23:58:52 -0300
Message-ID: <21086.236.420841.123331@fisica.ufpr.br>
References: <21080.35061.164482.975014@fisica.ufpr.br>
	<20131015155334.GG12428@quack.suse.cz>
	<20131016022548.GB28823@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fisica.ufpr.br ([200.17.209.129]:40263 "EHLO fisica.ufpr.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918Ab3JPC6z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Oct 2013 22:58:55 -0400
In-Reply-To: <20131016022548.GB28823@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Ts'o (tytso@mit.edu) wrote on 15 October 2013 22:25:
 >  Support for the quota feature first appeared in e2fsprogs 1.42,
 >  although it is not enabled by default. It must enabled via a
 >  compile-time configuration option, --enable-quota. There are bug fixes
 >  which have been applied in various 1.42.x maintenance branch releases,
 >  so users who wish to experiment with the quota feature are strongly
 >  encouraged upgrade to the latest e2fsprogs 1.42.x maintenance
 >  release. As of this writing the following bugs are still in e2fsprogs
 >  1.42.7, which means use of file systems with the quota feature in
 >  production can not be recommended:

That's why I'm using 1.42.8, the latest version.

 >    * The e2fsck check of the on-disk quota inodes won't notice if
 >      there is a missing uid record. (i.e., if some uid, say daemon
 >      owns a bunch of files, but that uid record is not in the quota
 >      inode, e2fsck won't say boo.)
 >
 >    * If e2fsck *does* notice a discrepancy between the usage
 >      information recorded in the hidden quota inodes, and the actual
 >      number of blocks used by a particular user id or group id, it
 >      will overwrite the user or group quota inode with all of the
 >      information it has. Unfortunately, in the process it will zero
 >      out all of the current quota limits set. This is unfortunate....

Unfortunate indeed but I can work around it. What's really bad is
*wrong usage*:

cyre#~ quota -v user1
Disk quotas for user user1 (uid 634): 
     Filesystem  blocks   quota   limit   grace   files   quota   limit   grace
       /dev/md3       0       0       0               0       0       0        

cyre#~ du -s ~user1
161M	/home/users/user1

ls -l ~user1 shows lots of files belonging to user1. For myself:

cyre%~[23:42] quota -v
Disk quotas for user carlos (uid 577): 
     Filesystem  blocks   quota   limit   grace   files   quota   limit   grace
       /dev/md3  721680       0       0           51064       0       0        

cyre%~[23:42]  du -s .
13,6G	.

How can this be? Looks like a kernel problem.
