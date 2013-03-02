From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: use percpu counter for extent cache count
Date: Sat, 2 Mar 2013 10:26:44 -0500
Message-ID: <20130302152644.GA22941@thunk.org>
References: <20130227185625.GA224@x4>
 <20130227191923.GA1121@redhat.com>
 <20130227192907.GB14253@thunk.org>
 <20130227201217.GD14253@thunk.org>
 <20130301033005.GA7081@redhat.com>
 <20130301040039.GA4452@thunk.org>
 <20130301050029.GB4452@thunk.org>
 <5130DA71.4040808@redhat.com>
 <20130301180035.GB17920@thunk.org>
 <5130ED3A.30003@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Jones <davej@redhat.com>,
	"gnehzuil.liu" <gnehzuil.liu@gmail.com>,
	Zheng Liu <wenqing.lz@taobao.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50928 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835Ab3CBP0v (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 2 Mar 2013 10:26:51 -0500
Content-Disposition: inline
In-Reply-To: <5130ED3A.30003@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 01, 2013 at 12:02:34PM -0600, Eric Sandeen wrote:
> 
> I was mostly keying off what quota felt was best, I guess.
> I'm not wedded to either approach, it was just a thought.
> So you can take it or leave it. :)

I'll take it, but for the record, there's a reason why I label patches
with "I haven't tested this yet" disclaimers.

For future reference, calling percpu_counter_init() and
percpu_counter_destroy() is not optional --- without them, in your
original patch, the kernel will crash them the first time an ext4 file
system mount is attempted.

No worries though, no harm done --- but it's better if people don't
rely on me to catch bugs before they go into the tree.  :-)

						- Ted

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 373d46c..1ae5860 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -783,6 +783,7 @@ static void ext4_put_super(struct super_block *sb)
 	percpu_counter_destroy(&sbi->s_freeinodes_counter);
 	percpu_counter_destroy(&sbi->s_dirs_counter);
 	percpu_counter_destroy(&sbi->s_dirtyclusters_counter);
+	percpu_counter_destroy(&sbi->s_extent_cache_cnt);
 	brelse(sbi->s_sbh);
 #ifdef CONFIG_QUOTA
 	for (i = 0; i < MAXQUOTAS; i++)
@@ -3688,6 +3689,9 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	if (!err) {
 		err = percpu_counter_init(&sbi->s_dirtyclusters_counter, 0);
 	}
+	if (!err) {
+		err = percpu_counter_init(&sbi->s_extent_cache_cnt, 0);
+	}
 	if (err) {
 		ext4_msg(sb, KERN_ERR, "insufficient memory");
 		goto failed_mount3;
@@ -3993,6 +3997,7 @@ failed_mount3:
 	percpu_counter_destroy(&sbi->s_freeinodes_counter);
 	percpu_counter_destroy(&sbi->s_dirs_counter);
 	percpu_counter_destroy(&sbi->s_dirtyclusters_counter);
+	percpu_counter_destroy(&sbi->s_extent_cache_cnt);
 	if (sbi->s_mmp_tsk)
 		kthread_stop(sbi->s_mmp_tsk);
 failed_mount2:
