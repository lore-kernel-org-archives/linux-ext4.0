From: Seth Forshee <seth.forshee@canonical.com>
Subject: Re: [PATCH] ext4: Fix check of dqget() return value in
 ext4_ioctl_setproject()
Date: Fri, 22 Apr 2016 13:36:32 -0500
Message-ID: <20160422183632.GC109717@ubuntu-hedt>
References: <1459256463-48543-1-git-send-email-seth.forshee@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1459256463-48543-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Mar 29, 2016 at 08:01:03AM -0500, Seth Forshee wrote:
> A failed call to dqget() returns an ERR_PTR() and not null. Fix
> the check in ext4_ioctl_setproject() to handle this correctly.
> 
> Fixes: 9b7365fc1c82 ("ext4: add FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR interface support")
> Cc: stable@vger.kernel.org # v4.5
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>

Thought I'd check and see if this patch was forgotten, I sent it nearly
a month ago but the bug is still present.

Thanks,
Seth
