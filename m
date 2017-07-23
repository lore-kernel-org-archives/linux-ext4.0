From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [V2] tune2fs: edit dire warning about check intervals
Date: Sun, 23 Jul 2017 18:36:02 -0400
Message-ID: <20170723223602.hkkucdjgptiojpca@thunk.org>
References: <3d574f21-a93c-e1ae-2b92-d4b1d1156fb4@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52292 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750735AbdGWWgE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 23 Jul 2017 18:36:04 -0400
Content-Disposition: inline
In-Reply-To: <3d574f21-a93c-e1ae-2b92-d4b1d1156fb4@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 19, 2017 at 12:26:19PM -0500, Eric Sandeen wrote:
> Time & mount-count based checks have been off by default for quite some
> time now, but the dire warning about disabling them remains in the
> tune2fs manpage, which is confusing.  We did "strongly consider
> the consequences" and disabled it by default, no need to scare the
> user about it now.  Inform the user of the consequences in a more
> measured tone.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>

Thanks, applied.

					- Ted
