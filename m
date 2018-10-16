Return-Path: <SRS0=eFe4=M4=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50820 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727162AbeJQDy1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 16 Oct 2018 23:54:27 -0400
Date: Tue, 16 Oct 2018 16:02:23 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: nicholas.clark@gmail.com
Cc: linux-ext4@vger.kernel.org
Subject: Re: [PATCH RESEND 2/2] Fuse2fs: add fakeroot option.
Message-ID: <20181016200223.GH24131@thunk.org>
References: <20181014150025.6477-1-nicholas.clark@gmail.com>
 <20181014150025.6477-3-nicholas.clark@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181014150025.6477-3-nicholas.clark@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Oct 14, 2018 at 09:00:25AM -0600, nicholas.clark@gmail.com wrote:
> From: Nicholas Clark <nicholas.clark@gmail.com>
> 
> Add a new 'fakeroot' option to fuse2fs. When enabled, fuse2fs will
> will pretend to be root when checking file permssions. This allows
> fuse2fs to be used for building/modifying rootfs images as an
> unprivileged user.
> 
> As per the maintainer's request, nosuid and nodev are automatically
> enabled when fakeroot is selected (on platforms that support them)
> to help prevent accidental misuse.
> 
> Signed-off-by: Nicholas Clark <nicholas.clark@gmail.com>

Applied, thanks!

					- Ted
