Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15A99C46467
	for <linux-ext4@archiver.kernel.org>; Tue, 10 Jan 2023 15:48:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231479AbjAJPsq (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 10 Jan 2023 10:48:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234331AbjAJPsn (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Jan 2023 10:48:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6E1B44C51;
        Tue, 10 Jan 2023 07:48:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5FFD96179A;
        Tue, 10 Jan 2023 15:48:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 520A0C433D2;
        Tue, 10 Jan 2023 15:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673365721;
        bh=SzybKE2ZlLj8N7A2p4KL6+AnhlUYuvQ+HeRllUMW3JQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WlTSXLYf6qCVE2hsVw7zPfW8JjJyhblhwnrkE4XFcPlSw4wfmCqXi4Wwm2dg9I5Ya
         fNY94Nthouy9DLT3VQmIdePxpbZcB2dyw/GbRAcuBQJZPIDD3yohBbDMYwmcX0tCIp
         PBnRdR2Guq15moUM+TMBoVU3/klhTnAKnjHsSVjQ=
Date:   Tue, 10 Jan 2023 16:48:35 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     stable@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: Please apply "ext4: don't allow journal inode to have encrypt
 flag" to 5.15 and earlier
Message-ID: <Y72I0/KixO+WoKsc@kroah.com>
References: <Y7nWexWBpMWKwdeB@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7nWexWBpMWKwdeB@sol.localdomain>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sat, Jan 07, 2023 at 12:30:51PM -0800, Eric Biggers wrote:
> Please apply commit 105c78e12468 ("ext4: don't allow journal inode to have
> encrypt flag") to the 5.15, 5.10, 5.4, and 4.19 LTS kernels, where it applies
> cleanly.
> 
> It didn't get applied automatically because for the Fixes tag, I used a commit
> in 5.18.  However, that was the commit that exposed the problem, not the root
> cause.  IMO it makes sense to apply this to earlier kernels too, especially
> because some people have backported the 5.18 commit.

All now queued up, thanks.

greg k-h
