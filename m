From: Sedat Dilek <sedat.dilek@googlemail.com>
Subject: Re: [Patch] ext4: avoid null dereference
Date: Thu, 2 Sep 2010 13:12:39 +0200
Message-ID: <AANLkTimUVTMtqFcj5d98HGTBD_xgmGbad1rnVRY6Vxdu@mail.gmail.com>
Reply-To: sedat.dilek@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "Theodore Ts'o" <tytso@mit.edu>, wency@cn.fujitsu.com,
	rostedt@goodmis.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:51860 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888Ab0IBLMl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Sep 2010 07:12:41 -0400
Received: by qyk33 with SMTP id 33so452359qyk.19
        for <linux-ext4@vger.kernel.org>; Thu, 02 Sep 2010 04:12:40 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

> Thanks for the patch, I've added it to the ext4 patch queue, with the
> patch summary changed to "avoid null dereference in trace_ext4_mballoc_discard"

I don't see this patch in [1] or [2], forgot to push?

- Sedat -


[1] http://repo.or.cz/w/ext4-patch-queue.git
[2] http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git
