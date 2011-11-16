From: Mark Fasheh <mfasheh@suse.de>
Subject: Re: [Cluster-devel] fallocate vs O_(D)SYNC
Date: Wed, 16 Nov 2011 12:03:10 -0800
Message-ID: <20111116200310.GN23779__26395.1629320674$1321473805$gmane$org@wotan.suse.de>
References: <20111116084256.GA22963@infradead.org> <1321436588.2713.5.camel@menhir> <20111116105413.GA2916@quack.suse.cz> <20111116124550.GA11650@infradead.org> <20111116133915.GD8195@quack.suse.cz> <20111116134234.GA24258@infradead.org> <20111116155755.GA22284@quack.suse.cz> <20111116161806.GP29279@shiny> <20111116193540.GL23779@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
To: Chris Mason <chris.mason@oracle.com>, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@infradead.org>,
	Steven Whitehouse <swhiteho@redhat.com>,
	linux-btrfs@vger.kernel.org, linux-ext4@
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49709 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953Ab1KPUDL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Nov 2011 15:03:11 -0500
Content-Disposition: inline
In-Reply-To: <20111116193540.GL23779@wotan.suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 16, 2011 at 11:35:40AM -0800, Mark Fasheh wrote:
> > We should do it per FS though, I'll patch up btrfs.
> 
> I agree about doing it per FS. Ocfs2 just needs a one-liner to mark the
> journal transaction as synchronous.

Joel, here's an (untested) patch to fix this in Ocfs2.
	--Mark

--
Mark Fasheh

From: Mark Fasheh <mfasheh@suse.com>

ocfs2: honor O_(D)SYNC flag in fallocate

We need to sync the transaction which updates i_size if the file is marked
as needing sync semantics.

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 fs/ocfs2/file.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index de4ea1a..cac00b4 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1950,6 +1950,9 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
 	if (ret < 0)
 		mlog_errno(ret);
 
+	if (file->f_flags & O_SYNC)
+		handle->h_sync = 1;
+
 	ocfs2_commit_trans(osb, handle);
 
 out_inode_unlock:
-- 
1.7.6

