From: tytso@mit.edu
Subject: Re: [PATCH] ext4: PTR_ERR return of wrong pointer in
 setup_new_group_blocks()
Date: Mon, 7 Dec 2009 10:37:50 -0500
Message-ID: <20091207153750.GD27692@thunk.org>
References: <4B1D0873.90004@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
To: Roel Kluin <roel.kluin@gmail.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S935367AbZLGPhv@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4B1D0873.90004@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Dec 07, 2009 at 02:51:47PM +0100, Roel Kluin wrote:
> Return the PTR_ERR of the correct pointer.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

						- Ted
