Return-Path: <SRS0=p9Mw=QB=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DF7AC282C6
	for <linux-ext4@archiver.kernel.org>; Fri, 25 Jan 2019 16:24:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D853218F0
	for <linux-ext4@archiver.kernel.org>; Fri, 25 Jan 2019 16:24:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbfAYQYv (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 25 Jan 2019 11:24:51 -0500
Received: from mga06.intel.com ([134.134.136.31]:15129 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726108AbfAYQYv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 25 Jan 2019 11:24:51 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Jan 2019 08:24:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,521,1539673200"; 
   d="scan'208";a="111068853"
Received: from unknown (HELO localhost.localdomain) ([10.232.112.69])
  by orsmga006.jf.intel.com with ESMTP; 25 Jan 2019 08:24:49 -0800
Date:   Fri, 25 Jan 2019 09:23:53 -0700
From:   Keith Busch <keith.busch@intel.com>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-nvme@lists.infradead.org,
        jack@suse.com, david@fromorbit.com, tytso@mit.edu,
        prakash.v@samsung.com
Subject: Re: [PATCH v2 0/4] Write-hint for FS journal
Message-ID: <20190125162353.GA11210@localhost.localdomain>
References: <CGME20190109153328epcas2p4643cbdc7a2182b47893a2bcaa0778e17@epcas2p4.samsung.com>
 <1547047861-7271-1-git-send-email-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1547047861-7271-1-git-send-email-joshi.k@samsung.com>
User-Agent: Mutt/1.9.1 (2017-09-22)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Jan 09, 2019 at 09:00:57PM +0530, Kanchan Joshi wrote:
> Towards supporing write-hints/streams for filesystem journal.                   
>                                                                                 
> Here is the v1 patch for background -                                           
> https://marc.info/?l=linux-fsdevel&m=154444637519020&w=2                        
>                                                                                 
> Changes since v1:                                                               
> - introduce four more hints for in-kernel use, as recommended by Dave chinner   
>   & Jens axboe. This isolates kernel-mode hints from user-mode ones.            

The nvme driver disables streams if the controller doesn't support
BLK_MAX_WRITE_HINT number of streams, so this series breaks the feature
for controllers that only support up to 4.
