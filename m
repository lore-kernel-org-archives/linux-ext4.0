From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH V2] ext4 crypto: exit cleanly if ext4_derive_key_aes()
 fails
Date: Wed, 22 Jul 2015 00:09:03 -0400
Message-ID: <20150722040903.GG2944@thunk.org>
References: <1436472434-5853-1-git-send-email-laurent.navet@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Laurent Navet <laurent.navet@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1436472434-5853-1-git-send-email-laurent.navet@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jul 09, 2015 at 10:07:14PM +0200, Laurent Navet wrote:
> Return value of ext4_derive_key_aes() is stored but not used.
> Add test to exit cleanly if ext4_derive_key_aes() fail.
> Also fix coverity CID 1309760.
> 
> Signed-off-by: Laurent Navet <laurent.navet@gmail.com>

Thanks, applied.

						- Ted
