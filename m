Return-Path: <SRS0=3ydV=VX=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23B6FC76191
	for <linux-ext4@archiver.kernel.org>; Fri, 26 Jul 2019 22:55:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA5C621994
	for <linux-ext4@archiver.kernel.org>; Fri, 26 Jul 2019 22:55:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727899AbfGZWzc (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 26 Jul 2019 18:55:32 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:44565 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727368AbfGZWzc (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Jul 2019 18:55:32 -0400
Received: from callcc.thunk.org ([209.117.102.182])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x6QMt9eZ010885
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Jul 2019 18:55:11 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 7AF1D4202F5; Fri, 26 Jul 2019 18:55:08 -0400 (EDT)
Date:   Fri, 26 Jul 2019 18:55:08 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        Masato Suzuki <masato.suzuki@wdc.com>
Subject: Re: [PATCH] ext4: Fix deadlock on page reclaim
Message-ID: <20190726225508.GA13729@mit.edu>
Mail-Followup-To: "Theodore Y. Ts'o" <tytso@mit.edu>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        Masato Suzuki <masato.suzuki@wdc.com>
References: <20190725093358.30679-1-damien.lemoal@wdc.com>
 <20190725115442.GA15733@infradead.org>
 <20190726224423.GE7777@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190726224423.GE7777@dread.disaster.area>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sat, Jul 27, 2019 at 08:44:23AM +1000, Dave Chinner wrote:
> > 
> > This looks like something that could hit every file systems, so
> > shouldn't we fix this in common code?  We could also look into
> > just using memalloc_nofs_save for the page cache allocation path
> > instead of the per-mapping gfp_mask.
> 
> I think it has to be the entire IO path - any allocation from the
> underlying filesystem could recurse into the top level filesystem
> and then deadlock if the memory reclaim submits IO or blocks on
> IO completion from the upper filesystem. That's a bloody big hammer
> for something that is only necessary when there are stacked
> filesystems like this....

Yeah.... that's why using memalloc_nofs_save() probably makes the most
sense, and dm_zoned should use that before it calls into ext4.

       	   	    	       	    	   - Ted
