From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: Tune2fs metadata_csum
Date: Mon, 17 Dec 2012 15:23:26 +0800
Message-ID: <20121217072326.GA7171@gmail.com>
References: <1355717041.99349.YahooMailNeo@web164606.mail.gq1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Anders Lind <anderslindgaard@yahoo.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57486 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab2LQHKI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Dec 2012 02:10:08 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so3771774pbc.19
        for <linux-ext4@vger.kernel.org>; Sun, 16 Dec 2012 23:10:08 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1355717041.99349.YahooMailNeo@web164606.mail.gq1.yahoo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Dec 16, 2012 at 08:04:01PM -0800, Anders Lind wrote:
> Hi ext4 developers,
> 
> 
> I tired to use tune2fs metadata_csum feature on my ext4 filesystem.
> I got message like:
> ~$ sudo tune2fs -O metadata_csum /dev/sda5
> tune2fs 1.42 (29-Nov-2011)
> Setting filesystem feature 'metadata_csum' not supported.

Hi Anders,

You need to upgrade your e2fsprogs because metadata_csum feature is
applied on Aug this year.

Regards,
                                                - Zheng
