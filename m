From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/5] ext4: Prevent stack overrun in ext4_file_open when
 recording last known mountpoint
Date: Tue, 25 Oct 2011 09:22:56 -0400
Message-ID: <20111025132256.GK31921@thunk.org>
References: <20111021211759.10784.17257.stgit@elm3c44.beaverton.ibm.com>
 <20111021211818.10784.77127.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tao Ma <tm@tao.ma>, linux-ext4@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20111021211818.10784.77127.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Oct 21, 2011 at 02:18:18PM -0700, Darrick J. Wong wrote:
> In ext4_file_open, the filesystem records the mountpoint of the first file that
> is opened after mounting the filesystem.  It does this by allocating a 64-byte
> stack buffer, calling d_path() to grab the mount point through which this file
> was accessed, and then memcpy()ing 64 bytes into the superblock's
> s_last_mounted field, starting from the return value of d_path(), which is
> stored as "cp".  However, if cp > buf (which it frequently is since path
> components are prepended starting at the end of buf) then we can end up copying
> stack data into the superblock.
> 
> Writing stack variables into the superblock doesn't sound like a great idea, so
> use strlcpy instead.  Andi Kleen suggested using strlcpy instead of strncpy.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>

Thanks, applied.

						- Ted
