From: d lopez <dlopezzz63@gmail.com>
Subject: Invalid filesystem option set: inline_data
Date: Sun, 24 Nov 2013 18:19:06 +0100
Message-ID: <CAM16AnBtv5UE0LN_hzsUjWRV33Pd_TuXkgLxmQRAFjS86MY9-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ob0-f194.google.com ([209.85.214.194]:63575 "EHLO
	mail-ob0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069Ab3KXRTH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 24 Nov 2013 12:19:07 -0500
Received: by mail-ob0-f194.google.com with SMTP id wo20so785167obc.1
        for <linux-ext4@vger.kernel.org>; Sun, 24 Nov 2013 09:19:06 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

I'm trying to use inline_data with kernel 3.11.9, but it doesn't seem to
work.

# mkfs.ext4 -O inline_data -m 0 -v  /dev/sdb12
mke2fs 1.42.8 (20-Jun-2013)
Invalid filesystem option set: inline_data
