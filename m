From: Li Xi <pkuelelixi@gmail.com>
Subject: Re: [v4 6/6] Add project ID support for chattr/lsattr
Date: Sun, 6 Mar 2016 18:49:09 +0800
Message-ID: <CAPTn0cCQ0wWAbomy9cipDZT1rKU7JFCra_SKEQfwL4oXgJDsKA@mail.gmail.com>
References: <1457237696-13770-1-git-send-email-lixi@ddn.com>
	<1457237696-13770-7-git-send-email-lixi@ddn.com>
	<20160306055645.GL10297@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vk0-f47.google.com ([209.85.213.47]:36725 "EHLO
	mail-vk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbcCFKtL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 6 Mar 2016 05:49:11 -0500
Received: by mail-vk0-f47.google.com with SMTP id c3so92365365vkb.3
        for <linux-ext4@vger.kernel.org>; Sun, 06 Mar 2016 02:49:10 -0800 (PST)
In-Reply-To: <20160306055645.GL10297@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Sure. No problem. I will run tests with your patches as soon as they are out.

On Sun, Mar 6, 2016 at 1:56 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> I'll take a closer look at the changes in your v4 patchset over v3,
> but the f[sg]etproject.c files I put together are better in that they
> are more portable for non-Linux architectures, so I think I'm going to
> keep my version.
>
> I'll push out an updated e2fsprogs git tree on Monday, and at that
> point if you have any questions about the integration work I did, or
> you have any other bugs, let's handle them as patches against the
> updated next branch.
>
> Cheers,
>
>                                                 - Ted
