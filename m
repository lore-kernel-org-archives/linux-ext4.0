From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 2/2] ext4: disable COLLAPSE_RANGE for bigalloc
Date: Sat, 19 Apr 2014 18:12:21 -0400
Message-ID: <20140419221221.GD13492@thunk.org>
References: <000d01cf5b8b$5b149110$113db330$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	=?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
To: Namjae Jeon <namjae.jeon@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50158 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294AbaDSWMZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 19 Apr 2014 18:12:25 -0400
Content-Disposition: inline
In-Reply-To: <000d01cf5b8b$5b149110$113db330$@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Apr 19, 2014 at 01:53:50PM +0900, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> Once COLLAPSE RANGE is be disable for ext4 with bigalloc feature till finding
> root-cause of problem. It will be enable with fixing that regression of
> xfstest(generic 075 and 091) again.
> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> Reviewed-by: Lukas Czerner <lczerner@redhat.com>

Thanks, applied.

What's the status of the "[2/3] ext4: fix ZERO_RANGE test failure in
data journalling mode" patch.  Is it no longer needed?

     		       	       	     - Ted
