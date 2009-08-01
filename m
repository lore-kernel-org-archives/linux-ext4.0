From: Mark Lord <lkml@rtr.ca>
Subject: Re: [PATCH] fs/compat_ioctl.c: add missing FS_IOC_FIEMAP support
Date: Sat, 01 Aug 2009 11:17:13 -0400
Message-ID: <4A745C79.8030503@rtr.ca>
References: <4A74584D.2010300@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rtr.ca ([76.10.145.34]:38039 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751653AbZHAPRN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 1 Aug 2009 11:17:13 -0400
In-Reply-To: <4A74584D.2010300@rtr.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Mark Lord wrote:
..
> Since FIBMAP itself is b0rked on ext4, this leaves no way for a 32-bit
..

To stave off the inevitable question, FIBMAP doesn't appear to cope well
with allocated/uncommitted blocks.  Creating a file with fallocate(),
and then immediately running FIBMAP, will not give any allocation data.

Doing a sync() after the fallocate() allows FIBMAP to work again.

FIEMAP doesn't require the sync().

Cheers
