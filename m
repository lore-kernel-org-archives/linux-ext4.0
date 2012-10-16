From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 2/2] ext4: Remove code duplication in
 ext4_get_block_write_nolock()
Date: Tue, 16 Oct 2012 10:37:52 +0800
Message-ID: <20121016023752.GB5274@gmail.com>
References: <1350328009-22740-1-git-send-email-anatol.pomozov@gmail.com>
 <1350328009-22740-2-git-send-email-anatol.pomozov@gmail.com>
 <CAOMFOmUwydpp-J5HBjHSiVHDnOr+RC=SaXP9qeN+fBYj_S07ZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, wenqing.lz@taobao.com, linux-ext4@vger.kernel.org
To: Anatol Pomozov <anatol.pomozov@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:58493 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621Ab2JPC0u (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Oct 2012 22:26:50 -0400
Received: by mail-da0-f46.google.com with SMTP id n41so2905771dak.19
        for <linux-ext4@vger.kernel.org>; Mon, 15 Oct 2012 19:26:50 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAOMFOmUwydpp-J5HBjHSiVHDnOr+RC=SaXP9qeN+fBYj_S07ZA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 15, 2012 at 12:14:37PM -0700, Anatol Pomozov wrote:
[snip]
> Ideally if block layer (function __blockdev_direct_IO) accepted some
> user-data (e.g. flag) and later passed it back to callback function
> (i.e. ext4_get_block_write). In this case we do not need two functions
> ext4_get_block_write/ext4_get_block_write_nolock.

Thanks for teaching me. :-)

Regards,
Zheng
