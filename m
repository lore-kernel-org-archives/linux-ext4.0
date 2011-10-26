From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [patch] ext4: error handling fix in
 ext4_ext_convert_to_initialized()
Date: Wed, 26 Oct 2011 04:00:51 -0400
Message-ID: <20111026080051.GO31921@thunk.org>
References: <20111011134912.GB27127@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42109 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754016Ab1JZIA7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Oct 2011 04:00:59 -0400
Content-Disposition: inline
In-Reply-To: <20111011134912.GB27127@elgon.mountain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 11, 2011 at 04:49:12PM +0300, Dan Carpenter wrote:
> When allocated is unsiged it breaks the error handling at the end
> of the function when we call:
> 	allocated = ext4_split_extent(...);
> 	if (allocated < 0)
> 		err = allocated;
> 
> I've made it a signed int instead of unsigned.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks, applied.

						- Ted
