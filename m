From: Surbhi Palande <ameyasurbhi@gmail.com>
Subject: ext4: delayed allocation support and mmap
Date: Wed, 17 Aug 2011 14:02:09 +0300
Message-ID: <CABxQaWsda6PJGLBgdMTGidV_ZcdZrdajJZXgbkRXij3U3_SZAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43783 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802Ab1HQLCL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Aug 2011 07:02:11 -0400
Received: by wyg24 with SMTP id 24so579507wyg.19
        for <linux-ext4@vger.kernel.org>; Wed, 17 Aug 2011 04:02:10 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi All,

Current ext4_page_mkwrite() implementation always allocates a block
through  ext4_get_block_write() or ext4_get_block().

Commit: 9ea7df534ed2a18157434a496a12cf073ca00c52 removed the calls to
write_begin() to avoid calling ext4_da_write_begin() as calling it
from here is racy.

So for now, in ext4: delayed allocation is not supported under an mmap call?

Regards,
Surbhi.
