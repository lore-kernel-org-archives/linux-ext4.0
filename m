From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3 0/2] ext4: increase mbcache scalability
Date: Wed, 4 Sep 2013 22:35:22 -0400
Message-ID: <20130905023522.GA21268@thunk.org>
References: <1374108934-50550-1-git-send-email-tmac@hp.com>
 <1378312756-68597-1-git-send-email-tmac@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, aswin@hp.com,
	torvalds@linux-foundation.org, aswin_proj@groups.hp.com
To: T Makphaibulchoke <tmac@hp.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1378312756-68597-1-git-send-email-tmac@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Sep 04, 2013 at 10:39:14AM -0600, T Makphaibulchoke wrote:
> 
> Here are the performance improvements in some of the aim7 workloads,

How did you gather these results?  The mbcache is only used if you are
using extended attributes, and only if the extended attributes don't
fit in the inode's extra space.

I checked aim7, and it doesn't do any extended attribute operations.
So why are you seeing differences?  Are you doing something like
deliberately using 128 byte inodes (which is not the default inode
size), and then enabling SELinux, or some such?

						- Ted
