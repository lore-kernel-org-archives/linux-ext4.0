From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH -v2] ext4: don't dereference null pointer when make_indexed_dir()
 fails
Date: Mon, 09 May 2011 09:56:59 -0500
Message-ID: <4DC800BB.502@redhat.com>
References: <20110509142237.GA19811@thunk.org> <1304951228-24962-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Allison Henderson <achender@linux.vnet.ibm.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400Ab1EIO5M (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 May 2011 10:57:12 -0400
In-Reply-To: <1304951228-24962-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/9/11 9:27 AM, Theodore Ts'o wrote:
> From: Allison Henderson <achender@linux.vnet.ibm.com>

Ted, can we be a little careful about attribution in cases like this?

If I have it straight, this isn't the patch Allison sent, it's based on it, but it is in fact:

Modified-by: Theodore Ts'o <tytso@mit.edu>

right?

I think it's important to keep track of who is making various changes to submitted patches, especially when they are functional (i.e. not whitespace or spelling, etc) changes.

Ideally, IMHO, the original submitter should be submitting V2 based on feedback, unless they are AWOL; this way patches attributed to a submitter really are their patches, and it is another layer of review if the original submitter can evaluate the proposed changes to their original patch...

Doing it this way should lighten your load too, I'd think.

Thanks,
-Eric



> Fix for a null pointer bug found while running punch hole tests
> 
> Signed-off-by: Allison Henderson <achender@us.ibm.com>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  fs/ext4/namei.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 3c7a06e..cc97feb 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -1422,7 +1422,9 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
>  		 */
>  		ext4_mark_inode_dirty(handle, dir);
>  		ext4_handle_dirty_metadata(handle, dir, frame->bh);
> -		ext4_handle_dirty_metadata(handle, dir, bh);
> +		ext4_handle_dirty_metadata(handle, dir, bh2);
> +		if (bh)
> +			ext4_handle_dirty_metadata(handle, dir, bh);
>  		dx_release(frames);
>  		return retval;
>  	}

