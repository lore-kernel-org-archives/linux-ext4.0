From: tytso@mit.edu
Subject: Re: [PATCH] ext3: PTR_ERR return of wrong pointer in
 setup_new_group_blocks()
Date: Mon, 7 Dec 2009 10:37:28 -0500
Message-ID: <20091207153728.GC27692@thunk.org>
References: <4B1D0813.4070502@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
To: Roel Kluin <roel.kluin@gmail.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S935356AbZLGPhk@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4B1D0813.4070502@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Dec 07, 2009 at 02:50:11PM +0100, Roel Kluin wrote:
> Return the PTR_ERR of the correct pointer.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Reviewed-by: "Theodore Ts'o" <tytso@mit.edu>

Thanks for pointing this out!  I've added a similar patch for ext4 in
the patch queue.

					- Ted
