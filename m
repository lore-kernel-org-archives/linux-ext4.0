Return-Path: <SRS0=NyoO=QE=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7BC3C282CF
	for <linux-ext4@archiver.kernel.org>; Mon, 28 Jan 2019 12:47:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A30B20881
	for <linux-ext4@archiver.kernel.org>; Mon, 28 Jan 2019 12:47:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbfA1MrM (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 28 Jan 2019 07:47:12 -0500
Received: from mx2.suse.de ([195.135.220.15]:36582 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726647AbfA1MrM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 28 Jan 2019 07:47:12 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9D9F4AC70;
        Mon, 28 Jan 2019 12:47:10 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id F07AD1E3FEF; Mon, 28 Jan 2019 13:47:09 +0100 (CET)
Date:   Mon, 28 Jan 2019 13:47:09 +0100
From:   Jan Kara <jack@suse.cz>
To:     Keith Busch <keith.busch@intel.com>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-nvme@lists.infradead.org, jack@suse.com, david@fromorbit.com,
        tytso@mit.edu, prakash.v@samsung.com
Subject: Re: [PATCH v2 0/4] Write-hint for FS journal
Message-ID: <20190128124709.GB27972@quack2.suse.cz>
References: <CGME20190109153328epcas2p4643cbdc7a2182b47893a2bcaa0778e17@epcas2p4.samsung.com>
 <1547047861-7271-1-git-send-email-joshi.k@samsung.com>
 <20190125162353.GA11210@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190125162353.GA11210@localhost.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri 25-01-19 09:23:53, Keith Busch wrote:
> On Wed, Jan 09, 2019 at 09:00:57PM +0530, Kanchan Joshi wrote:
> > Towards supporing write-hints/streams for filesystem journal.                   
> >                                                                                 
> > Here is the v1 patch for background -                                           
> > https://marc.info/?l=linux-fsdevel&m=154444637519020&w=2                        
> >                                                                                 
> > Changes since v1:                                                               
> > - introduce four more hints for in-kernel use, as recommended by Dave chinner   
> >   & Jens axboe. This isolates kernel-mode hints from user-mode ones.            
> 
> The nvme driver disables streams if the controller doesn't support
> BLK_MAX_WRITE_HINT number of streams, so this series breaks the feature
> for controllers that only support up to 4.

Right. Do you know if there are such controllers? Or are you just afraid
that there could be?

									Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
