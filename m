Return-Path: <SRS0=rve6=Q5=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 226E0C4151A
	for <linux-ext4@archiver.kernel.org>; Fri, 22 Feb 2019 06:20:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E693A2087C
	for <linux-ext4@archiver.kernel.org>; Fri, 22 Feb 2019 06:20:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726050AbfBVGUp (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 22 Feb 2019 01:20:45 -0500
Received: from len.romanrm.net ([91.121.75.85]:57978 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725873AbfBVGUp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 22 Feb 2019 01:20:45 -0500
X-Greylist: delayed 310 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Feb 2019 01:20:44 EST
Received: from natsu (unknown [IPv6:fd39::e99e:8f1b:cfc9:ccb8])
        by len.romanrm.net (Postfix) with SMTP id E3CCB203F0;
        Fri, 22 Feb 2019 06:15:32 +0000 (UTC)
Date:   Fri, 22 Feb 2019 11:15:32 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Jeff Mahoney <jeffm@suse.com>, Keith Busch <keith.busch@intel.com>,
        Ric Wheeler <ricwheeler@gmail.com>,
        Dave Chinner <david@fromorbit.com>,
        lsf-pc@lists.linux-foundation.org,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-block@vger.kernel.org
Subject: Re: [LSF/MM TOPIC] More async operations for file systems - async
 discard?
Message-ID: <20190222111532.4ead81dc@natsu>
In-Reply-To: <yq17edsil17.fsf@oracle.com>
References: <92ab41f7-35bc-0f56-056f-ed88526b8ea4@gmail.com>
        <20190217210948.GB14116@dastard>
        <46540876-c222-0889-ddce-44815dcaad04@gmail.com>
        <20190220234723.GA5999@localhost.localdomain>
        <45c27fea-6d74-2adc-fe9d-e314ce4f3672@suse.com>
        <yq17edsil17.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, 21 Feb 2019 22:01:24 -0500
"Martin K. Petersen" <martin.petersen@oracle.com> wrote:

> Consequently, many of the modern devices that claim to support discard
> to make us software folks happy (or to satisfy a purchase order
> requirements) complete the commands without doing anything at all.
> We're simply wasting queue slots.

Any example of such devices? Let alone "many"? Where you would issue a
full-device blkdiscard, but then just read back old data.

I know only one model(PLEXTOR PX-512M6M) of dozens tested, which is peculiar
that it ignores trim specifically for the 1st sector of the entire disk. But
implying there are "many" which no-op it entirely, seems like imagining the
world already works like you would assume it to.

-- 
With respect,
Roman
