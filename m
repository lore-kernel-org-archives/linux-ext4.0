From: Teng-Feng Yang <shinrairis@gmail.com>
Subject: EXT4 data block allocation alignment
Date: Wed, 11 Jun 2014 19:44:49 +0800
Message-ID: <CAKTMprNG5GzBQ1wmPhvCWzr3OKcsj8HCQ4f-mez_bSvw5D9f4A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:64772 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbaFKLpK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Jun 2014 07:45:10 -0400
Received: by mail-ig0-f180.google.com with SMTP id h18so638186igc.1
        for <linux-ext4@vger.kernel.org>; Wed, 11 Jun 2014 04:45:09 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi, folks,

Recently I have been working on a small project which requires data
blocks of each file to be aligned to 512KB/1MB boundary for
performance reason. As far as I know, this can be accomplished by
setting the stripe unit on XFS or enabling the "bigalloc" feature on
EXT4. However, the "bigalloc" feature has not yet been stated to be
stable in the latest release. So, this makes me wondering if I can
achieve this block allocation alignment by setting the stride-size on
EXT4. The document of mke2fs only says that this value may be used by
the block allocator, so I am not quite sure what it can offer for me
in this case.

Any help would be appreciated.
Thanks,

Dennis
