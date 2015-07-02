From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: make use of sb_getblk_gfp
Date: Thu, 2 Jul 2015 10:17:54 -0400
Message-ID: <20150702141754.GA9456@thunk.org>
References: <1435645609-20387-1-git-send-email-kernel@kyup.com>
 <1435645609-20387-2-git-send-email-kernel@kyup.com>
 <20150702061427.GB3108@thunk.org>
 <5594D742.6040202@kyup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Nikolay Borisov <kernel@kyup.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5594D742.6040202@kyup.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jul 02, 2015 at 09:16:34AM +0300, Nikolay Borisov wrote:
> 
> Just a question that popped to my mind after discussing with a colleague
> - Is GFP_NOFS enough here or should it be GFP_NOIO? Presumably the
> latter is a stronger guarantee that we are not going to hit any
> fs/writeback related code?

GFP_NOFS is fine here; file system code calls the I/O codepaths, but
device driver code doesn't call fs code.  Put another way, if there
are pages that are backed by a block device, which can be cleaned
without going through the FS code paths, it's fine to let that happen
while we are inside file system code.

						- Ted
