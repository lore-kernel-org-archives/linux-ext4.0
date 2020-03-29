Return-Path: <SRS0=hrf1=5O=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28770C43331
	for <linux-ext4@archiver.kernel.org>; Sun, 29 Mar 2020 04:01:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0008920659
	for <linux-ext4@archiver.kernel.org>; Sun, 29 Mar 2020 04:01:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725976AbgC2EAQ (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 29 Mar 2020 00:00:16 -0400
Received: from mx.sdf.org ([205.166.94.20]:52679 "EHLO mx.sdf.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgC2EAQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 29 Mar 2020 00:00:16 -0400
Received: from sdf.org (IDENT:lkml@sdf.lonestar.org [205.166.94.16])
        by mx.sdf.org (8.15.2/8.14.5) with ESMTPS id 02T40C6E028586
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits) verified NO);
        Sun, 29 Mar 2020 04:00:13 GMT
Received: (from lkml@localhost)
        by sdf.org (8.15.2/8.12.8/Submit) id 02T40CNt013009;
        Sun, 29 Mar 2020 04:00:12 GMT
Date:   Sun, 29 Mar 2020 04:00:12 +0000
From:   George Spelvin <lkml@SDF.ORG>
To:     Andreas Dilger <adilger@dilger.ca>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        linux-ext4 <linux-ext4@vger.kernel.org>, lkml@sdf.org
Subject: Re: [RFC PATCH v1 08/50] fs/ext4/ialloc.c: Replace % with
 reciprocal_scale() TO BE VERIFIED
Message-ID: <20200329040012.GB11951@SDF.ORG>
References: <202003281643.02SGh9vH007105@sdf.org>
 <9A60C390-349E-4A90-A812-F04EB5A82136@dilger.ca>
 <20200328231536.GA11951@SDF.ORG>
 <EC88E8EB-7303-45FB-85B9-A007FBE5F5A0@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EC88E8EB-7303-45FB-85B9-A007FBE5F5A0@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sat, Mar 28, 2020 at 06:10:11PM -0600, Andreas Dilger wrote:
> On Mar 28, 2020, at 5:15 PM, George Spelvin <lkml@SDF.ORG> wrote:
>> Also, we could, if desired, eliminate the i variable entirely
>> using the fact that we have a copy of the starting position cached
>> in parent_group.  I.e.
>> 
>> 		g = parent_group = reciprocal_scale(grp, ngroups);
>> -		for (i = 0; i < ngroups; i++, ++g == ngroups && (g = 0)) {
>> +		do {
>> 			...
>> -		}
>> +			if (++g == ngroups)
>> +				g = 0;
>> +		} while (g != parent_group);

> I was looking at whether we could use a for-loop without "i"?  Something like:
> 
> 	for (g = parent_group + 1; g != parent_group; ++g >= ngroups && (g = 0))
> 
> The initial group is parent_group + 1, to avoid special-casing when the
> initial parent_group = 0 (which would prevent the loop from terminating).

That's the first option I presented, above.  Since a for() loop
tests before each iteration, if the counter is strictly modulo
ngroups, there's no way to execute the loop body more than ngroups-1
times.

That's why I changed to do{}while(), which has a minimum of 1 (it can't
handle ngroups == 0), but can mimic the current loop's execution
perfectly (no initial +1 offset).
