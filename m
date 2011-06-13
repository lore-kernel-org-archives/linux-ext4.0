From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [patch]check NULL pointer
Date: Mon, 13 Jun 2011 17:02:12 -0400
Message-ID: <20110613210212.GA2246@thunk.org>
References: <1307590292.15392.71.camel@sli10-conroe>
 <alpine.LFD.2.00.1106091112560.4138@dhcp-27-109.brq.redhat.com>
 <4DF0DE02.1090008@redhat.com>
 <1307687692.15392.79.camel@sli10-conroe>
 <alpine.LFD.2.00.1106101029160.4502@dhcp-27-109.brq.redhat.com>
 <1307950258.15392.113.camel@sli10-conroe>
 <alpine.LFD.2.00.1106131116270.4328@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Shaohua Li <shaohua.li@intel.com>,
	Eric Sandeen <sandeen@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:41418 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060Ab1FNDAZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Jun 2011 23:00:25 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1106131116270.4328@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 13, 2011 at 11:20:17AM +0200, Lukas Czerner wrote:
> >  	ext4_msg(sb, KERN_INFO, "mounted filesystem with%s. "
> >  		 "Opts: %s%s%s", descr, sbi->s_es->s_mount_opts,
> > -		 *sbi->s_es->s_mount_opts ? "; " : "", orig_data);
> > +		 *sbi->s_es->s_mount_opts ? "; " : "", orig_data ? : ";");
> 
> Hi,
> 
> so you are trying resolve the problem when the allocation fails right ?
> But what you do is not solving anything, but rather hiding it and it is
> not different than we had before.

So a couple of observations here.  The kernel's sprintf/printk
functions will not OOPS if "%s" is asked to expand a NULL pointer; it
will simply print "(null)".  So it's not a disaster if orig_data is
NULL.  It's would perhaps be better (for cosmetic reasons) if we
printed something such as "Opts: (none)", but it's not a huge deal
either way.

> So what about this:
> 
> if (data && !orig_data)
> 	return ret;

Sure, that's technically better.  I'll note though that if we fail the
kstrdup(), there are so many other memory allocations happening later
in ext4_fill_super() that it's highly likely one of the others will
fail and we will then return ENOMEM.

That's not to say that patches here aren't welcome, but (a) it's
useful to take a look at the big picture, and (b) I'm going to
prioritize this as a "clean up" patch that can wait until the merge
window for v3.1.  It will be a great opportunity for Shaohua to
practice submitting a high quality patch that complies with the
Documentation/SubmittingPatches requirements.

Regards,

							- Ted
