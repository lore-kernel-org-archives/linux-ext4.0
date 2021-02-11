Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2602C433E0
	for <linux-ext4@archiver.kernel.org>; Thu, 11 Feb 2021 14:29:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 800C664E23
	for <linux-ext4@archiver.kernel.org>; Thu, 11 Feb 2021 14:29:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232020AbhBKO3h (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 11 Feb 2021 09:29:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbhBKO1S (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Feb 2021 09:27:18 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA5F9C061786;
        Thu, 11 Feb 2021 06:26:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=sj97A1FDFENPqakt33g1HE1eopZz9zZrknGdche1pZw=; b=UI6wmsC6f1Q37cjg5BZyBtHJK1
        NgBK1KBg3ulPKm84h15eY0H938wnq0Ps9/n1u9LO7MNAuB8dO2cSNpEsRRGDMnSFSVqPjkNQNPkxQ
        0s3dUvDykwFUiS1JgCJvm9e83li1rD3un+G12IdJuH2TPjsskW09hILEgrzLpZez7Nyo+r+e2IkD5
        xlwul7xkjZAaGtyb8wdEeFwtQaxMKvgVHg3kXLgpz+OWYfTLS4C0Z1po7Fu92QncBpomMIfF2bUjB
        vVua5Xbw/7u3/EQ/EuCk1PZMqColbfywnDrrRYdO1PmfjzL9XrUbQJX3nWlH7RtmE70CjbeveXerQ
        XvSyGqLA==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lACvO-00ALJC-39; Thu, 11 Feb 2021 14:26:31 +0000
Date:   Thu, 11 Feb 2021 14:26:30 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Michal Hocko <mhocko@suse.com>
Cc:     Jan Kara <jack@suse.cz>, Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+bfdded10ab7dcd7507ae@syzkaller.appspotmail.com>,
        Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Theodore Ts'o <tytso@mit.edu>, Linux-MM <linux-mm@kvack.org>
Subject: Re: possible deadlock in start_this_handle (2)
Message-ID: <20210211142630.GK308988@casper.infradead.org>
References: <000000000000563a0205bafb7970@google.com>
 <20210211104947.GL19070@quack2.suse.cz>
 <CACT4Y+b5gSAAtX3DUf-H3aRxbir44MTO6BCC3XYvN=6DniT+jw@mail.gmail.com>
 <CACT4Y+a_iyaYY18Uw28bd178xjso=n6jfMBjyZuYJiNeo8x+LQ@mail.gmail.com>
 <20210211121020.GO19070@quack2.suse.cz>
 <YCUkaJFoPkl7ZvKE@dhcp22.suse.cz>
 <20210211125717.GH308988@casper.infradead.org>
 <YCUr99//z8hJmnDH@dhcp22.suse.cz>
 <20210211132533.GI308988@casper.infradead.org>
 <YCU9OR7SfRpwl4+4@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YCU9OR7SfRpwl4+4@dhcp22.suse.cz>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Feb 11, 2021 at 03:20:41PM +0100, Michal Hocko wrote:
> On Thu 11-02-21 13:25:33, Matthew Wilcox wrote:
> > On Thu, Feb 11, 2021 at 02:07:03PM +0100, Michal Hocko wrote:
> > > On Thu 11-02-21 12:57:17, Matthew Wilcox wrote:
> > > > > current->flags should be always manipulated from the user context. But
> > > > > who knows maybe there is a bug and some interrupt handler is calling it.
> > > > > This should be easy to catch no?
> > > > 
> > > > Why would it matter if it were?
> > > 
> > > I was thinking about a clobbered state because updates to ->flags are
> > > not atomic because this shouldn't ever be updated concurrently. So maybe
> > > a racing interrupt could corrupt the flags state?
> > 
> > I don't think that's possible.  Same-CPU races between interrupt and
> > process context are simpler because the CPU always observes its own writes
> > in order and the interrupt handler completes "between" two instructions.
> 
> I have to confess I haven't really thought the scenario through. My idea
> was to simply add a simple check for an irq context into ->flags setting
> routine because this should never be done in the first place. Not only
> for scope gfp flags but any other PF_ flags IIRC.

That's not automatically clear to me.  There are plenty of places
where an interrupt borrows the context of the task that it happens to
have interrupted.  Specifically, interrupts should be using GFP_ATOMIC
anyway, so this doesn't really make a lot of sense, but I don't think
it's necessarily wrong for an interrupt to call a function that says
"Definitely don't make GFP_FS allocations between these two points".
