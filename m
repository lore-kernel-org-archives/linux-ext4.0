From: Johannes Stuettgen <johannes.stuettgen@gmail.com>
Subject: Backport Ext4 Crypto Patches from 4.4 to 4.1
Date: Fri, 5 Feb 2016 13:05:10 +0100
Message-ID: <CADGQwwN6aw4H7WaTbKs17j9z_G3GzXZ+UF0NBKp8id-xWfXbxg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:35192 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbcBEMFM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Feb 2016 07:05:12 -0500
Received: by mail-wm0-f46.google.com with SMTP id r129so23699093wmr.0
        for <linux-ext4@vger.kernel.org>; Fri, 05 Feb 2016 04:05:11 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

I recently stumbled over the "ext4 changes for 4.4" pull request [1]
on lkml and gladly appreciate the work being done there. Especially
the fixes for ext4 crypto are interesting to me, as I'm planning to
use it for an upcoming product. Unfortunately, that product is fixed
to using kernel 4.1, and there is not much I can do about that. Are
there plans to backport the fixes for ext4 crypto from 4.4 to 4.1?
Since they fix some quite severe problems, they are basically a must
for users of ext4 crypto (to quote Theodore Ts'o: "Anyone wishing to
use the encryption feature should backport all of the ext4 crypto
patches up to 4.4 to get fixes to a memory leak and file system
corruption bug.").

Thanks in advance and best regards,

Johannes

[1] https://lkml.org/lkml/2015/11/6/417
