From: Eric Sandeen <sandeen@redhat.com>
Subject: How is e2fsck's time_fudge supposed to behave?
Date: Fri, 13 Mar 2015 17:31:18 -0500
Message-ID: <55036536.5030300@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752047AbbCMWbS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Mar 2015 18:31:18 -0400
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 7AE858EB00
	for <linux-ext4@vger.kernel.org>; Fri, 13 Mar 2015 22:31:18 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id t2DMVHWu009162
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 13 Mar 2015 18:31:18 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I'm a little confused by e2fsck's time fudge current behavior, vs its
apparent intent.

We do:

	if ( ... &&
            fs->super->s_mtime > (__u32) ctx->now) {
                pctx.num = fs->super->s_mtime;
                problem = PR_0_FUTURE_SB_LAST_MOUNT;
                if (fs->super->s_mtime <= (__u32) ctx->now + ctx->time_fudge)
                        problem = PR_0_FUTURE_SB_LAST_MOUNT_FUDGED;
                if (fix_problem(ctx, problem, &pctx)) {
                        fs->super->s_mtime = ctx->now;
                        fs->flags |= EXT2_FLAG_DIRTY;
                }

So if we are inside the time_fudge value we simply change the problem,
but PR_0_FUTURE_SB_LAST_MOUNT_FUDGED behaves exactly like
PR_0_FUTURE_SB_LAST_MOUNT, other than the message:

        /* Last mount time is in the future (fudged) */
        { PR_0_FUTURE_SB_LAST_MOUNT_FUDGED,
          N_("@S last mount time is in the future.\n\t(by less than a day, "
             "probably due to the hardware clock being incorrectly set)  "),
          PROMPT_FIX, PR_PREEN_OK | PR_NO_OK },

vs:

        /* Last mount time is in the future */
        { PR_0_FUTURE_SB_LAST_MOUNT,
          N_("@S last mount time (%t,\n\tnow = %T) is in the future.\n"),
          PROMPT_FIX, PR_PREEN_OK | PR_NO_OK },

So unless I'm missing something, the whole fudge_time dance does nothing
except change the message, and after reading lots of words in the e2fsck.conf
manpage ;) this bit seems relevant as to the intent:

> So by default, we allow the superblock  times  to
> be  fudged  by  up to 24 hours.

I had the impression that "allow" meant "ignore" but this still triggers
exactly the same action and correction.  Is that as intended?

I'll send a patch do a printf and take no other action if inside the
fudge_time window, if that seems like the right thing to do.

Thanks,
-Eric
