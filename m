From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [patch]check NULL pointer
Date: Tue, 14 Jun 2011 12:07:12 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1106141159050.4259@dhcp-27-109.brq.redhat.com>
References: <1307590292.15392.71.camel@sli10-conroe>  <alpine.LFD.2.00.1106091112560.4138@dhcp-27-109.brq.redhat.com>  <4DF0DE02.1090008@redhat.com> <1307687692.15392.79.camel@sli10-conroe>  <alpine.LFD.2.00.1106101029160.4502@dhcp-27-109.brq.redhat.com>
 <1307950258.15392.113.camel@sli10-conroe>  <alpine.LFD.2.00.1106131116270.4328@dhcp-27-109.brq.redhat.com> <1308011473.15392.114.camel@sli10-conroe>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>,
	Eric Sandeen <sandeen@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"Ted Ts'o" <tytso@mit.edu>
To: Shaohua Li <shaohua.li@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28954 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755210Ab1FNKHS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 14 Jun 2011 06:07:18 -0400
In-Reply-To: <1308011473.15392.114.camel@sli10-conroe>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 14 Jun 2011, Shaohua Li wrote:

--snip--
> > > Hmm, maybe we just don't use the pointer if it's NULl. it's just print
> > > info anyway.
> > > 
> > > Subject: [patch]ext4: check NULL orig_data pointer for mount and remount
> > > 
> > > orig_data could be NULL, because the memory allocation of kstrdup()
> > > could fail or data is NULL. Add the NULL check.
> > > 
> > > Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> > > 
> > > diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> > > index cc5c157..68eba3b 100644
> > > --- a/fs/ext4/super.c
> > > +++ b/fs/ext4/super.c
> > > @@ -3706,7 +3706,7 @@ no_journal:
> > >  
> > >  	ext4_msg(sb, KERN_INFO, "mounted filesystem with%s. "
> > >  		 "Opts: %s%s%s", descr, sbi->s_es->s_mount_opts,
> > > -		 *sbi->s_es->s_mount_opts ? "; " : "", orig_data);
> > > +		 *sbi->s_es->s_mount_opts ? "; " : "", orig_data ? : ";");
> > 
> > Hi,
> > 
> > so you are trying resolve the problem when the allocation fails right ?
> > But what you do is not solving anything, but rather hiding it and it is
> > not different than we had before.
> > 
> > So what about this:
> > 
> > if (data && !orig_data)
> > 	return ret;
> how could this work? if data is NULL, orig_data will be NULL, the
> ext4_msg will still use a NULL pointer.
> 

Hi,

I am sorry if it was not clear, but as Ted already pointed out printk
can handle NULL pointer, so there is no need to care about it in this
case.

Also it is not a *big* deal not to handle allocation failure in kstrdup,
because there are other allocations in fill_super and remount which will
result in error, however I think that it is better to catch such cases
as early as we can, so it is good to fix this.

Thanks!
-Lukas
