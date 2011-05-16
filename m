From: Jan Kara <jack@suse.cz>
Subject: Re: Regression with ext4 in kernel 2.6.39-rc7? (Was: testing ext4
 master branch)
Date: Mon, 16 May 2011 11:43:24 +0200
Message-ID: <20110516094324.GA5344@quack.suse.cz>
References: <BANLkTikW57S9emEFG9w9RXvq5O7v_MrsYw@mail.gmail.com>
 <20110513145608.GA21165@thunk.org>
 <4DCD4D5E.6050307@redhat.com>
 <BANLkTim8ihBNzxxkoTwigKMQB1xHToevdQ@mail.gmail.com>
 <20110513224949.GB21165@thunk.org>
 <BANLkTimA4JYROuQqe0+7UF7_Ti5rhZRrtA@mail.gmail.com>
 <21756A13-BE43-4B46-BDC9-F5C456476FFC@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="gKMricLos+KVdGMg"
Cc: Ted Ts'o <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:44542 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753889Ab1EPJnr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 May 2011 05:43:47 -0400
Content-Disposition: inline
In-Reply-To: <21756A13-BE43-4B46-BDC9-F5C456476FFC@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat 14-05-11 13:16:25, Amir Goldstein wrote:
> Sent from my iPhone
> 
> On 14/05/2011, at 10:11, Amir Goldstein <amir73il@gmail.com> wrote:
> 
> >On Sat, May 14, 2011 at 1:49 AM, Ted Ts'o <tytso@mit.edu> wrote:
> >>On Fri, May 13, 2011 at 08:25:02PM +0300, Amir Goldstein wrote:
> >>>
> >>>After xfstests failed to build on Ubuntu 10.10, I followed the
> >>>advice omitted by the build script to run "make install-qa", to
> >>>solve the problem.  It took me a while to figure exactly where I
> >>>should run the command, but in the end I pulled the xfsprogs tree,
> >>>ran "make; make install; make install-qa" and from there on things
> >>>were looking better.
> >>
> >>I did that, but fsstress doesn't pull in the needed xfs/xfs_fs.h
> >>header file.  So it still dies.
> >>
> >>                                               - Ted
> >>
> >
> >Well, anyway, the regression has to be from commit  21f97697:
> >
> >ext4: remove unnecessary [cm]time update of quota file
> >
> >because before that commit ext4_quota_off() was too short to
> >have a bug at ext4_quota_off+0x42/0xd0.
> >
> >Jan, where are you? don't make me debug this...
> 
> So I guess that Jan's patch is missing
> If (!inode)
>     goto out;
  Exactly, that is it. I cannot trigger the problem anymore with the patch.
I just wonder how come you've spotted the problem because test 232 does not
trigger the problem for me - it is triggered when you run quotaoff without
running quotaon and that does not happen with test 232.. Anyway, with the
attached patch running quotaoff on filesystem without quotas turned on
works fine whereas previously it oopsed.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--gKMricLos+KVdGMg
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-ext4-Fix-oops-in-ext4_quota_off.patch"

>From 91c77c4f066a9b905538bbeb1da46dc47c44855c Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Mon, 16 May 2011 10:49:39 +0200
Subject: [PATCH] ext4: Fix oops in ext4_quota_off()

When quota is not enabled when ext4_quota_off() is called, we must not
dereference quota file inode since it is NULL. Check properly for this.

Debugged-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/super.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index a86e693..2a4a9b2 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4652,6 +4652,8 @@ static int ext4_quota_off(struct super_block *sb, int type)
 	if (test_opt(sb, DELALLOC))
 		sync_filesystem(sb);
 
+	if (!inode)
+		goto out;
 	/* Update modification times of quota files when userspace can
 	 * start looking at them */
 	handle = ext4_journal_start(inode, 1);
-- 
1.7.1


--gKMricLos+KVdGMg--
