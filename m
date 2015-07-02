From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] bufferhead: Add _gfp version for sb_getblk()
Date: Thu, 2 Jul 2015 02:14:05 -0400
Message-ID: <20150702061405.GA3108@thunk.org>
References: <1435645609-20387-1-git-send-email-kernel@kyup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Nikolay Borisov <kernel@kyup.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1435645609-20387-1-git-send-email-kernel@kyup.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jun 30, 2015 at 09:26:48AM +0300, Nikolay Borisov wrote:
> sb_getblk() is used during ext4 (and possibly other FSes) writeback
> paths. Sometimes such path require allocating memory and guaranteeing
> that such allocation won't block. Currently, however, there is no way
> to provide user flags for sb_getblk which could lead to deadlocks.
> 
> This patch implements a sb_getblk_gfp with the only difference it can
> accept user-provided GFP flags.
> 
> Signed-off-by: Nikolay Borisov <kernel@kyup.com>

I've added this to the ext4.git tree, thanks.

     	   	       		      - Ted
