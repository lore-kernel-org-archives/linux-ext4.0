From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [patch 2/2] ext4: silence a format string false positive
Date: Sat, 15 Aug 2015 11:40:24 -0400
Message-ID: <20150815154024.GC22485@thunk.org>
References: <3FC4DED5-76F2-45DE-8E01-8796850CB120@dilger.ca>
 <20150814094732.GB14179@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150814094732.GB14179@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Aug 14, 2015 at 12:47:32PM +0300, Dan Carpenter wrote:
> Static checkers complain that the format string should be "%s".  It does
> not make a difference for the current code.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks, applied.

						- Ted
