From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Support fast symlinks from ext3 file systems
Date: Sun, 3 Dec 2017 22:49:37 -0500
Message-ID: <20171204034937.taemzvmslauyfous@thunk.org>
References: <20171127173709.20787-1-andi@firstfloor.org>
 <24E86306-4A6C-48AE-9999-A9D935A2DC12@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <24E86306-4A6C-48AE-9999-A9D935A2DC12@dilger.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Nov 27, 2017 at 11:08:53AM -0700, Andreas Dilger wrote:
> On Nov 27, 2017, at 10:37 AM, Andi Kleen <andi@firstfloor.org> wrote:
> > 
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > dbb3c27f5b91c4 (ext4: change fast symlink test to not rely on i_blocks)
> > broke ~10 years old ext3 file systems created by 2.6.17. Any ELF
> > executable fails because the /lib/ld-linux.so.2 fast symlink
> > cannot be read anymore.
> > 
> > The patch assumed fast symlinks were created in a specific way,
> > but that's not true on these really old file systems.
> > 
> > The new behavior is apparently needed only with the large EA inode
> > feature.
> > 
> > Revert to the old behavior if the large EA inode feature is not set.
> > 
> > This makes my old VM boot again.
> > 
> > Fixes: dbb3c27f5b91c4 (ext4: change fast symlink test to not rely ...)
> > Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>

Thanks, applied.

					- Ted
