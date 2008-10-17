From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH, RFC] ext4: Replace hackish
	ext4_mb_poll_new_transaction with commit callback
Date: Fri, 17 Oct 2008 11:34:25 +0530
Message-ID: <20081017060424.GA26192@skywalker>
References: <1224201763-9637-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754028AbYJQGEn@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1224201763-9637-1-git-send-email-tytso@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Oct 16, 2008 at 08:02:43PM -0400, Theodore Ts'o wrote:
> The multiblock allocator needs to be able to release blocks (and issue
> a blkdev discard request) when the transaction which freed those
> blocks is committed.  Previously this was done via a polling mechanism
> when blocks are allocated or freed.  A much better way of doing things
> is to create a jbd2 callback function and attaching the list of blocks
> to be freed directly to the transaction structure.


Why not use journal commit callback patch from andreas 
(MID:20080929201752.GN10950@webber.adilger.int
http://article.gmane.org/gmane.comp.file-systems.ext4/9148)

The patch you sent will allows only one call back to be registered.

-aneesh
