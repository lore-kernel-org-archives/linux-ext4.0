From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [patch]check NULL pointer
Date: Fri, 10 Jun 2011 10:32:35 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1106101029160.4502@dhcp-27-109.brq.redhat.com>
References: <1307590292.15392.71.camel@sli10-conroe>  <alpine.LFD.2.00.1106091112560.4138@dhcp-27-109.brq.redhat.com>  <4DF0DE02.1090008@redhat.com> <1307687692.15392.79.camel@sli10-conroe>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Eric Sandeen <sandeen@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"Ted Ts'o" <tytso@mit.edu>
To: Shaohua Li <shaohua.li@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53248 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372Ab1FJIcl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 10 Jun 2011 04:32:41 -0400
In-Reply-To: <1307687692.15392.79.camel@sli10-conroe>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 10 Jun 2011, Shaohua Li wrote:

> On Thu, 2011-06-09 at 22:51 +0800, Eric Sandeen wrote:
> > On 6/9/11 4:24 AM, Lukas Czerner wrote:
> > > On Thu, 9 Jun 2011, Shaohua Li wrote:
> > > 
> > >> orig_data could be NULL.
> > > 
> > > Now, that is the commit description :). Could you please be more
> > > descriptive in the "descritpion" ? Also the subject is not right either,
> > > please see Documentation/SubmittingPatches
> > 
> > Yes; if possible please use the commit message to describe how/why orig_data
> > can be NULL; a testcase if one exists; the resulting flaw (null pointer deref?)
> > etc.
> > 
> > something like:
> > 
> > Subject: [PATCH] ext4: check for NULL orig_data pointer in mount paths
> > 
> > The orig_data pointer in ext4_fill_super()  and ext4_remount()
> > can be null if < ??? >, which can lead to < ??? > in the mount
> > and remount paths.  This can be demonstrated by < ??? >.  
> > To avoid this, we can simply test for the null pointer
> > and return an error in ext4_fill_super() and ext4_remount().
> I thought the reason is pretty straightforward, anyway here is the
> updated patch.
> 
> Subject: [patch]ext4: check NULL pointer for mount and remount
> 
> orig_data could be NULL, because the memory allocation of kstrdup() could fail.
> Add the NULL check.

I am sorry, but as I pointed out in previous mail this is not true.
*orig_data can be also NULL in the case that *data is NULL and hence
there is no reason for exiting with error. Also please use the subject
Eric suggested.

Thanks!
-Lukas

> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index cc5c157..45fc255 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3057,6 +3057,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  	unsigned int journal_ioprio = DEFAULT_JOURNAL_IOPRIO;
>  	ext4_group_t first_not_zeroed;
>  
> +	if (!orig_data)
> +		return ret;
>  	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
>  	if (!sbi)
>  		goto out_free_orig;
> @@ -4285,6 +4287,8 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
>  #endif
>  	char *orig_data = kstrdup(data, GFP_KERNEL);
>  
> +	if (!orig_data)
> +		return -ENOMEM;
>  	/* Store the original options */
>  	lock_super(sb);
>  	old_sb_flags = sb->s_flags;
> 
> 
> 

-- 
