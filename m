From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [patch]check NULL pointer
Date: Mon, 13 Jun 2011 11:20:17 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1106131116270.4328@dhcp-27-109.brq.redhat.com>
References: <1307590292.15392.71.camel@sli10-conroe>  <alpine.LFD.2.00.1106091112560.4138@dhcp-27-109.brq.redhat.com>  <4DF0DE02.1090008@redhat.com> <1307687692.15392.79.camel@sli10-conroe>  <alpine.LFD.2.00.1106101029160.4502@dhcp-27-109.brq.redhat.com>
 <1307950258.15392.113.camel@sli10-conroe>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>,
	Eric Sandeen <sandeen@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"Ted Ts'o" <tytso@mit.edu>
To: Shaohua Li <shaohua.li@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8255 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871Ab1FMJUX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Jun 2011 05:20:23 -0400
In-Reply-To: <1307950258.15392.113.camel@sli10-conroe>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 13 Jun 2011, Shaohua Li wrote:

> On Fri, 2011-06-10 at 16:32 +0800, Lukas Czerner wrote:
> > On Fri, 10 Jun 2011, Shaohua Li wrote:
> > 
> > > On Thu, 2011-06-09 at 22:51 +0800, Eric Sandeen wrote:
> > > > On 6/9/11 4:24 AM, Lukas Czerner wrote:
> > > > > On Thu, 9 Jun 2011, Shaohua Li wrote:
> > > > > 
> > > > >> orig_data could be NULL.
> > > > > 
> > > > > Now, that is the commit description :). Could you please be more
> > > > > descriptive in the "descritpion" ? Also the subject is not right either,
> > > > > please see Documentation/SubmittingPatches
> > > > 
> > > > Yes; if possible please use the commit message to describe how/why orig_data
> > > > can be NULL; a testcase if one exists; the resulting flaw (null pointer deref?)
> > > > etc.
> > > > 
> > > > something like:
> > > > 
> > > > Subject: [PATCH] ext4: check for NULL orig_data pointer in mount paths
> > > > 
> > > > The orig_data pointer in ext4_fill_super()  and ext4_remount()
> > > > can be null if < ??? >, which can lead to < ??? > in the mount
> > > > and remount paths.  This can be demonstrated by < ??? >.  
> > > > To avoid this, we can simply test for the null pointer
> > > > and return an error in ext4_fill_super() and ext4_remount().
> > > I thought the reason is pretty straightforward, anyway here is the
> > > updated patch.
> > > 
> > > Subject: [patch]ext4: check NULL pointer for mount and remount
> > > 
> > > orig_data could be NULL, because the memory allocation of kstrdup() could fail.
> > > Add the NULL check.
> > 
> > I am sorry, but as I pointed out in previous mail this is not true.
> > *orig_data can be also NULL in the case that *data is NULL and hence
> > there is no reason for exiting with error. Also please use the subject
> > Eric suggested.
> Hmm, maybe we just don't use the pointer if it's NULl. it's just print
> info anyway.
> 
> Subject: [patch]ext4: check NULL orig_data pointer for mount and remount
> 
> orig_data could be NULL, because the memory allocation of kstrdup()
> could fail or data is NULL. Add the NULL check.
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index cc5c157..68eba3b 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3706,7 +3706,7 @@ no_journal:
>  
>  	ext4_msg(sb, KERN_INFO, "mounted filesystem with%s. "
>  		 "Opts: %s%s%s", descr, sbi->s_es->s_mount_opts,
> -		 *sbi->s_es->s_mount_opts ? "; " : "", orig_data);
> +		 *sbi->s_es->s_mount_opts ? "; " : "", orig_data ? : ";");

Hi,

so you are trying resolve the problem when the allocation fails right ?
But what you do is not solving anything, but rather hiding it and it is
not different than we had before.

So what about this:

if (data && !orig_data)
	return ret;

>  
>  	if (es->s_error_count)
>  		mod_timer(&sbi->s_err_report, jiffies + 300*HZ); /* 5 minutes */
> @@ -4443,7 +4443,7 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
>  	if (enable_quota)
>  		dquot_resume(sb, -1);
>  
> -	ext4_msg(sb, KERN_INFO, "re-mounted. Opts: %s", orig_data);
> +	ext4_msg(sb, KERN_INFO, "re-mounted. Opts: %s", orig_data ? : ";");
>  	kfree(orig_data);
>  	return 0;
>  
> 
> 
> 

-- 
