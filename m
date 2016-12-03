From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/1 linux-next] ext4: fix block_validity definition
Date: Sat, 3 Dec 2016 16:44:21 -0500
Message-ID: <20161203214421.ykmrs5rtzuduz4es@thunk.org>
References: <1477251814-9938-1-git-send-email-fabf@skynet.be>
 <20161023201003.GA5245@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161023201003.GA5245@birch.djwong.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I've applied this patch with some further cleanups.  The documentation
for the mount options now reads:

block_validity(*)	These options enable or disable the in-kernel
noblock_validity	facility for tracking filesystem metadata blocks
			within internal data structures.  This allows multi-
			block allocator and other routines to notice
			bugs or corrupted allocation bitmaps which cause
			blocks to be allocated which overlap with
			filesystem metadata blocks.

						- Ted
