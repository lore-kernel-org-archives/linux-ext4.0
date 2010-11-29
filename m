From: Michael Rubin <mrubin@google.com>
Subject: Re: convert from ext3 versus fresh format
Date: Sun, 28 Nov 2010 21:52:10 -0800
Message-ID: <AANLkTikepNiZsO-8=M5f8JS8dNjyEY1jiSqey=shLVym@mail.gmail.com>
References: <1290978963.16103.1407558601@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org
To: linux_ext4@proinbox.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.35]:6393 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab0K2Fwe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Nov 2010 00:52:34 -0500
Received: from hpaq6.eem.corp.google.com (hpaq6.eem.corp.google.com [172.25.149.6])
	by smtp-out.google.com with ESMTP id oAT5qWCB023533
	for <linux-ext4@vger.kernel.org>; Sun, 28 Nov 2010 21:52:32 -0800
Received: from pvc22 (pvc22.prod.google.com [10.241.209.150])
	by hpaq6.eem.corp.google.com with ESMTP id oAT5qCnh011713
	for <linux-ext4@vger.kernel.org>; Sun, 28 Nov 2010 21:52:31 -0800
Received: by pvc22 with SMTP id 22so1025934pvc.41
        for <linux-ext4@vger.kernel.org>; Sun, 28 Nov 2010 21:52:30 -0800 (PST)
In-Reply-To: <1290978963.16103.1407558601@webmail.messagingengine.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 28, 2010 at 1:16 PM,  <linux_ext4@proinbox.com> wrote:
> I see the procedure on how to convert from ext3 to ext4 on the wiki, and
> before I proceed would like to know whether there's an advantage to
> formatting as ext4 from the start as opposed to converting after an ext3
> format.

We are seeing sizeable improvement on formatting ext4 vs converting
from ext2 on magnetic platters.

I would expect SSDs would also see an improvement due to extents for
ext4 on new files and having no indirect blocks to deal with from
ext3. While the cheaper seeks will make some of the improvements less
impactful, the fewer accesses should help a lot.

Also I don't think an upgrade allows for flex block groups while a
format will. This is something you might want to consider also
depending on how much you want to tune.

> In the case that there is a difference, what exactly is sacrificed in
> choosing one over the other?

AFAIK the only thing sacrificed in formatting vs upgrade is that you
have to preserve your data. If you don't have this concern I would
format cleanly.

mrubin
