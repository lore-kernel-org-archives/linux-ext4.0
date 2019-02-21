Return-Path: <SRS0=OaGm=Q4=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A60E3C00319
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Feb 2019 23:55:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7422E2084D
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Feb 2019 23:55:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbfBUXzK (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 21 Feb 2019 18:55:10 -0500
Received: from mx2.suse.de ([195.135.220.15]:52034 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726335AbfBUXzK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 21 Feb 2019 18:55:10 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 973B6AD76;
        Thu, 21 Feb 2019 23:55:08 +0000 (UTC)
Subject: Re: [LSF/MM TOPIC] More async operations for file systems - async
 discard?
To:     Keith Busch <keith.busch@intel.com>,
        Ric Wheeler <ricwheeler@gmail.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        lsf-pc@lists.linux-foundation.org,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-block@vger.kernel.org
References: <92ab41f7-35bc-0f56-056f-ed88526b8ea4@gmail.com>
 <20190217210948.GB14116@dastard>
 <46540876-c222-0889-ddce-44815dcaad04@gmail.com>
 <20190220234723.GA5999@localhost.localdomain>
From:   Jeff Mahoney <jeffm@suse.com>
Message-ID: <45c27fea-6d74-2adc-fe9d-e314ce4f3672@suse.com>
Date:   Thu, 21 Feb 2019 18:55:05 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:65.0)
 Gecko/20100101 Thunderbird/65.0
MIME-Version: 1.0
In-Reply-To: <20190220234723.GA5999@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On 2/20/19 6:47 PM, Keith Busch wrote:
> On Sun, Feb 17, 2019 at 06:42:59PM -0500, Ric Wheeler wrote:
>> I think the variability makes life really miserable for layers above it.
>>
>> Might be worth constructing some tooling that we can use to validate or
>> shame vendors over - testing things like a full device discard, discard of
>> fs block size and big chunks, discard against already discarded, etc.
> 
> With respect to fs block sizes, one thing making discards suck is that
> many high capacity SSDs' physical page sizes are larger than the fs block
> size, and a sub-page discard is worse than doing nothing.
> 
> We've discussed previously about supporting block size larger than
> the system's page size, but it doesn't look like that's gone anywhere.
> Maybe it's worth revisiting since it's really inefficient if you write
> or discard at the smaller granularity.

Isn't this addressing the problem at the wrong layer?  There are other
efficiencies to be gained by larger block sizes, but better discard
behavior is a side effect.  As Dave said, the major file systems already
assemble contiguous extents as large we can can before sending them to
discard.  The lower bound for that is the larger of minimum lengths
passed by the user or provided by the block layer.  We've always been
told "don't worry about what the internal block size is, that only
matters to the FTL."  That's obviously not true, but when devices only
report a 512 byte granularity, we believe them and will issue discard
for the smallest size that makes sense for the file system regardless of
whether it makes sense (internally) for the SSD.  That means 4k for
pretty much anything except btrfs metadata nodes, which are 16k.

So, I don't think changing the file system block size is the right
approach.  It *may* bring benefits, but I think many of the same
benefits can be gained by using the minimum-size option for fstrim and
allowing the discard mount options to accept a minimum size as well.

-Jeff

-- 
Jeff Mahoney
SUSE Labs
