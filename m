Return-Path: <SRS0=eFe4=M4=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50744 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727223AbeJQDaK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 16 Oct 2018 23:30:10 -0400
Date: Tue, 16 Oct 2018 15:38:10 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: nicholas.clark@gmail.com
Cc: linux-ext4@vger.kernel.org
Subject: Re: [PATCH RESEND 1/2] Fuse2fs: fix 'mount' entry in some cases.
Message-ID: <20181016193810.GG24131@thunk.org>
References: <20181014150025.6477-1-nicholas.clark@gmail.com>
 <20181014150025.6477-2-nicholas.clark@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181014150025.6477-2-nicholas.clark@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Oct 14, 2018 at 09:00:24AM -0600, nicholas.clark@gmail.com wrote:
> From: Nicholas Clark <nicholas.clark@gmail.com>
> 
> FUSE's parser allows command-line options to be specified before
> or after the device/image and mount-path. This commit changes the
> value of the fsname mount option to be correct even if options are
> specified before the target device/image.
> 
> Signed-off-by: Nicholas Clark <nicholas.clark@gmail.com>

Applied (to the maint branch), thanks.  

					- Ted
