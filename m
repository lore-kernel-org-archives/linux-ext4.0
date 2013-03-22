From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH] ext4: fix journal callback list traversal
Date: Fri, 22 Mar 2013 20:32:28 +0400
Message-ID: <87y5dfwg2r.fsf@openvz.org>
References: <1363880952-28758-1-git-send-email-dmonakhov@openvz.org> <874ng4ybpv.fsf@openvz.org> <20130321161653.GB21877@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, bobijam@whamcloud.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:41587 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1160999Ab3CVQcd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Mar 2013 12:32:33 -0400
Received: by mail-la0-f42.google.com with SMTP id fe20so7696998lab.29
        for <linux-ext4@vger.kernel.org>; Fri, 22 Mar 2013 09:32:32 -0700 (PDT)
In-Reply-To: <20130321161653.GB21877@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 21 Mar 2013 12:16:53 -0400, Theodore Ts'o <tytso@mit.edu> wrote:
> On Thu, Mar 21, 2013 at 08:11:24PM +0400, Dmitry Monakhov wrote:
> > OOps. Sorry. I've sent wrong patch. Please ignore it. I'll send correct
> > version in a minute.
> 
> Yeah, I just noticed that it doesn't compile.  Also, it looks like the
> patch you sent wasn't actually checking the return value of
> ext4_journal_callback_try_del()?
Sorry for a long replay.... It takes me longer that a minute to fix all
that crap i've found. It is appeared that running xfstests plus freeze/unfrees
in a background opened an Pandora's box. First it is apeared that JBD2
has a bug since "Nov 6 2008". After that I've prepared incorrect patch
for jbd2 which corrupted journal and it is appeared that error handling
in ext4_fill_super is also broken. Nor than less patches are already available here:
http://patchwork.ozlabs.org/patch/230111/
http://patchwork.ozlabs.org/patch/230112/
http://patchwork.ozlabs.org/patch/230113/
And patched kernel survived with all my tests.
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
