From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] Convert EXT2 to use unlocked_ioctl
Date: Thu, 17 Jan 2008 12:54:03 +0100
Message-ID: <200801171254.04071.arnd@arndb.de>
References: <1200565824-362-1-git-send-email-mathieu.segaud@regala.cx>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, sct@redhat.com
To: Mathieu Segaud <mathieu.segaud@regala.cx>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:58943 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbYAQLyS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Jan 2008 06:54:18 -0500
In-Reply-To: <1200565824-362-1-git-send-email-mathieu.segaud@regala.cx>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thursday 17 January 2008, you wrote:
> 
> Change ext_ioctl() to be an unlocked_ioctl(), explicitly
> exposing BKL's uses.
> 
> Signed-off-by: Mathieu Segaud <mathieu.segaud@regala.cx>

You are now calling lock_kernel() twice in case of ext2_compat_ioctl(),
which calls back into ext2_ioctl with the BKL already held.

This is allowed with the BKL, but really bad style that you should
avoid. I assume the ext3 and ext4dev versions of your patch have
the same issue, but I didn't check in detail.

	Arnd <><
