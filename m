From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [patch] ext4: checking NULL instead of ERR_PTR
Date: Wed, 29 Dec 2010 22:55:53 -0500
Message-ID: <20101230035553.GL10149@thunk.org>
References: <20100826091619.GC20072@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@lst.de>,
	Eric Sandeen <sandeen@redhat.com>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:39968 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967Ab0L3D4H (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Dec 2010 22:56:07 -0500
Content-Disposition: inline
In-Reply-To: <20100826091619.GC20072@bicker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 26, 2010 at 11:16:54AM +0200, Dan Carpenter wrote:
> d_path() returns an ERR_PTR and it doesn't return NULL.  This is in
> ext4_error_file() and no one actually calls ext4_error_file().
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Thanks, I've added this to the ext4 patch tree.

	     	   	       	    	  - Ted
