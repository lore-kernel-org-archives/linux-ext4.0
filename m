From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] ext4: update mtime in ext4_punch_hole even if no blocks
 are released
Date: Sun, 13 May 2018 19:39:00 -0400
Message-ID: <20180513233900.GH14763@thunk.org>
References: <1524575271-27142-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, stable@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1524575271-27142-1-git-send-email-lczerner@redhat.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Apr 24, 2018 at 03:07:51PM +0200, Lukas Czerner wrote:
> Currently in ext4_punch_hole we're going to skip the mtime update if
> there are no actual blocks to release. However we've actually modified
> the file by zeroing the partial block so the mtime should be updated.
> 
> Moreover the sync and datasync handling is skipped as well, which is
> also wrong. Fix it.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> Reported-by: Joe Habermann <joe.habermann@quantum.com>
> Cc: <stable@vger.kernel.org>

Thanks, applied.

						- Ted
