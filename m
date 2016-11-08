From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/11 v2] ext4: Convert ext4 DAX IO to iomap framework
Date: Wed, 9 Nov 2016 10:17:39 +1100
Message-ID: <20161108231739.GQ28177@dastard>
References: <1478603297-11793-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Ross Zwisler <ross.zwisler@linux.intel.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1478603297-11793-1-git-send-email-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Nov 08, 2016 at 12:08:06PM +0100, Jan Kara wrote:
> Hello,
> 
> this is a second revision of my patches to convert ext4 DAX IO paths to the new
> iomap framework and removes the old bh-based DAX functions. As a result ext4
> gains PMD page fault support, also some other minor bugs get fixed. The patch
> set is based on Ross' DAX PMD page fault support series [1]. It passes xfstests
> both in DAX and non-DAX mode.
> 
> I have pushed out updated version of these patches including the follow-up
> DAX patches to:
> 
> git://get.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git dax
> 
> for easy testing. Once Dave pushes out a stable branch with Ross' patches, we
> pull those into ext4 tree and then pull these patches on top of that (provided
> nobody will have other objections to the current series).

Done:

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git dax-4.10-iomap-pmd

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
