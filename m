Return-Path: <SRS0=Ozrj=P6=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DD1EC282C5
	for <linux-ext4@archiver.kernel.org>; Tue, 22 Jan 2019 10:00:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2CA220823
	for <linux-ext4@archiver.kernel.org>; Tue, 22 Jan 2019 10:00:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=philpotter-co-uk.20150623.gappssmtp.com header.i=@philpotter-co-uk.20150623.gappssmtp.com header.b="K/33qtzx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbfAVKAV (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 22 Jan 2019 05:00:21 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53537 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727299AbfAVKAV (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Jan 2019 05:00:21 -0500
Received: by mail-wm1-f66.google.com with SMTP id d15so13465418wmb.3
        for <linux-ext4@vger.kernel.org>; Tue, 22 Jan 2019 02:00:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=philpotter-co-uk.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GhFIv8J25HgNKwXu1nW+Nin5xpaFtifQ9/YdY0m9u5k=;
        b=K/33qtzxgW5LZbNWGpJrgWf92WAdRSwcCkqlEqnBOk9QwqL3uDXeoOMTG7rD7+QVa1
         XY+3wg4nViqGD09eU6LmAkZ/pGkzLpkGgGurNNUPgPUQGn4HQun96frYv52ulWdkCXNX
         UjBKSlHY474G2r3ZYcn7jMqUWzRQX380buNG6I/DuE0QWz1WNSDYoBWZsr5z4JEGlECy
         5SpQNV/G4KwBMRnautu+bi+UBi2dI544vzPk+LwURSD+DW8Frg1KIZj/pD8nJ1A8DHSS
         NQHGztv3WvG3xirXrlkR31RuTbDpu18sbTTkdYQOLeEHb55yNnP3zD7C9+KPi2jXKJZS
         lr8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=GhFIv8J25HgNKwXu1nW+Nin5xpaFtifQ9/YdY0m9u5k=;
        b=K7TCLLBtQUwv1WIHa1suTcqbs5PXnhfUOdIj0t19lPqHkRotNmK0E85FEMOk2VH516
         k/CA8oRBzM1876cx2Qje7Yk8E0sSfo+H0W5ADeEqI0lzXwo2n4S+WyA2IiWrBrFe3X4G
         acbN+d3dNZ63FfRXEGLQmVSNdw/A/wMsgfPuwtv+DonnmFBPqPE1TN8GeecHnHNASDWY
         3oyX40OPaEm/MjmxX/rbbwVkek+m1afu2TVimI0yir8KuCNQkx1wL4qWYm6EPCphyEvi
         pQE9BV6jEnSul5LOiOXEJmGjPAPJPf0ENRKOnX3AvEKpRrhn8cw5j1xKI880VYuqmQUQ
         BBBQ==
X-Gm-Message-State: AJcUukc9W8bXhA6O8zY/gDWAIc6QTPUE0gSC8M17dk0bbYsiXduZujjF
        7NWJwcyf3NsGHl55+FzJAIru/A==
X-Google-Smtp-Source: ALg8bN6l1/hjTdgWzXjYnPubrv8QVLXGhjXYZjc/iA26VZvK8jmuIpDDX7uQfby9/1E/t3f0N+GNmQ==
X-Received: by 2002:a1c:968a:: with SMTP id y132mr2896058wmd.107.1548151218403;
        Tue, 22 Jan 2019 02:00:18 -0800 (PST)
Received: from pathfinder ([90.222.17.17])
        by smtp.gmail.com with ESMTPSA id s5sm33772414wmh.37.2019.01.22.02.00.17
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 22 Jan 2019 02:00:17 -0800 (PST)
Date:   Tue, 22 Jan 2019 10:00:16 +0000
From:   Phillip Potter <phil@philpotter.co.uk>
To:     Jan Kara <jack@suse.cz>
Cc:     tytso@mit.edu, amir73il@gmail.com, viro@zeniv.linux.org.uk,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [RFC][PATCH v5 07/09] ext4: use common file type conversion
Message-ID: <20190122100016.GB3245@pathfinder>
References: <20190121005435.GA32365@pathfinder>
 <20190121142048.GB21694@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190121142048.GB21694@quack2.suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Jan 21, 2019 at 03:20:48PM +0100, Jan Kara wrote:
> On Mon 21-01-19 00:54:35, Phillip Potter wrote:
> > Deduplicate the ext4 file type conversion implementation and define
> > EXT4_FT_* to match shared FT_* - file systems that use the same file
> > types as defined by POSIX do not need to define their own versions
> > and can use the common helper functions decared in fs_types.h and
> > implemented in fs_types.c
> > 
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
> 
> Looks good to me. You can add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>
> 
> 								Honza
> 
Dear Jan,

Thank you for this, much appreciated.

Regards,
Phil
