From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: Show mballoc and delalloc options
Date: Wed, 24 Oct 2007 12:24:46 -0500
Message-ID: <471F7FDE.80004@redhat.com>
References: <1193244441-10149-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1193244441-10149-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1193244441-10149-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1193244441-10149-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1193244441-10149-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1193244441-10149-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1193244441-10149-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:52511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754988AbXJXRcF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 24 Oct 2007 13:32:05 -0400
In-Reply-To: <1193244441-10149-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Aneesh Kumar K.V wrote:
> Both these options are enabled by default.
> So if they are are not set in mount options
> that means the user explicity disabled them
> using nomablloc and nodelalloc option. Show
> the same in ext4_show_options

Looks good,

Acked-By: Eric Sandeen <sandeen@redhat.com>

> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/ext4/super.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 0c32dc8..f1f70ce 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -733,8 +733,14 @@ static int ext4_show_options(struct seq_file *seq, struct vfsmount *vfs)
>  		seq_puts(seq, ",barrier=1");
>  	if (test_opt(sb, NOBH))
>  		seq_puts(seq, ",nobh");
> +
> +	/* extents,mballoc and delalloc are enabled by default */
>  	if (!test_opt(sb, EXTENTS))
>  		seq_puts(seq, ",noextents");
> +	if (!test_opt(sb, MBALLOC))
> +		seq_puts(seq, ",nomballoc");
> +	if (!test_opt(sb, DELALLOC))
> +		seq_puts(seq, ",nodelalloc");
>  
>  	if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA)
>  		seq_puts(seq, ",data=journal");
