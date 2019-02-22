Return-Path: <SRS0=rve6=Q5=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35E68C43381
	for <linux-ext4@archiver.kernel.org>; Fri, 22 Feb 2019 16:45:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 069EC2070D
	for <linux-ext4@archiver.kernel.org>; Fri, 22 Feb 2019 16:45:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727289AbfBVQpE (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 22 Feb 2019 11:45:04 -0500
Received: from mga14.intel.com ([192.55.52.115]:61220 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726485AbfBVQpD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 22 Feb 2019 11:45:03 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Feb 2019 08:45:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,400,1544515200"; 
   d="scan'208";a="128571244"
Received: from unknown (HELO localhost.localdomain) ([10.232.112.69])
  by orsmga003.jf.intel.com with ESMTP; 22 Feb 2019 08:45:02 -0800
Date:   Fri, 22 Feb 2019 09:45:05 -0700
From:   Keith Busch <keith.busch@intel.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Ric Wheeler <ricwheeler@gmail.com>,
        Dave Chinner <david@fromorbit.com>,
        lsf-pc@lists.linux-foundation.org,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-block@vger.kernel.org
Subject: Re: [LSF/MM TOPIC] More async operations for file systems - async
 discard?
Message-ID: <20190222164504.GB10066@localhost.localdomain>
References: <92ab41f7-35bc-0f56-056f-ed88526b8ea4@gmail.com>
 <20190217210948.GB14116@dastard>
 <46540876-c222-0889-ddce-44815dcaad04@gmail.com>
 <20190220234723.GA5999@localhost.localdomain>
 <yq18sy8ili7.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq18sy8ili7.fsf@oracle.com>
User-Agent: Mutt/1.9.1 (2017-09-22)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Feb 21, 2019 at 09:51:12PM -0500, Martin K. Petersen wrote:
> 
> Keith,
> 
> > With respect to fs block sizes, one thing making discards suck is that
> > many high capacity SSDs' physical page sizes are larger than the fs
> > block size, and a sub-page discard is worse than doing nothing.
> 
> That ties into the whole zeroing as a side-effect thing.
> 
> The devices really need to distinguish between discard-as-a-hint where
> it is free to ignore anything that's not a whole multiple of whatever
> the internal granularity is, and the WRITE ZEROES use case where the end
> result needs to be deterministic.

Exactly, yes, considering the deterministic zeroing behavior. For devices
supporting that, sub-page discards turn into a read-modify-write instead
of invalidating the page.  That increases WAF instead of improving it
as intended, and large page SSDs are most likely to have relatively poor
write endurance in the first place.

We have NVMe spec changes in the pipeline so devices can report this
granularity. But my real concern isn't with discard per se, but more
with the writes since we don't support "sector" sizes greater than the
system's page size. This is a bit of a different topic from where this
thread started, though.
