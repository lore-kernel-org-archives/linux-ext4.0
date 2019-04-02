Return-Path: <SRS0=Vv4O=SE=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EF27C43381
	for <linux-ext4@archiver.kernel.org>; Tue,  2 Apr 2019 07:43:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 178432075E
	for <linux-ext4@archiver.kernel.org>; Tue,  2 Apr 2019 07:43:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728760AbfDBHnR (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 2 Apr 2019 03:43:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:54048 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726458AbfDBHnR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 2 Apr 2019 03:43:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3011DAC17;
        Tue,  2 Apr 2019 07:43:16 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 9847B1E42C7; Tue,  2 Apr 2019 09:43:15 +0200 (CEST)
Date:   Tue, 2 Apr 2019 09:43:15 +0200
From:   Jan Kara <jack@suse.cz>
To:     Jiufei Xue <xuejiufei@gmail.com>
Cc:     Jiufei Xue <jiufei.xue@linux.alibaba.com>,
        linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz,
        renzhen@linux.alibaba.com
Subject: Re: [PATCH v2] jbd2: check superblock mapped prior to committing
Message-ID: <20190402074315.GA12133@quack2.suse.cz>
References: <20190328100750.71045-1-jiufei.xue@linux.alibaba.com>
 <a406d83f-78a1-7f32-6ddb-9ec9df7a05ab@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a406d83f-78a1-7f32-6ddb-9ec9df7a05ab@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi,

On Tue 02-04-19 12:11:33, Jiufei Xue wrote:
> can I get your Acked-by?

Ted, tracks patches in patchwork and he processes less important fixes in
bigger batches when he has time. So don't be afraid, your patch is not lost
:)

								Honza

> 
> Thanks,
> Jiufei
> 
> On 2019/3/28 下午6:07, Jiufei Xue wrote:
> > We hit a BUG at fs/buffer.c:3057 if we detached the nbd device
> > before unmounting ext4 filesystem.
> >
> > The typical chain of events leading to the BUG:
> > jbd2_write_superblock
> >   submit_bh
> >     submit_bh_wbc
> >       BUG_ON(!buffer_mapped(bh));
> >
> > The block device is removed and all the pages are invalidated. JBD2
> > was trying to write journal superblock to the block device which is
> > no longer present.
> >
> > Fix this by checking the journal superblock's buffer head prior to
> > submitting.
> >
> > Cc: stable@kernel.org
> > Reported-by: Eric Ren <renzhen@linux.alibaba.com>
> > Signed-off-by: Jiufei Xue <jiufei.xue@linux.alibaba.com>
> > Reviewed-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/jbd2/journal.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> > index 382c030cc78b..37e16d969925 100644
> > --- a/fs/jbd2/journal.c
> > +++ b/fs/jbd2/journal.c
> > @@ -1350,6 +1350,10 @@ static int jbd2_write_superblock(journal_t *journal, int write_flags)
> >  	journal_superblock_t *sb = journal->j_superblock;
> >  	int ret;
> >  
> > +	/* Buffer got discarded which means block device got invalidated */
> > +	if (!buffer_mapped(bh))
> > +		return -EIO;
> > +
> >  	trace_jbd2_write_superblock(journal, write_flags);
> >  	if (!(journal->j_flags & JBD2_BARRIER))
> >  		write_flags &= ~(REQ_FUA | REQ_PREFLUSH);
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
