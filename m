From: "George Spelvin" <linux@horizon.com>
Subject: Re: metadata_csum set but no space in dir leaf for checksum
Date: 14 Oct 2012 03:56:23 -0400
Message-ID: <20121014075623.19597.qmail@science.horizon.com>
References: <65D4536C-0F58-4A26-A562-B665EC6CBBB2@dilger.ca>
Cc: linux-ext4@vger.kernel.org
To: adilger@dilger.ca, linux@horizon.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:23616 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752107Ab2JNH4Y (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 14 Oct 2012 03:56:24 -0400
In-Reply-To: <65D4536C-0F58-4A26-A562-B665EC6CBBB2@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> The message itself should be quieted though, since there isn't anything to be
> helped by printing it continuously.  I guess there is something missing in
> e2fsck that it doesn't add a checksum to this block, however.

Also, it appears to force the needs_recover flag, making reboots somewhat
painful processes.  (Even though a plain fsck, which is what that triggers,
isn't even expected to fix it.)
