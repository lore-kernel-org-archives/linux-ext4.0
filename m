Return-Path: <SRS0=xo2J=Q3=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CC43C10F08
	for <linux-ext4@archiver.kernel.org>; Wed, 20 Feb 2019 23:47:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDE4320859
	for <linux-ext4@archiver.kernel.org>; Wed, 20 Feb 2019 23:47:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbfBTXr0 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 20 Feb 2019 18:47:26 -0500
Received: from mga07.intel.com ([134.134.136.100]:23252 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725989AbfBTXr0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 20 Feb 2019 18:47:26 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Feb 2019 15:47:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,392,1544515200"; 
   d="scan'208";a="135900891"
Received: from unknown (HELO localhost.localdomain) ([10.232.112.69])
  by orsmga002.jf.intel.com with ESMTP; 20 Feb 2019 15:47:22 -0800
Date:   Wed, 20 Feb 2019 16:47:24 -0700
From:   Keith Busch <keith.busch@intel.com>
To:     Ric Wheeler <ricwheeler@gmail.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        lsf-pc@lists.linux-foundation.org,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-block@vger.kernel.org
Subject: Re: [LSF/MM TOPIC] More async operations for file systems - async
 discard?
Message-ID: <20190220234723.GA5999@localhost.localdomain>
References: <92ab41f7-35bc-0f56-056f-ed88526b8ea4@gmail.com>
 <20190217210948.GB14116@dastard>
 <46540876-c222-0889-ddce-44815dcaad04@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46540876-c222-0889-ddce-44815dcaad04@gmail.com>
User-Agent: Mutt/1.9.1 (2017-09-22)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sun, Feb 17, 2019 at 06:42:59PM -0500, Ric Wheeler wrote:
> I think the variability makes life really miserable for layers above it.
> 
> Might be worth constructing some tooling that we can use to validate or
> shame vendors over - testing things like a full device discard, discard of
> fs block size and big chunks, discard against already discarded, etc.

With respect to fs block sizes, one thing making discards suck is that
many high capacity SSDs' physical page sizes are larger than the fs block
size, and a sub-page discard is worse than doing nothing.

We've discussed previously about supporting block size larger than
the system's page size, but it doesn't look like that's gone anywhere.
Maybe it's worth revisiting since it's really inefficient if you write
or discard at the smaller granularity.

