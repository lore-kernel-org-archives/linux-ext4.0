From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Issue with bad file system
Date: Mon, 19 Nov 2012 13:41:07 -0500
Message-ID: <20121119184107.GA29487@thunk.org>
References: <CAPAnFc9axLdcQ0xsGKsqQ5jMVs13JjYv7JdJkc_Q6Kdwa56JiQ@mail.gmail.com>
 <20121119083245.18044.qmail@science.horizon.com>
 <CAPAnFc_BdHCOB0iPwPdfPt_aiJ1PLNgnCAGaZwmOEX32j5LM7Q@mail.gmail.com>
 <50AA6913.2090104@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Drew Reusser <dreusser@gmail.com>,
	George Spelvin <linux@horizon.com>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33601 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754477Ab2KSSlM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Nov 2012 13:41:12 -0500
Content-Disposition: inline
In-Reply-To: <50AA6913.2090104@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

One of the things you could to verify that in fact the RAID array is
sane is to run the following command:

debugfs -s 32768 -b 4096 /dev/md0

Then you can examine the file system via the debugfs commands "cd",
"ls", "cat", "dump" (or even "rdump", although that's more interesting
recovery operations).  I would suggest looking at a number of
directories and make sure they look as you expect them, and that you
try dumping out a few files and making sure that they are
uncorrecpted.

If the majority of the files you look at look sane, then it should be
safe to let e2fsck recover the file system from the backup superblock.

In the future, we'll be able to use the metadata checksum feature to
automate this process (as well as being able to more gracefully and
automatically handle inode table blocks written to the wrong location
on disk, overwriting other inode table blocks) --- but a bit more
testing is needed before I'd recommend it for regular users.  (In
particular, I want to make sure that random journal corruptions are
handled correctly when the metadata checksum feature is enabled ---
before we start having more enthusiastic users try out bleeding edge
features on production file systems....)

Regards,

						- Ted
