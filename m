From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/1] ext4: fix ext4_get_group_number() at cluster
 boundaries
Date: Thu, 11 Jul 2013 21:49:25 -0400
Message-ID: <20130712014925.GC31005@thunk.org>
References: <1373542128-15662-1-git-send-email-apw@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Andy Whitcroft <apw@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1373542128-15662-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jul 11, 2013 at 12:28:48PM +0100, Andy Whitcroft wrote:
> Commit bd86298e60b8 introduced a new optimisation for callers who needed
> only the ext4 group number and not the block offset within.  It hand
> calculates the group number from the block in the common case, falling
> back to the original group offset implementation otherwise.

A fix for this problem is already in the ext4 tree, and will be pushed
to Linus shortly:

http://git.kernel.org/cgit/linux/kernel/git/tytso/ext4.git/commit/?h=dev&id=960fd856fdc3b08b3638f3f9b6b4bfceb77660c7

Cheers,

					- Ted
