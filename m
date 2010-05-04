From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Prevent creation of files larger than
	RLIMIT_FSIZE using fallocate
Date: Tue, 4 May 2010 11:58:16 +0530
Message-ID: <20100504062815.GA8091@amitarora.in.ibm.com>
References: <201004281854.49730.knikanth@suse.de> <201005030953.45157.knikanth@suse.de> <20100503065945.GA13756@amitarora.in.ibm.com> <201005041115.04400.knikanth@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, coly.li@suse.de,
	Nick Piggin <npiggin@suse.de>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org,
	Eelis <opensuse.org@contacts.eelis.net>,
	Amit Arora <aarora@in.ibm.com>,
	Christoph Hellwig <hch@infradead.org>
To: Nikanth Karthikesan <knikanth@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:38161 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755220Ab0EDG2Y (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 May 2010 02:28:24 -0400
Content-Disposition: inline
In-Reply-To: <201005041115.04400.knikanth@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 04, 2010 at 11:15:04AM +0530, Nikanth Karthikesan wrote:
> I assumed that Amit would send a patch with s-o-b, if not, please take
> this patch.
Have added my sign-off below. Thanks!

--
Regards,
Amit Arora
> Thanks
> Nikanth
> 
> Prevent creation of files larger than RLIMIT_FSIZE using fallocate.
> 
> Currently using posix_fallocate one can bypass an RLIMIT_FSIZE limit
> and create a file larger than the limit. Add a check for that.
> 
> 
> Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
Signed-off-by: Amit Arora <aarora@in.ibm.com>
 
> ---
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 236b834..39b8123 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3672,6 +3672,11 @@ long ext4_fallocate(struct inode *inode, int mode, loff_t offset, loff_t len)
>  	 */
>  	credits = ext4_chunk_trans_blocks(inode, max_blocks);
>  	mutex_lock(&inode->i_mutex);
> +	ret = inode_newsize_ok(inode, (len + offset));
> +	if (ret) {
> +		mutex_unlock(&inode->i_mutex);
> +		return ret;
> +	}
>  retry:
>  	while (ret >= 0 && ret < max_blocks) {
>  		block = block + ret;
