From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [v7] ext4: Add support FALLOC_FL_COLLAPSE_RANGE for fallocate
Date: Wed, 2 Apr 2014 12:42:58 -0400
Message-ID: <20140402164258.GH6901@thunk.org>
References: <1393769538-3784-1-git-send-email-linkinjeon@gmail.com>
 <20140316031745.GA9916@thunk.org>
 <CAKYAXd-EO0pp=wz_Tg+2NEw9Nyu23sKXc-3n-fZUieES3+xt7w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Namjae Jeon <linkinjeon@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49155 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932335AbaDBQnZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Apr 2014 12:43:25 -0400
Content-Disposition: inline
In-Reply-To: <CAKYAXd-EO0pp=wz_Tg+2NEw9Nyu23sKXc-3n-fZUieES3+xt7w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Some final testing luckily caught a bug in your patch.  I'll fix it
up, but for future reference, it's important to check to see if the
handle is valid (i.e., we are not in no-journal mode) before using any
of the journalling functions.  Otherwise, you will crash if you try
using the code path when the file system does not have a journal.

BTW, I would strongly recommend using the automated regression test
system found at:

	git://git.kernel.org/pub/scm/fs/ext2/xfstests-bld.git

It finds these sorts of problems very quickly.  After you build a
kernel, running "kvm-xfstests -g quick" would have found the problem
very quickly.  The fastest reproducer for the bug that I found is:
"kvm-xfstests -c nojournal shared/001".

Cheers,

						- Ted

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 7015917..bbba1ef 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4902,6 +4902,9 @@ ext4_access_path(handle_t *handle, struct inode *inode,
 {
 	int credits, err;
 
+	if (!ext4_handle_valid(handle))
+		return 0;
+
 	/*
 	 * Check if need to extend journal credits
 	 * 3 for leaf, sb, and inode plus 2 (bmap and group


