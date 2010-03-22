From: tytso@mit.edu
Subject: Re: [PATCH] ext4: Fix coding style in fs/ext4/move_extent.c
Date: Sun, 21 Mar 2010 20:20:50 -0400
Message-ID: <20100322002050.GA11560@thunk.org>
References: <bd0d95d71003170312s10fd8680xcbea67cc8d681296@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, adilger@sun.com,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	linux-kernel@vger.kernel.org
To: Steven Liu <lingjiujianke@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <bd0d95d71003170312s10fd8680xcbea67cc8d681296@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Mar 17, 2010 at 06:12:14PM +0800, Steven Liu wrote:
> fix a code style in fs/ext4/move_extent.c
> 
> Signed-off-by: LiuQi <lingjiujianke@gmail.com>

I've added this to the ext4 patch queue with the following changelog
description:

ext4: Fix coding style in fs/ext4/move_extent.c

From: Steven Liu <lingjiujianke@gmail.com>

Making sure ee_block is initialized to zero to prevent gcc from
kvetching.  It's harmless (although it's not obvious that it's
harmless) from code inspection:

fs/ext4/move_extent.c:478: warning: 'start_ext.ee_block' may be used
uninitialized in this function

Thanks to Stefan Richter for first bringing this to the attention of
linux-ext4@vger.kernel.org.

Signed-off-by: LiuQi <lingjiujianke@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>

						- Ted
