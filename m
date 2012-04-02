From: Daniel Drake <dsd@laptop.org>
Subject: Re: [PATCH 2/2] ext4: ignore last group without enough space when resizing
Date: Mon, 2 Apr 2012 09:04:10 -0600
Message-ID: <CAMLZHHQ2Y7w4VvakYBmKeqzhnNi99We3y26fFwy9x1tDPx3vvw@mail.gmail.com>
References: <1328065291-13607-1-git-send-email-xiaoqiangnk@gmail.com>
	<1328065291-13607-2-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:61817 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601Ab2DBPEL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Apr 2012 11:04:11 -0400
Received: by vbbff1 with SMTP id ff1so1743925vbb.19
        for <linux-ext4@vger.kernel.org>; Mon, 02 Apr 2012 08:04:10 -0700 (PDT)
In-Reply-To: <1328065291-13607-2-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

On Tue, Jan 31, 2012 at 9:01 PM, Yongqiang Yang <xiaoqiangnk@gmail.com> wrote:
> If last gtoup has no enough space for group tables, then we
> just ignore it.
>
> Reported-by: Daniel Drake <dsd@laptop.org>
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>

Thanks, this fixes the crash.

Am I right in thinking that the companion patch "[PATCH] resize2fs:
let online resizing report new blocks count right" is only needed for
cosmetic reasons; the resize operation will be successful even without
that patch applied to resize2fs?

Thanks,
Daniel
