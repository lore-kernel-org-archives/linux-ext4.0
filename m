Return-Path: <SRS0=s9Oo=3G=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 620FEC33CB1
	for <linux-ext4@archiver.kernel.org>; Fri, 17 Jan 2020 16:36:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41DAF2087E
	for <linux-ext4@archiver.kernel.org>; Fri, 17 Jan 2020 16:36:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728600AbgAQQg5 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 17 Jan 2020 11:36:57 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:38812 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726506AbgAQQg4 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Jan 2020 11:36:56 -0500
Received: from callcc.thunk.org (guestnat-104-133-0-111.corp.google.com [104.133.0.111] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 00HGanJR015346
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Jan 2020 11:36:50 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 7F7144207DF; Fri, 17 Jan 2020 11:36:49 -0500 (EST)
Date:   Fri, 17 Jan 2020 11:36:49 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     Ext4 Developers List <linux-ext4@vger.kernel.org>,
        naoto.kobayashi4c@gmail.com
Subject: Re: [PATCH] ext4: drop ext4_kvmalloc()
Message-ID: <20200117163649.GC448999@mit.edu>
References: <20200116151239.GA253859@mit.edu>
 <20200116155031.266620-1-tytso@mit.edu>
 <20200117103048.GB17141@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200117103048.GB17141@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Jan 17, 2020 at 11:30:48AM +0100, Jan Kara wrote:
> On Thu 16-01-20 10:50:31, Theodore Ts'o wrote:
> > As Jan pointed out[1], as of commit 81378da64de ("jbd2: mark the
> > transaction context with the scope GFP_NOFS context") we use
> > memalloc_nofs_{save,restore}() while a jbd2 handle is active.  So
> > ext4_kvmalloc() so we can call allocate using GFP_NOFS is no longer
> > necessary.
> > 
> > [1] https://lore.kernel.org/r/20200109100007.GC27035@quack2.suse.cz
> 
> Your signed-off-by is missing but otherwise the patch looks good to me. You
> can add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>

Thanks, applied with my signed-off-by and a Link: trailer.

		     		      	    - Ted
