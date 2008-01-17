From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] Convert EXT2 to use unlocked_ioctl
Date: Thu, 17 Jan 2008 13:18:56 +0100
Message-ID: <200801171318.57491.arnd@arndb.de>
References: <1200565824-362-1-git-send-email-mathieu.segaud@regala.cx> <200801171254.04071.arnd@arndb.de> <87myr4ek82.fsf@barad-dur.regala.cx>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, sct@redhat.com
To: Mathieu SEGAUD <mathieu.segaud@regala.cx>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.179]:55224 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbYAQMTP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Jan 2008 07:19:15 -0500
In-Reply-To: <87myr4ek82.fsf@barad-dur.regala.cx>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thursday 17 January 2008, Mathieu SEGAUD wrote:
> yep, they do. I noticed this nested calls. I guess I will add
> _extX_compat_ioctl() running with no BKL's which would be used by both
> extX_ioctl() and extX_compat_ioctl().
> Any comments on such a strategy ? thanks a lot for the reminder :)
> 

Why not just kill the lock_kernel() in extX_compat_ioctl()?

	Arnd <><
