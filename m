From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3 12/22] ext4: use little-endian bitops
Date: Tue, 23 Nov 2010 14:29:06 -0500
Message-ID: <20101123192906.GD2767@thunk.org>
References: <1290519504-3958-1-git-send-email-akinobu.mita@gmail.com>
 <1290519504-3958-13-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1290519504-3958-13-git-send-email-akinobu.mita@gmail.com>
Sender: linux-arch-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Nov 23, 2010 at 10:38:14PM +0900, Akinobu Mita wrote:
> As a preparation for removing ext2 non-atomic bit operations from
> asm/bitops.h. This converts ext2 non-atomic bit operations to
> little-endian bit operations.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> Cc: linux-ext4@vger.kernel.org

Acked-by: "Theodore Ts'o" <tytso@mit.edu>

						- Ted
