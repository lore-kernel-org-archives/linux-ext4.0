Return-Path: <SRS0=4ybF=RB=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1DB1C43381
	for <linux-ext4@archiver.kernel.org>; Tue, 26 Feb 2019 08:30:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A72D32173C
	for <linux-ext4@archiver.kernel.org>; Tue, 26 Feb 2019 08:30:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726188AbfBZIaL (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 26 Feb 2019 03:30:11 -0500
Received: from mx2.suse.de ([195.135.220.15]:48364 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725879AbfBZIaK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 26 Feb 2019 03:30:10 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 95415AEF6;
        Tue, 26 Feb 2019 08:30:09 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id D951F1E156D; Tue, 26 Feb 2019 09:30:08 +0100 (CET)
Date:   Tue, 26 Feb 2019 09:30:08 +0100
From:   Jan Kara <jack@suse.cz>
To:     Sahitya Tummala <stummala@codeaurora.org>
Cc:     Jan Kara <jack@suse.cz>, tytso@mit.edu, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: huge fsync latencies for a small file on ext4
Message-ID: <20190226083008.GC10991@quack2.suse.cz>
References: <b1ba05256affe171c2afca6c3aceeb7a@codeaurora.org>
 <20190219135302.GB27420@quack2.suse.cz>
 <20190225051007.GA32651@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190225051007.GA32651@codeaurora.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon 25-02-19 10:40:07, Sahitya Tummala wrote:
> On Tue, Feb 19, 2019 at 02:53:02PM +0100, Jan Kara wrote:
> > One has to be really careful when using i_size like this. By the time the
> > transaction is committing, i_size could have been reduced from the value at
> > the time page writeback was issued. And that change will be journalled only
> > in the following transaction. So if the system crashes in the wrong moment,
> > user could see uninitialized blocks between new_size and old_size after
> > journal replay. So I don't think your patch is really correct.
> > 
> 
> Thanks Jan for the clarification on the patch. I agree with your comments.
> 
> From that discussion, I think the problem that it is discussing is w.r.t
> journal thread waiting for on-going active transaction updates to be done
> and thus causing commit latencies.

Yes.

> And I think the proposal is to do not
> hold any handle while extents are being mapped in ext4_map_blocks() but
> defer it till IO is completely done.

Yes, real block allocation and insertion in extent tree will happen after
IO completion.

> And with the new proposal since the inode will be added to
> transaction->t_inode_list only after the IO is completed, there will be
> no longer the need to do journal_finish_inode_data_buffers() in the journal
> context and thus this problem also will not be observed? Is my understanding
> correct, please clarify.

Actually, with the new proposal, we can just completely stop adding inodes
to transaction->t_inode_list. But otherwise you're right.

									Honza

> 
> > Ted has outlined a plan how to get rid of data=ordered limitations [1] and
> > thus also this problem. It is quite some work but you're certainly welcome
> > to help out :)
> > 
> > [1] https://www.spinics.net/lists/linux-ext4/msg64175.html
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
