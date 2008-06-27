From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] jbd2: We shouldnot cap writeback when we are doing a
 journal commit
Date: Fri, 27 Jun 2008 13:11:25 -0500
Message-ID: <48652D4D.9010202@redhat.com>
References: <1214590065-26891-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, tytso@mit.edu, jack@suse.cz,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:34608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755372AbYF0STw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Jun 2008 14:19:52 -0400
In-Reply-To: <1214590065-26891-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> A journal commit need to make sure we submit data buffers before
> we submit the meta-data buffers in ordered mode. We should
> not be looking at BDI_CAP_NO_WRITEBACK when doing a journal commit.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

and I don't think we'll ever even see that flag set...

Acked-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/jbd2/commit.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> index 32ca3c3..f8b3be8 100644
> --- a/fs/jbd2/commit.c
> +++ b/fs/jbd2/commit.c
> @@ -203,9 +203,6 @@ static int journal_submit_inode_data_buffers(struct address_space *mapping)
>  		.for_writepages = 1,
>  	};
>  
> -	if (!mapping_cap_writeback_dirty(mapping))
> -		return 0;
> -
>  	ret = generic_writepages(mapping, &wbc);
>  	return ret;
>  }

