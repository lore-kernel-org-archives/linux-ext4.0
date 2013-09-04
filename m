From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: Inline data?
Date: Wed, 4 Sep 2013 12:51:50 +0800
Message-ID: <20130904045150.GA23692@gmail.com>
References: <CAD=4a=XpMCzY7RcaBrstfoAkhkK3HsZBZ6ifS1zd-ZvFHWn31g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Ernst =?utf-8?Q?Sj=C3=B6strand?= <ernstp@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53156 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755930Ab3IDEuw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Sep 2013 00:50:52 -0400
Received: by mail-pb0-f46.google.com with SMTP id rq2so6893180pbb.5
        for <linux-ext4@vger.kernel.org>; Tue, 03 Sep 2013 21:50:52 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAD=4a=XpMCzY7RcaBrstfoAkhkK3HsZBZ6ifS1zd-ZvFHWn31g@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ernst,

On Tue, Sep 03, 2013 at 01:21:11PM +0200, Ernst Sj=C3=B6strand wrote:
> Hi! I'm curious about the inline data feature some of you guys have
> been working on for ext4 for a while now.
> I notice that there's still no release of e2fsprogs that support it,
> so I'm wondering if you have found issues with it or something is
> blocking it?

Sorry for my late.  The patch set for e2fsprogs is on e2fsprogs/pu
branch.  It isn't released because Ted gave me some suggestions about
the function signature of libext2fs.  So I refine this patch set.  The
latest version of patch set can be found in this link [1].

1. http://www.spinics.net/lists/linux-ext4/msg39336.html

Regards,
                                                - Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
