Return-Path: <SRS0=OaGm=Q4=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=1.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C73B9C43381
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Feb 2019 18:38:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D5F62083E
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Feb 2019 18:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550774311;
	bh=cwKNgnyV0WFkfb/cVuzTXadTqJkPWRpy6cAs0Own1k8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=I4tWlML0gIkQssmuX5zwb21O8wwKDvDFT/VXksQga6YH7UTfjD5SlrstaN04wo5eP
	 J6hXCnNH7T9jYB18gHylUlHbF8jy3LMFmRwCl5h6eAZzxwK2W1zh0ojESrDjsol2Xl
	 kferIZN9PuTN1CfFMzif2VnoqlExlqvkFZZfK3hA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbfBUSib (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 21 Feb 2019 13:38:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:36980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726273AbfBUSia (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 21 Feb 2019 13:38:30 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DE962081B;
        Thu, 21 Feb 2019 18:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550774310;
        bh=cwKNgnyV0WFkfb/cVuzTXadTqJkPWRpy6cAs0Own1k8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2BZPBHd5ke5AbokO6JBYtEnfNFZoEnJS+e7+Hiuh19QQH29x+gxIeCEVYKuTcn6Z+
         4kQ6D1/g5O8qAZv/dZkhTy3Qgvl+vPbHOoFcBqsSJ51FZZPoegnbqPhNL3K4MprLbb
         u2jp5PoCtVlqDEMhcfbQcBRt4GFLpddYyyKng7P0=
Date:   Thu, 21 Feb 2019 10:38:28 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Chandan Rajendra <chandan@linux.ibm.com>
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org, tytso@mit.edu,
        adilger.kernel@dilger.ca, jaegeuk@kernel.org, yuchao0@huawei.com
Subject: Re: [RFC PATCH 00/10] Consolidate Post read processing code
Message-ID: <20190221183827.GA140206@gmail.com>
References: <20190218100433.20048-1-chandan@linux.ibm.com>
 <20190220004107.GI12177@gmail.com>
 <2420837.hecoV8S9Z6@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2420837.hecoV8S9Z6@localhost.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Feb 21, 2019 at 07:02:03PM +0530, Chandan Rajendra wrote:
> On Wednesday, February 20, 2019 6:11:07 AM IST Eric Biggers wrote:
> > On Mon, Feb 18, 2019 at 03:34:23PM +0530, Chandan Rajendra wrote:
> > > Based on the reviews provided for this patchset, I
> > > will change F2FS to use mpage_readpage[s] and post the next version of
> > > this patchset to linux-fsdevel mailing list.
> > 
> > Is that really possible?  F2FS has other functionality in its ->readpages(),
> > such as support for filesystems that use multiple block devices.
> > 
> 
> Hmm. I didn't know that. Thanks for pointing that out. I will read up that
> code and if it isn't really possible to get F2FS to use mpage_readpage[s](),
> then I would limit the patchset to Ext4.
> 

But we can make F2FS use the shared bio_post_read functions even if it can't use
mpage_readpage[s](), right?

- Eric
