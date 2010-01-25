From: tytso@mit.edu
Subject: Motion to nuke FS_DIRECTIO_FL
Date: Mon, 25 Jan 2010 03:06:10 -0500
Message-ID: <20100125080610.GD4372@thunk.org>
References: <20090906092546.GU4197@webber.adilger.int>
 <20100124194839.GB4372@thunk.org>
 <E1520682-CD9F-445E-AF33-D5FCDABA1FF8@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Steven Whitehouse <swhiteho@redhat.com>,
	linux-fsdevel@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <E1520682-CD9F-445E-AF33-D5FCDABA1FF8@sun.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Jan 24, 2010 at 11:18:47PM -0700, Andreas Dilger wrote:
> 
> It doesn't seem that ext2/3/4 are using the 0x00100000 value itself,
> but it seems the VFS is using this value for FS_DIRECTIO_FL.  Should
> we reserve this in the ext4 flags also, to avoid collisions?  I'm
> not sure what that flag is for, possibly to force all IO to the file
> to be uncached?

Hmm, absolutely nothing seems to use FS_DIRECTIO_FL; it looks like it
was introduced by GFS2 in commit 128e5eba in 2006 and then dropped in
commit c9f6a6bb in 2008, but we never killed the FS_DIRECTIO_FL flag
itself in include/linux/fs.h.

The summary line for c9f6a6bb is a bit amusing:

    [GFS2] Remove support for unused and pointless flag

Heh.

Sounds like we should just kill it.  Any objections?

					- Ted
