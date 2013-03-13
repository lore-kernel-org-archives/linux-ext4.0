From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: NULL pointer dereference in ext4_superblock_csum_set with
 mounted filesystem
Date: Wed, 13 Mar 2013 15:01:41 -0400
Message-ID: <20130313190141.GF5604@thunk.org>
References: <20130313185911.GA1446@jtriplet-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>
To: Josh Triplett <josh@joshtriplett.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130313185911.GA1446@jtriplet-mobl1>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Mar 13, 2013 at 11:59:13AM -0700, Josh Triplett wrote:
> I frequently test kernel changes by booting them with kvm's -kernel
> option, with -hda pointing to my host system's root filesystem, and
> -snapshot to prevent writing to (and likely corrupting) that root
> filesystem.  I tried this with a kernel built from git commit
> 7c6baa304b841673d3a55ea4fcf9a5cbf7a1674b, with a stock x86-64 "make
> defconfig", and got a kernel panic:

Can you send me the output of "dumpe2fs -h" on your host system's root
file system?

Thanks,

						- Ted
