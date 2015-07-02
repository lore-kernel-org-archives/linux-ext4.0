From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: make use of sb_getblk_gfp
Date: Thu, 2 Jul 2015 02:14:27 -0400
Message-ID: <20150702061427.GB3108@thunk.org>
References: <1435645609-20387-1-git-send-email-kernel@kyup.com>
 <1435645609-20387-2-git-send-email-kernel@kyup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Nikolay Borisov <kernel@kyup.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1435645609-20387-2-git-send-email-kernel@kyup.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jun 30, 2015 at 09:26:49AM +0300, Nikolay Borisov wrote:
> Switch ext4 to using sb_getblk_gfp with GFP_NOFS added, this fixes
> possible deadlocks in the page writeback path.
> 
> Signed-off-by: Nikolay Borisov <kernel@kyup.com>

I've added this to the ext4.git tree, thanks.

						- Ted
