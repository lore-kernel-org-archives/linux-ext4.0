Return-Path: <SRS0=9sDM=ZT=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 897B7C432C0
	for <linux-ext4@archiver.kernel.org>; Wed, 27 Nov 2019 19:53:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 682832082D
	for <linux-ext4@archiver.kernel.org>; Wed, 27 Nov 2019 19:53:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727297AbfK0TxU (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 27 Nov 2019 14:53:20 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:46693 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727279AbfK0TxU (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Nov 2019 14:53:20 -0500
Received: from callcc.thunk.org (97-71-153.205.biz.bhn.net [97.71.153.205] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id xARJrD8k032377
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Nov 2019 14:53:14 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id B47054202FD; Wed, 27 Nov 2019 14:53:12 -0500 (EST)
Date:   Wed, 27 Nov 2019 14:53:12 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-ext4@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] ext4: Fix ext4_empty_dir() for directories with holes
Message-ID: <20191127195312.GB22921@mit.edu>
References: <20191127131258.1163-1-jack@suse.cz>
 <20191127194415.GA22921@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191127194415.GA22921@mit.edu>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Nov 27, 2019 at 02:44:15PM -0500, Theodore Y. Ts'o wrote:
> On Wed, Nov 27, 2019 at 02:12:58PM +0100, Jan Kara wrote:
> > Function ext4_empty_dir() doesn't correctly handle directories with
> > holes and crashes on bh->b_data dereference when bh is NULL....
> 
> Hi Jan,
> 
> Thanks for the patch.
> 
> However, it looks like we're still vulnerable to the first block of
> the directory being NULL?
> 
> > @@ -2833,19 +2833,25 @@ bool ext4_empty_dir(struct inode *inode)
> >  		return true;
> >  
> >  	de = (struct ext4_dir_entry_2 *) bh->b_data;
>                                          ^^^^^^^^^^^

Ah, never mind.  Since we're calling ext4_read_dirblock() with
DIRENT_HTREE, if bh is NULL, it will get caught earlier, and
ext4_read_dirblock() will return ERR_PTR(-EFSCORRUPTED).

						- Ted
