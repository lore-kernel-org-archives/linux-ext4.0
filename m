From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] Check for immutable flag in fallocate path
Date: Mon, 14 Mar 2011 06:24:26 -0400
Message-ID: <20110314102426.GA29888@infradead.org>
References: <4D6221B8.9040303@gmail.com>
 <4D6F5473.2070709@gmail.com>
 <20110303213903.GL15097@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Marco Stornelli <marco.stornelli@gmail.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	cluster-devel@redhat.com, xfs@oss.sgi.com,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110303213903.GL15097@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Mar 04, 2011 at 08:39:03AM +1100, Dave Chinner wrote:
> WTF?  Why does append mode have any effect on whether we can punch
> holes in a file or not? There's no justification for adding this in
> the commit message. Why is it even in a patch that is for checking
> immutable inodes? What is the point of adding it, when all that will
> happen is people will switch to XFS_IOC_UNRESVSP which has never had
> this limitation?

xfs_ioc_space unconditionally rejects inodes with S_APPEND set for
all preallocation / hole punching ioctls.  This might be overzealous for
preallocations not changing the size, or just extending i_size, but it's
IMHO entirely correct for hole punching.  
