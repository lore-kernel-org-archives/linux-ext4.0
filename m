Return-Path: <SRS0=/gtt=RH=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0D6FC43381
	for <linux-ext4@archiver.kernel.org>; Mon,  4 Mar 2019 12:23:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A9262075B
	for <linux-ext4@archiver.kernel.org>; Mon,  4 Mar 2019 12:23:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbfCDMXb (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 4 Mar 2019 07:23:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52010 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726041AbfCDMXa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 4 Mar 2019 07:23:30 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 72C3330198BA;
        Mon,  4 Mar 2019 12:23:30 +0000 (UTC)
Received: from work (ovpn-204-114.brq.redhat.com [10.40.204.114])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 62C872CFD5;
        Mon,  4 Mar 2019 12:23:27 +0000 (UTC)
Date:   Mon, 4 Mar 2019 13:23:22 +0100
From:   Lukas Czerner <lczerner@redhat.com>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4: Add missing brelse() in add_new_gdb_meta_bg()
Message-ID: <20190304122322.6n5vo7rx5tgoxkev@work>
References: <20190301171504.8583-1-lczerner@redhat.com>
 <20190303020723.GC7930@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190303020723.GC7930@mit.edu>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Mon, 04 Mar 2019 12:23:30 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sat, Mar 02, 2019 at 09:07:23PM -0500, Theodore Y. Ts'o wrote:
> On Fri, Mar 01, 2019 at 06:15:04PM +0100, Lukas Czerner wrote:
> > Currently in add_new_gdb_meta_bg() there is a missing brelse of gdb_bh
> > in case ext4_journal_get_write_access() fails. Fix it.
> > 
> > Fixes: 61a9c11e5e7a ("ext4: add missing brelse() add_new_gdb_meta_bg()'s error path")
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > ---
> >  fs/ext4/resize.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
> > index 48421de803b7..e945f412cf58 100644
> > --- a/fs/ext4/resize.c
> > +++ b/fs/ext4/resize.c
> > @@ -937,6 +937,8 @@ static int add_new_gdb_meta_bg(struct super_block *sb,
> >  	kvfree(o_group_desc);
> >  	BUFFER_TRACE(gdb_bh, "get_write_access");
> >  	err = ext4_journal_get_write_access(handle, gdb_bh);
> > +	if (err)
> > +		brelse(gdb_bh);
> 
> I believe this isn't the right fix --- or at least, it's not
> sufficient.  We're releasing gdb_bh, but there is still a pointer left
> in n_group_desc[gdb_num] (which is now invalid), and we've already
> replaced o_group_desc with n_group_desc, and incremented s_gdb_count.

Right, I missed that.

> 
> So we should move the call to ext4_journal_get_write_access() earlier
> in the function.
> 
> Ric's comments about checking similar function is also right;
> add_new_gdb() doesn't really get the error handling right, but that's
> an extremely deprecated interface.  We actually had a bug in the old
> resizing ioctl's that was accidentally introduce in 4.4, and no once
> until until December of last year.  (I think it was some crazy user
> with an enterprise distro still using e2fsprogs 1.42, and they tried
> going to a modern kernel, and online resizing didn't work for them.)
> 
> Anyway, while fixing add_new_gdb() might be nice, we can save that for
> another patch and I don't think it's super high priority since it's an
> error handling path for a code path that almost no one uses and was
> broken for two years without no one noticing (although maybe Red Hat
> would prioritize it differently :-).  But could you resend this with
> the call to ext4_journal_get_write_access() moved up earlier in the
> function?

Agreed, I'll resend.

Thanks!
-Lukas

> 
> Thanks!
> 
> 					- Ted
> 		
