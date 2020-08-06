Return-Path: <SRS0=Jip5=BQ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03478C43464
	for <linux-ext4@archiver.kernel.org>; Thu,  6 Aug 2020 11:01:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA18E22CAE
	for <linux-ext4@archiver.kernel.org>; Thu,  6 Aug 2020 11:01:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727838AbgHFFm5 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 6 Aug 2020 01:42:57 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:48646 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726093AbgHFFm5 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Aug 2020 01:42:57 -0400
Received: from callcc.thunk.org (pool-96-230-252-158.bstnma.fios.verizon.net [96.230.252.158])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 0765gpUE030992
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 6 Aug 2020 01:42:52 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 41E16420263; Thu,  6 Aug 2020 01:42:51 -0400 (EDT)
Date:   Thu, 6 Aug 2020 01:42:51 -0400
From:   tytso@mit.edu
To:     Lukas Czerner <lczerner@redhat.com>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH v2] ext4: handle read only external journal device
Message-ID: <20200806054251.GL7657@mit.edu>
References: <20200716183901.5016-1-lczerner@redhat.com>
 <20200717090605.2612-1-lczerner@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200717090605.2612-1-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Jul 17, 2020 at 11:06:05AM +0200, Lukas Czerner wrote:
> Ext4 uses blkdev_get_by_dev() to get the block_device for journal device
> which does check to see if the read-only block device was opened
> read-only.
> 
> As a result ext4 will hapily proceed mounting the file system with
> external journal on read-only device. This is bad as we would not be
> able to use the journal leading to errors later on.
> 
> Instead of simply failing to mount file system in this case, treat it in
> a similar way we treat internal journal on read-only device. Allow to
> mount with -o noload in read-only mode.

Applied, thanks.

					- Ted
