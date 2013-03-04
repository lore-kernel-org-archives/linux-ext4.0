From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 1/5] ext4: ext4_split_extent shoult take care about
 extent zeroout v3
Date: Mon, 4 Mar 2013 14:37:33 +0800
Message-ID: <20130304063733.GA16458@gmail.com>
References: <1361808463-25471-1-git-send-email-dmonakhov@openvz.org>
 <20130304055813.GA18360@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org,
	jack@suse.cz, wenqing.lz@taobao.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f45.google.com ([209.85.210.45]:39233 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab3CDGW2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Mar 2013 01:22:28 -0500
Received: by mail-da0-f45.google.com with SMTP id v40so2379020dad.18
        for <linux-ext4@vger.kernel.org>; Sun, 03 Mar 2013 22:22:27 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20130304055813.GA18360@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 04, 2013 at 12:58:13AM -0500, Theodore Ts'o wrote:
> Dmitry,
> 
> Thanks for working on these patches.  They look good!  I've dropped
> them into the ext4 tree in the dev branch, and am starting to run
> tests on them.
> 
> Zheng, since some of your fix up patches look like they touch some of
> the code modified by Dmitry's patches, could you rebase your patch set
> on top of the dev branch (which is what we've pushed to Linus plus
> Dmitry's patches)?   Thanks!!

No problem, I will rebase my patches against the latest dev branch.

Thanks,
                                                - Zheng
