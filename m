From: Jitesh Shah <jitesh.1337@gmail.com>
Subject: Re: Reproducible block structure
Date: Tue, 10 Dec 2013 10:08:04 -0800
Message-ID: <CAO_9QQf1MOGVsMB_50HF_bSAKid04JkDCCVX=Wauihg-s6AuJw@mail.gmail.com>
References: <CAO_9QQcOSgUA84ewb=PANikU+MzeTmmeHnPeLd2SHQ_46sUi8Q@mail.gmail.com>
	<20131210134255.GA31214@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ob0-f179.google.com ([209.85.214.179]:60364 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754683Ab3LJSIG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Dec 2013 13:08:06 -0500
Received: by mail-ob0-f179.google.com with SMTP id wm4so5699880obc.38
        for <linux-ext4@vger.kernel.org>; Tue, 10 Dec 2013 10:08:04 -0800 (PST)
In-Reply-To: <20131210134255.GA31214@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

.. inline ..

> > Now, if the script is ran in the SAME way for all 5 HDDs, is it
> > guaranteed that these HDDs will be same at the block level too? (i.e.
> > block allocation/deallocation will follow the same pattern). Assume
> > single-core system with only one process modifying the HDD in
> > predetermined order.
>
> Nope, there's no way to guarantee this.

Thanks. I was quite sure of this, but still thought it was a good idea
to ask in case I am missing an obscure detail.

> > Why do I ask -> I am tinkering with the idea of block level
> > verification of images. If the above guarantees can be provided, I can
> > easily hash the raw HDD for verification purposes.
>
> If you want to do a block level verification of the image, why not
> also do block level update of the image as well?

Yep. Thats the plan B. We had a bunch of utilities using file-based
approaches. I was trying to find a way to move them one-by-one. Looks
like moving to a block-based approach altogether is a more worthwhile
investment of time.

Thanks a lot for your responses Carlos and Ted.

Jitesh
