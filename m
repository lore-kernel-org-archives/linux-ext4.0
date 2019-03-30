Return-Path: <SRS0=QItb=SB=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF148C43381
	for <linux-ext4@archiver.kernel.org>; Sat, 30 Mar 2019 10:11:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE537218D9
	for <linux-ext4@archiver.kernel.org>; Sat, 30 Mar 2019 10:11:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UYBXZC7k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730597AbfC3KL7 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 30 Mar 2019 06:11:59 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:40838 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730477AbfC3KL6 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 30 Mar 2019 06:11:58 -0400
Received: by mail-pl1-f196.google.com with SMTP id b11so2165540plr.7;
        Sat, 30 Mar 2019 03:11:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=I7puil3Naxq97FFSUx/m/YfUm1pf8g706m2FOiq1ayY=;
        b=UYBXZC7k5dsoyNc98D9K0PScFJNDAbW/PuA0pJRzBIezkiFQQenlA0WwqQU9w1NmJL
         kJGmSscDdzkUiemAJX6rC3v5ea9+aYaDnYyrXG3Hmg6Wyrr/dyLdWhKMR3ij4vYyHKm1
         F2qNI6ugivL30twmvYbHV5rtFbuFfdwx8zyg5f6UatRJ++oKYsVVIZrB41Qfc7C70LeY
         /52ZGy/WNhLURYD4sHOy1VlOEmdQGmy+1CSanhtUpn904GpqgWCvBQtn8/y5cIpdSaF/
         oRxR3vJkuRjTxQEnvGFF5KCcFh3MIZ8cEvUKb9z4kL622OWoAeL3DzD59V/saqMZuhO+
         8zdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=I7puil3Naxq97FFSUx/m/YfUm1pf8g706m2FOiq1ayY=;
        b=lhO/HacxB1zCRB7jag8VuYX+R0tMxwwJ2EU8v+b2A12egDYg2/lAuKe+417QPE141C
         5fhzsKGlQMawjeRj9iix9u9GbEl8o7P5VVof2SxtHeikIdF84bj10PpCgufk/xEc4IGi
         O/e8VzbT8L1kI5uqARUXJLtmKHZtGxiSNNwa1nQ90a31IYCb8vWxCncaZl018e6L64ux
         PhqBmHk+5h2dc1/KtErnXf0VJ0osFO4NWNEKl6i3bp/LOrbpNOE4lny9j7pj0ma30KjR
         DvetXqbScHUeel0ED+9tCUMmtTsd7EYs/vKAP/uzMN6GhXu3Ddl/DWQaJZGGoGGtVoHd
         Gkww==
X-Gm-Message-State: APjAAAU1ADY7lC4Q7cAtLwwSyQwXxpwITQqk9KPzFbqMPoMUTgBjm4ib
        Gz1f1/n+lXguJWa7HxdYad8=
X-Google-Smtp-Source: APXvYqwrPhSIze28U/LjaZQo4FmtP4SKuz+5v6nPSl4fBPCNSk3VGt6VS1GWsR7IvmJT8jgHsJnnKA==
X-Received: by 2002:a17:902:2bab:: with SMTP id l40mr53553348plb.273.1553940718264;
        Sat, 30 Mar 2019 03:11:58 -0700 (PDT)
Received: from localhost ([128.199.137.77])
        by smtp.gmail.com with ESMTPSA id 71sm11603582pgc.23.2019.03.30.03.11.57
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 30 Mar 2019 03:11:57 -0700 (PDT)
Date:   Sat, 30 Mar 2019 18:11:52 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     Filipe David Manana <fdmanana@apache.org>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        fstests <fstests@vger.kernel.org>,
        xfs <linux-xfs@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH] generic: prohibit fstrim on journalled filesystems with
 norecovery
Message-ID: <20190330101152.GB2824@desktop>
References: <20190323003532.GB1180@magnolia>
 <CAL3q7H4Un5e5xOkTgAVXthfr-N1CXwf6e4qOyQ9WeXQoj3E8Uw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL3q7H4Un5e5xOkTgAVXthfr-N1CXwf6e4qOyQ9WeXQoj3E8Uw@mail.gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Mar 26, 2019 at 12:21:20PM +0000, Filipe David Manana wrote:
> On Sat, Mar 23, 2019 at 12:35 AM Darrick J. Wong
> <darrick.wong@oracle.com> wrote:
> >
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> >
> > This test makes sure that we can't use stale unrecovered fs metadata to
> > drive a DISCARD festival on a disk and thereby destroy user data by
> > accident.
> 
> It would help to have listed the name of the patches that fix the
> issues on xfs/ext4/btrfs, to make it faster.

Yeah, I'm about to do that :)

> 
> >
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Reviewed-by: Filipe Manana <fdmanana@suse.com>
> 
> Looks good, thanks for doing this. Just one question below.

Thanks for reviewing!

Eryu
