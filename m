Return-Path: <SRS0=ZSF4=YJ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66EC2FA3728
	for <linux-ext4@archiver.kernel.org>; Wed, 16 Oct 2019 21:17:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4199F218DE
	for <linux-ext4@archiver.kernel.org>; Wed, 16 Oct 2019 21:17:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eyH4aa16"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388409AbfJPVRv (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 16 Oct 2019 17:17:51 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36812 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388118AbfJPVRv (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Oct 2019 17:17:51 -0400
Received: by mail-pf1-f194.google.com with SMTP id y22so187382pfr.3
        for <linux-ext4@vger.kernel.org>; Wed, 16 Oct 2019 14:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=JAxq/WJeBoR0xMDaZ8ZbppkOlnjn80tjwBYmWKfmplU=;
        b=eyH4aa164I+OzfTDTsPKbu6607+lcySeMot2a7BPxRlhclDaFhCxtIH+ysArH/nmBI
         uliHilHLE6Ngf5x6Ql7n16TztzJXBjGU8+DTbLx2n7QVMBLMF75GGpxJzwUROTm5cJQJ
         MF4wMf6s7FyWMTLiXLU8quTydRd057AM6TJGevyDRgZ8Tq2R46Rb7xCjMG6EWo/qqbfw
         cBxGQIOZ0EakMOp3NIxvOVNj1eblV/wKukqxUe+WqJ+W8Gk8EzMcT3PWsv+XwOm4s26g
         eBevADqdbHyeG2kkYb9dOohYzBAqUkQQpiRKzdKILAJtK60hySl3K9+/JJzq1KAmR+rx
         5VWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=JAxq/WJeBoR0xMDaZ8ZbppkOlnjn80tjwBYmWKfmplU=;
        b=BIk/8K5pb3Xz8qibJ50alzIwrOvcWRKZTrruILxG/vB00VdwFTStBJ8nPOCfxXR26d
         6fAxsrDoqCpAgb8mrRtF+5njCg6TvV9wgfqCNhpxU2LS8MqXuVMffhTs4b+4NpBklsBa
         qUrr9y1g0lX++T9kDx0A9Y+pXpfVyziuNTXJDlDVnoJqoDtbbQduhFMf66M2fvclN+Ue
         uT1mIgfBDtLRyVUpGC5/oFbkIMcobUnYJBpwcozg+2gaxfsFG9m9hOb+UCJy3XTNh+YK
         sF/JCyHvkx3GDUt39lFlJXHw2XBviiZEerV6p3+Y1a6bXNiw2g6/kTenaghSnN/BlMQi
         tsDw==
X-Gm-Message-State: APjAAAVIwFnyz+usoIuPwR3zCv37N8oU01mAy4DE9g2tntNO1v9mTkP6
        /NanU9OJsTPFqrIcmIKaFA/mhQ==
X-Google-Smtp-Source: APXvYqzjQ0XjfMLbp0P6ILxrlTpTewhwtgwmFGdCI0OwVSn3VdoBPex3Ou/TnDGchf9/QYvccrPE4Q==
X-Received: by 2002:aa7:838f:: with SMTP id u15mr28420131pfm.74.1571260670353;
        Wed, 16 Oct 2019 14:17:50 -0700 (PDT)
Received: from google.com ([2620:15c:2cb:1:e90c:8e54:c2b4:29e7])
        by smtp.gmail.com with ESMTPSA id g4sm10074pfo.33.2019.10.16.14.17.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 14:17:49 -0700 (PDT)
Date:   Wed, 16 Oct 2019 14:17:45 -0700
From:   Brendan Higgins <brendanhiggins@google.com>
To:     Iurii Zaikin <yzaikin@google.com>
Cc:     linux-kselftest@vger.kernel.org, linux-ext4@vger.kernel.org,
        skhan@linuxfoundation.org, tytso@mit.edu, adilger.kernel@dilger.ca,
        Tim.Bird@sony.com, kunit-dev@googlegroups.com
Subject: Re: [PATCH linux-kselftest/test v5] ext4: add kunit test for
 decoding extended timestamps
Message-ID: <20191016211745.GA66058@google.com>
References: <20191016205820.164985-1-yzaikin@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191016205820.164985-1-yzaikin@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Oct 16, 2019 at 01:58:20PM -0700, Iurii Zaikin wrote:
> KUnit tests for decoding extended 64 bit timestamps
> that verify the seconds part of [a/c/m]
> timestamps in ext4 inode structs are decoded correctly.
> KUnit tests, which run on boot and output
> the results to the debug log in TAP format (http://testanything.org/).
> are only useful for kernel devs running KUnit test harness. Not for
> inclusion into a production build.
> Test data is derived from the table under
> Documentation/filesystems/ext4/inodes.rst Inode Timestamps.
> 
> Signed-off-by: Iurii Zaikin <yzaikin@google.com>

You got Reviewed-bys from both Ted and myself. Unless you make
*substantial* changes you should generally include all Reviewed-bys,
Tested-bys, Acked-bys, etc in all future revisions.

Cheers!
