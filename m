Return-Path: <SRS0=8KOi=QA=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CB52C282C5
	for <linux-ext4@archiver.kernel.org>; Thu, 24 Jan 2019 18:29:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F44A218AF
	for <linux-ext4@archiver.kernel.org>; Thu, 24 Jan 2019 18:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548354598;
	bh=hJlBvN3i2uQe8YhwH5/V6jmn5DZW9rPhNLZF03OBSzo=;
	h=Date:From:To:Subject:References:In-Reply-To:List-ID:From;
	b=HFruUjcgxM/4ei4n9D1L3heK0+eIqP2Z/lI4UQ0YQM1H+49t6wm1Vm6uAUQp0netl
	 3N24gh8yPHUpWxjVz3f6kBjB+CCUISsqYLZdxiMUiizParw0MorNkkN724X73aKg/E
	 i61UIkWdom/ndPINuiWkEV/TFIRTwnuShbI9523A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727461AbfAXS3x (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 24 Jan 2019 13:29:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:51218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725924AbfAXS3x (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 24 Jan 2019 13:29:53 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 348EF218A6;
        Thu, 24 Jan 2019 18:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548354592;
        bh=hJlBvN3i2uQe8YhwH5/V6jmn5DZW9rPhNLZF03OBSzo=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=s5awLXnd3dix7ezk5i/5Owm35BiojZopLwG9ahm8wtq1gbBSDaFAck+B1IwPVJ3F2
         bicsbaIyUj/Dk74OM+cDQANpYvVSVsunL3fzZ7J3/kJDLLbn0/mCPN9jqhH0qYPFT3
         38CjH4M9/xQIKK788laA8UiSf3B2dk+VLIZddKeo=
Date:   Thu, 24 Jan 2019 10:29:50 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Guenter Roeck <linux@roeck-us.net>,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [f2fs-dev] [PATCH] fscrypt: remove filesystem specific build
 config option
Message-ID: <20190124182949.GB10448@gmail.com>
References: <20190110233230.GA23953@roeck-us.net>
 <20190111010116.GG149637@gmail.com>
 <20190124050337.GD8785@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190124050337.GD8785@mit.edu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Jan 24, 2019 at 12:03:37AM -0500, Theodore Y. Ts'o wrote:
> On Thu, Jan 10, 2019 at 05:01:17PM -0800, Eric Biggers wrote:
> > 
> > Indeed, Chandan Rajendra sent out a new version of the patch which fixes the
> > problem (by removing the 'select BLOCK' from fs/ubifs/Kconfig), but it never
> > made it into the fscrypt tree and hence never made it into linux-next.
> > 
> > Ted, what you are planning to do with the fscrypt tree following the fsverity
> > discussion?  IMO, we should keep the fsverity stuff in its own branch, separate
> > from any fscrypt changes.  As a suggestion, in the branch "fscrypt" of my
> > linux.git repo [1], I applied just these four patches on top of v5.0-rc1 and
> > resolved the conflicts with them no longer being on top of fsverity...
> 
> Sorry, I was on vacation last week and I've been catching up on things
> this week.  I've reset the master branch on my fscrypt.git tree so
> that it has what you have on your fscrypt branch, rebased to 5.0-rc3.
> 
> Also, as we had talked about earlier, it probably makes sense to set
> up jointly maintained git tree for fscrypt and fsverity.  My proposal
> is that we set up a new fscrypt.git tree, at
> /pub/scm/fs/fscrypt/fscrypt.git, that would be owned by the "FSCRYPT
> group", with group membership being ebiggers, jaeguk, and tytso.
> We'll have to figure out ways that we can jointly update the git tree
> without stepping on each other, probably using a group chat.  Does
> that sound good to you?
> 

Hi Ted, that sounds good to me.  I assume you know how to get that set up?
Also, should I go ahead and send a patch that adds myself to the MAINTAINERS
file?

- Eric
