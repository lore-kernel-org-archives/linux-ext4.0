From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] fs/compat_ioctl.c: add missing FS_IOC_FIEMAP support
Date: Mon, 3 Aug 2009 20:00:11 +0200
Message-ID: <200908032000.12260.arnd@arndb.de>
References: <4A74584D.2010300@rtr.ca> <4A7722DF.80704@rtr.ca>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>,
	Andrew Morton <akpm@linux-foundation.org>
To: Mark Lord <lkml@rtr.ca>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753395AbZHCSBE@vger.kernel.org>
In-Reply-To: <4A7722DF.80704@rtr.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Monday 03 August 2009, Mark Lord wrote:
> (resending, no ack from anyone first time around).

I actually wrote a lengthy reply on how I think the code around it
should be done differently and then realized why we had done it
that way originally and did not send out my reply.

Your addition looks ok, the data structures are compatible
on all architectures.

> Add support for the FIEMAP ioctl for 32-bit user on 64-bit kernel.
> 
> When using a 32-bit runtime on top of a 64-bit kernel,
> programs like "filefrag" and "hdparm --fibmap" do not work correctly.
> 
> This is because there's no compat ioctl entry for the FIEMAP call.
> FIEMAP returns file extent info, similar to FIBMAP (but better).
> 
> Since FIBMAP itself is b0rked on ext4, this leaves no way for a 32-bit
> program to reliably get detailed block information for a file
> when run on top of a 64-bit kernel.  This patch addresses the issue.
> 
> Once upstream, this patch could also be a candidate for -stable.
> 
> Signed-off-by: Mark Lord <mlord@pobox.com>

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
