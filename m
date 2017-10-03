From: Zheng Lv <lv.zheng.2015@gmail.com>
Subject: Re: [PATCH] ext4: Use symbolic constants for well-known pow 2 sizes
Date: Tue, 3 Oct 2017 15:00:00 +0800
Message-ID: <20171003070000.GA5162@lvzheng-thinkpad>
References: <1506693530-11800-1-git-send-email-nborisov@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: nborisov@suse.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:35543 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750812AbdJCHAJ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Oct 2017 03:00:09 -0400
Received: by mail-pg0-f67.google.com with SMTP id p5so6285715pgn.2
        for <linux-ext4@vger.kernel.org>; Tue, 03 Oct 2017 00:00:09 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1506693530-11800-1-git-send-email-nborisov@suse.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> No functional changes, just makes the code a bit more readable. Also fix 1
> trailing whitespace

I don't think so.

AFAIK, SZ_16 is just 16, not (16 * 1024). XXX * 1024 should be replaced with
SZ_XXXk rather than SZ_XXX.

Cheers
Zheng Lv
