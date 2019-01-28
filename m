Return-Path: <SRS0=NyoO=QE=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6473C282CD
	for <linux-ext4@archiver.kernel.org>; Mon, 28 Jan 2019 23:25:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CCCC214DA
	for <linux-ext4@archiver.kernel.org>; Mon, 28 Jan 2019 23:25:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727175AbfA1XZO (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 28 Jan 2019 18:25:14 -0500
Received: from mga17.intel.com ([192.55.52.151]:42433 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726750AbfA1XZO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 28 Jan 2019 18:25:14 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Jan 2019 15:25:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,535,1539673200"; 
   d="scan'208";a="122080213"
Received: from unknown (HELO localhost.localdomain) ([10.232.112.69])
  by orsmga003.jf.intel.com with ESMTP; 28 Jan 2019 15:25:12 -0800
Date:   Mon, 28 Jan 2019 16:24:24 -0700
From:   Keith Busch <keith.busch@intel.com>
To:     Jan Kara <jack@suse.cz>
Cc:     Kanchan Joshi <joshi.k@samsung.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "jack@suse.com" <jack@suse.com>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "prakash.v@samsung.com" <prakash.v@samsung.com>
Subject: Re: [PATCH v2 0/4] Write-hint for FS journal
Message-ID: <20190128232423.GD15302@localhost.localdomain>
References: <CGME20190109153328epcas2p4643cbdc7a2182b47893a2bcaa0778e17@epcas2p4.samsung.com>
 <1547047861-7271-1-git-send-email-joshi.k@samsung.com>
 <20190125162353.GA11210@localhost.localdomain>
 <20190128124709.GB27972@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190128124709.GB27972@quack2.suse.cz>
User-Agent: Mutt/1.9.1 (2017-09-22)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Jan 28, 2019 at 04:47:09AM -0800, Jan Kara wrote:
> On Fri 25-01-19 09:23:53, Keith Busch wrote:
> > On Wed, Jan 09, 2019 at 09:00:57PM +0530, Kanchan Joshi wrote:
> > > Towards supporing write-hints/streams for filesystem journal.                   
> > >                                                                                 
> > > Here is the v1 patch for background -                                           
> > > https://marc.info/?l=linux-fsdevel&m=154444637519020&w=2                        
> > >                                                                                 
> > > Changes since v1:                                                               
> > > - introduce four more hints for in-kernel use, as recommended by Dave chinner   
> > >   & Jens axboe. This isolates kernel-mode hints from user-mode ones.            
> > 
> > The nvme driver disables streams if the controller doesn't support
> > BLK_MAX_WRITE_HINT number of streams, so this series breaks the feature
> > for controllers that only support up to 4.
> 
> Right. Do you know if there are such controllers? Or are you just afraid
> that there could be?

I've asked around, and the concensus I received is all currently support
at least 8, but they couldn't say if that would be true for potential
lower budget products. Can we implement a reasonable fallback to use
what's available?
