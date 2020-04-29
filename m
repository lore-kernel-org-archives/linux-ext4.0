Return-Path: <SRS0=7uWi=6N=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14E98C83004
	for <linux-ext4@archiver.kernel.org>; Wed, 29 Apr 2020 12:59:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1B692074A
	for <linux-ext4@archiver.kernel.org>; Wed, 29 Apr 2020 12:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588165156;
	bh=OKP5q1kfJMOz1V+mDLpdq/wbCs1bmXk3Ojz8StqzR2U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=tUngE8xnoZaftYkKaY/naArZdvaQr0j+Aelbn9olv8GG+FYO8GbRwjvlErkQsQbBH
	 J2JHvw+rNVP+f0KvKdJaPl8k2Tr5+EnfI3gupBW4Ke296V+VnlzHg6wVxqVTd/0Mef
	 c1IxOr9wgBR+GgTwauVVc3VZxWHh7vID4mzSlIdY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbgD2M7N (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 29 Apr 2020 08:59:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:33328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726776AbgD2M7L (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 29 Apr 2020 08:59:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8E62214D8;
        Wed, 29 Apr 2020 12:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588165151;
        bh=OKP5q1kfJMOz1V+mDLpdq/wbCs1bmXk3Ojz8StqzR2U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AmfIypLl0/vQsEejNzGbUfn67N+qyG7qPxvX6J+KzLILZHuIgCNRCZJbX3YtMUap9
         +WjLBx/JlHwjMpLCN5YLvfvo0jISKvGFwq+hfhsq9fAmXqVc+/8OUimTYNNKh7aX6G
         j6T/r6v9658saDBnrdWCBZ5HIsrzp2S2Ady2OEDY=
Date:   Wed, 29 Apr 2020 14:59:09 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     ashwin-h <ashwinh@vmware.com>
Cc:     tytso@mit.edu, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@kernel.org, srivatsab@vmware.com, srivatsa@csail.mit.edu,
        rostedt@goodmis.org, srostedt@vmware.com,
        ashwin.hiranniah@gmail.com
Subject: Re: [PATCH 0/5] Backport to 4.9- ext4: protect journal inode's
 blocks using block_validity
Message-ID: <20200429125909.GA2124190@kroah.com>
References: <cover.1587713792.git.ashwinh@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1587713792.git.ashwinh@vmware.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Apr 30, 2020 at 12:51:34AM +0530, ashwin-h wrote:
> [PATCH 1/5] ext4: avoid declaring fs inconsistent due to invalid file
> handles
> This patch is backported as functionality in this commit is used by
> Patch 2 in this patchset.
> 
> [PATCH 2/5] ext4: protect journal inode's blocks using block_validity
> Backport to 4.9
> 
> [PATCH 3/5] ext4: don't perform block validity checks on the journal
> [PATCH 4/5] ext4: fix block validity checks for journal inodes using
> [PATCH 5/5] ext4: unsigned int compared against zero
> Fixes issues found in Patch 2 in this patchset.
> 
> These patches addresses CVE-2019-19319

I can't take patches for 4.9 that are not also in 4.14, for the obvious
reason that you never want to upgrade to a newer kernel and get
regressions.

So can you provide a backported series for the 4.14 tree too?  Then I
can take these.

thanks,

greg k-h
