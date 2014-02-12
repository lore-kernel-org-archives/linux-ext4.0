From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/1] ext4: Add __init macro to init_inodecache
Date: Wed, 12 Feb 2014 11:20:30 -0500
Message-ID: <20140212162030.GC14520@thunk.org>
References: <20140201191007.59012c84446860984e6c4a76@skynet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
To: Fabian Frederick <fabf@skynet.be>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140201191007.59012c84446860984e6c4a76@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Feb 01, 2014 at 07:10:07PM +0800, Fabian Frederick wrote:
> init_inodecache is only called by __init init_ext4_fs.
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Applied, thanks.

					- Ted
