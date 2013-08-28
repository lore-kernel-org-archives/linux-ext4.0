From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: extents: len and lblock may be used uninitialized
Date: Wed, 28 Aug 2013 14:20:56 -0400
Message-ID: <20130828182056.GB27079@thunk.org>
References: <1374712385-6691-1-git-send-email-andi@etezian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Andi Shyti <andi@etezian.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1374712385-6691-1-git-send-email-andi@etezian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jul 25, 2013 at 02:33:05AM +0200, Andi Shyti wrote:
> if ext_debugging is enabled and path[depth].p_ext is NULL, len
> and lblock are printed non initialized
> 
> Signed-off-by: Andi Shyti <andi@etezian.org>

Thanks, applied.

						- Ted
