From: "H. Peter Anvin" <hpa@zytor.com>
Subject: e4defrag and immutable files
Date: Fri, 28 May 2010 13:14:31 -0700
Message-ID: <4C002427.3010706@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:59128 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758423Ab0E1UOc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 28 May 2010 16:14:32 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

I have looked a bit at e4defrag, and it does not appear to prevent the
relocation of files marked immutable.  This is a problem for boot
loaders, which may need to have a block pointer to a specific file in
order to bootstrap themselves.

Would it be possible to either:

a) prevent e4defrag and/or EXT4_IOC_MOVE_EXT from relocating an
immutable file, or
b) add a new attribute with the above property (in case there is
legitimate need to move around immutable files)?

	-hpa
