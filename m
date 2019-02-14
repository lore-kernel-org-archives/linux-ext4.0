Return-Path: <SRS0=5TFS=QV=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 782FBC10F04
	for <linux-ext4@archiver.kernel.org>; Thu, 14 Feb 2019 20:20:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40FA02192B
	for <linux-ext4@archiver.kernel.org>; Thu, 14 Feb 2019 20:20:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="ydS3i/y3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394302AbfBNUUX (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 14 Feb 2019 15:20:23 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:42068 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389648AbfBNUUX (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Feb 2019 15:20:23 -0500
Received: by mail-ot1-f67.google.com with SMTP id i5so12723727oto.9
        for <linux-ext4@vger.kernel.org>; Thu, 14 Feb 2019 12:20:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+PAw8AqZ2Jrt0E9kNe8G7wdNgKe/LoMZ6aYN/0Km/Ew=;
        b=ydS3i/y3tQtv90ROBdqP9Dvy8KRVTcNrgSvrAq3QCwPBLPL61vBCRuRyRaTeyAUSpw
         yWjXUVUfMyAGsIsxCpFuhbU79FxVBFkt2qoWZ0PXd1ZnvwJ3o0POdgwgxQ/T0WUOgrjw
         80MF2fCya9suHMSGnT/ib3COL/Dar5Rj3ov5SvyVECqaTG8ZzxdwU4CL3a7A0OG1RPee
         3fCGkFvyuDCZs1okEovJsFepoQwckRQdWqif89a9lxAknHXLV52RdvGp1dxORRSqIu1R
         NY8g8UUWNZRawgRzmYPcT1iqWXXlIpQBvs5hTaXSSfxpA7f3yZm5kpl6ZSmHhT65wFQa
         SNqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+PAw8AqZ2Jrt0E9kNe8G7wdNgKe/LoMZ6aYN/0Km/Ew=;
        b=qBqTyYNhNI2KOfs3OsrwNtkop8a26LMAfln6F/I2ao82l/MmpKnRnxV+Kj/6cX2hE2
         bSgPWa6kpLHIuZVIOa1z1dEhVjvNd1XwcVGqSdPAE3tBb1vLjKhI1vq13rHYJGtn/LB+
         Gcwk8LEceeZAoLP4CQwB0t3xLvbcMOrI+m60Lq0NtoG+r9YOjCOAJPD5PHeUwp6q90lD
         w0t9o2Kx+r3Og8x5XULu/BY4q7zCvxNyChICmJO48F5F7OPoXk0Hg66SDoHSs3JEbX4y
         6DZVM8FCBR80IiSYi1vdBjWuw8UYQ+7X68/tBOOQObJkXIOpWNBBtpyrv54LRZRC+lXJ
         XRIQ==
X-Gm-Message-State: AHQUAubQH86EWWDqYc4qG4TFXl0+JvkbyK0ija0kTqmz+saxJ2H1YUwb
        MwtayG2y5xaw8u40wmePhbqoiycz2XET2PPojApwvg==
X-Google-Smtp-Source: AHgI3IaaQF50AFFrQqvhckFtVsPtC1LgQloQ3XyqgYww9UxNegUyVJ+uWlRA8gu24/Y7EF3uFH2zWa00AIFRJVfchm4=
X-Received: by 2002:aca:fc06:: with SMTP id a6mr3701842oii.0.1550175622423;
 Thu, 14 Feb 2019 12:20:22 -0800 (PST)
MIME-Version: 1.0
References: <CAPcyv4jyCDJTpGZB6qVX7_FiaxJfDzWA1cw8dfPjHM2j3j3yqQ@mail.gmail.com>
 <20190214134622.GG4525@dhcp22.suse.cz> <CAPcyv4gxFKBQ9eVdn+pNEzBXRfw6Qwfmu21H2i5uj-PyFmRAGQ@mail.gmail.com>
 <20190214191013.GA3420@redhat.com> <CAPcyv4jLTdJyTOy715qvBL_j_deiLoBmu_thkUnFKZKMvZL6hA@mail.gmail.com>
 <20190214200840.GB12668@bombadil.infradead.org>
In-Reply-To: <20190214200840.GB12668@bombadil.infradead.org>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 14 Feb 2019 12:20:11 -0800
Message-ID: <CAPcyv4hsDqvrV5yiDq8oWPuWb3WpuCEk_HB4qBxfiDpUwo75QQ@mail.gmail.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] The end of the DAX experiment
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Jerome Glisse <jglisse@redhat.com>,
        Michal Hocko <mhocko@kernel.org>,
        lsf-pc@lists.linux-foundation.org,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Feb 14, 2019 at 12:09 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Thu, Feb 14, 2019 at 11:31:24AM -0800, Dan Williams wrote:
> > On Thu, Feb 14, 2019 at 11:10 AM Jerome Glisse <jglisse@redhat.com> wrote:
> > > I am just again working on my struct page mapping patchset as well as
> > > the generic page write protection that sits on top. I hope to be able
> > > to post the v2 in couple weeks. You can always look at my posting last
> > > year to see more details.
> >
> > Yes, I have that in mind as one of the contenders. However, it's not
> > clear to me that its a suitable fit for filesystem-reflink. Others
> > have floated the 'page proxy' idea, so it would be good to discuss the
> > merits of the general approaches.
>
> ... and my preferred option of putting pfn entries in the page cache.

Another option to include the discussion.

> Or is that what you meant by "page proxy"?

Page proxy would be an object that a filesystem could allocate to
point back to a single physical 'struct page *'. The proxy would
contain an override for page->index.
