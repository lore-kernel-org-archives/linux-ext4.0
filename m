From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: How should e2fsck clear s_errno/j_errno on an ro mount?
Date: Mon, 23 Jul 2012 15:21:45 -0500
Message-ID: <500DB259.8070901@redhat.com>
References: <5009E62E.3020608@redhat.com> <20120721003953.GA9399@thunk.org> <500D7BCB.2060806@redhat.com> <20120723191410.GB783@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20174 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754160Ab2GWUVt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Jul 2012 16:21:49 -0400
In-Reply-To: <20120723191410.GB783@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 7/23/12 2:14 PM, Theodore Ts'o wrote:
>> nWell, I tested e2fsprogs from git and saw the same trouble.  Let me
>> look more closely at that commit.
> 
> Hmm, would it be possible to send me /tmp/loop3.qcow.bz2 after running:
> 
>      e2image -Q /dev/loop3 /tmp/loop3.qcow
>      bzip2 /tmp/loop3.qcow
> 
> Regardless of what the problem ends up being, this looks like
> something for our regression test suite....
> 
> 					- Ted
> 

Sure I can do that, will do it offline.

FWIW, the commit you mentioned changes e2fsck_check_ext3_journal, and
we only get there from main() like this:

        if ((ctx->mount_flags & EXT2_MF_MOUNTED) &&
            !(sb->s_feature_incompat & EXT3_FEATURE_INCOMPAT_RECOVER))
                goto skip_journal;

        retval = e2fsck_check_ext3_journal(ctx);

In my case I am mounted ro and recovery is done, so
EXT3_FEATURE_INCOMPAT_RECOVER is not, set, and so we skip over it with
the goto.

or else from here:

        if (sb->s_feature_incompat & EXT3_FEATURE_INCOMPAT_RECOVER) {
                if (ctx->options & E2F_OPT_READONLY) {
			...
                } else {
			...
                        retval = e2fsck_run_ext3_journal(ctx);

And again, I've already done recovery and am mounted RO so we won't go that way.

If make the first test above a little later:



diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 94260bd..73aa028 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1424,10 +1424,6 @@ failure:
 		fprintf(ctx->logf, "Filesystem UUID: %s\n",
 			e2p_uuid2str(sb->s_uuid));
 
-	if ((ctx->mount_flags & EXT2_MF_MOUNTED) &&
-	    !(sb->s_feature_incompat & EXT3_FEATURE_INCOMPAT_RECOVER))
-		goto skip_journal;
