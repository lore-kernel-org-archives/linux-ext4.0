From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH -V4 07/11] vfs: Make acl_permission_check() work for
 richacls
Date: Fri, 24 Sep 2010 11:50:49 -0400
Message-ID: <20100924115049.47b1217b@tlielax.poochiereds.net>
References: <1285332494-12756-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<1285332494-12756-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: sfrench@us.ibm.com, ffilz@us.ibm.com, agruen@suse.de,
	adilger@sun.com, sandeen@redhat.com, tytso@mit.edu,
	bfields@citi.umich.edu, linux-fsdevel@vger.kernel.org,
	nfsv4@linux-nfs.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23108 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932172Ab0IXPvI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Sep 2010 11:51:08 -0400
In-Reply-To: <1285332494-12756-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 24 Sep 2010 18:18:10 +0530
"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:

> From: Andreas Gruenbacher <agruen@suse.de>
> 
> Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/namei.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/namei.c b/fs/namei.c
> index 855b360..b0b8a71 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -174,6 +174,12 @@ static int acl_permission_check(struct inode *inode, int mask,
>  {
>  	umode_t			mode = inode->i_mode;
>  
> +	if (IS_RICHACL(inode)) {
> +		int error = check_acl(inode, mask);
> +		if (error != -EAGAIN)
> +			return error;
> +	}
> +
>  	if (current_fsuid() == inode->i_uid)
>  		mode >>= 6;
>  	else {

This may just be my own ignorance of ACL semantics and unfamiliarity
with the ACL code in general. It seems a bit unusual though...

Just to be clear...this patch implies that with richacls you can deny
or grant access to the owner of the file even if the mode bits say
otherwise. With POSIX acls, this seems to be the other way around.

Hmm....guess I should read the spec...

-- 
Jeff Layton <jlayton@redhat.com>
