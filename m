From: tytso@mit.edu
Subject: Re: [PATCH] ext4: Fix check of dqget() return value in
 ext4_ioctl_setproject()
Date: Thu, 5 May 2016 14:53:17 +0000
Message-ID: <20160505145317.GA17625@thunk.org>
References: <1459256463-48543-1-git-send-email-seth.forshee@canonical.com>
 <20160422183632.GC109717@ubuntu-hedt>
 <20160505125234.GF1970@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Seth Forshee <seth.forshee@canonical.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160505125234.GF1970@quack2.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, May 05, 2016 at 02:52:34PM +0200, Jan Kara wrote:
> On Fri 22-04-16 13:36:32, Seth Forshee wrote:
> > On Tue, Mar 29, 2016 at 08:01:03AM -0500, Seth Forshee wrote:
> > > A failed call to dqget() returns an ERR_PTR() and not null. Fix
> > > the check in ext4_ioctl_setproject() to handle this correctly.
> > > 
> > > Fixes: 9b7365fc1c82 ("ext4: add FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR interface support")
> > > Cc: stable@vger.kernel.org # v4.5
> > > Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> > 
> > Thought I'd check and see if this patch was forgotten, I sent it nearly
> > a month ago but the bug is still present.
> 
> Yeah, it seems Ted forgot to pull the fix. Ted? BTW, feel free to add
> 
> Reviewed-by: Jan Kara <jack@suse.cz>

Applied, thanks.

						- Ted
