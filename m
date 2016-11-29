From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/3] ext4: Be more strict when verifying flags set via
 SETFLAGS ioctls
Date: Tue, 29 Nov 2016 11:21:32 -0500
Message-ID: <20161129162132.xv66ojffxn7gxllr@thunk.org>
References: <1475751874-32114-1-git-send-email-jack@suse.cz>
 <1475751874-32114-3-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56562 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751072AbcK2QVf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 29 Nov 2016 11:21:35 -0500
Content-Disposition: inline
In-Reply-To: <1475751874-32114-3-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 06, 2016 at 01:04:33PM +0200, Jan Kara wrote:
> Currently we just silently ignore flags that we don't understand (or
> that cannot be manipulated) through EXT4_IOC_SETFLAGS and
> EXT4_IOC_FSSETXATTR ioctls. This makes it problematic for the unused
> flags to be used in future (some app may be inadvertedly setting them
> and we won't notice until the flag gets used). Also this is inconsistent
> with other filesystems like XFS or BTRFS which return EOPNOTSUPP when
> they see a flag they cannot set.
> 
> ext4 has the additional problem that there are flags which are returned
> by EXT4_IOC_GETFLAGS ioctl but which cannot be modified via
> EXT4_IOC_SETFLAGS. So we have to be careful to ignore value of these
> flags and not fail the ioctl when they are set (as e.g. chattr(1) passes
> flags returned from EXT4_IOC_GETFLAGS to EXT4_IOC_SETFLAGS without any
> masking and thus we'd break this utility).
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
