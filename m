From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: ioctl: fix erroneous return value
Date: Fri, 12 Feb 2016 00:02:14 -0500
Message-ID: <20160212050214.GD11298@thunk.org>
References: <1455206338-2869-1-git-send-email-a.s.protopopov@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Anton Protopopov <a.s.protopopov@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1455206338-2869-1-git-send-email-a.s.protopopov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Feb 11, 2016 at 10:58:58AM -0500, Anton Protopopov wrote:
> The ext4_ioctl_setflags() function which is used in the ioctls
> EXT4_IOC_SETFLAGS and EXT4_IOC_FSSETXATTR may return the positive value
> EPERM instead of -EPERM in case of error. This bug was introduced by a
> recent commit 9b7365fc.

Nice catch!  Thanks, applied.

					- Ted
