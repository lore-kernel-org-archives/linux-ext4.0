From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 1/2] resize2fs: Add support for lazy itable
 initialization
Date: Tue, 1 Feb 2011 20:31:08 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1102012025400.3559@dhcp-lab-213.englab.brq.redhat.com>
References: <1296580465-28519-1-git-send-email-lczerner@redhat.com> <5B2E3DA2-B789-41BE-8534-BB19D1B9FA44@dilger.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	tytso@MIT.EDU
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2095 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167Ab1BATbP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Feb 2011 14:31:15 -0500
In-Reply-To: <5B2E3DA2-B789-41BE-8534-BB19D1B9FA44@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 1 Feb 2011, Andreas Dilger wrote:

> On 2011-02-01, at 10:14, Lukas Czerner wrote:
> > This commit adds extended options '-E' to the resize2fs code along with
> > the first extended option lazy_itable_init=n.
> 
> Here it says the option is "=n", is it also possible to force this with "=y"?

Oh, no not really. It should be just =0 or =1, it is the same as we have in
mke2fs.

> 
> > +static void parse_extended_opts(int *flags, const char *opts)
> > +{
> > +		if (!strcmp(token, "lazy_itable_init")) {
> > +			int lazy;
> > +			if (arg)
> > +				lazy = strtoul(arg, &p, 0);
> > +			else
> > +				lazy = 1;
> > +			if (lazy)
> > +				*flags |= RESIZE_LAZY_ITABLE_INIT;
> 
> Here it parses the option as "=0" or "=1", not "=n" or "=y".  It looks like "=n" will accidentally return 0 from strtoul(), so that works as expected, but the "=y" option would fail (it would also return 0).

As I mentioned it is not supposed to work with =y or =n, but only with
=0 or =1. So I think it is expected, isn't it ?

> 
> > +	if (r_usage) {
> > +		fprintf(stderr, _("\nBad option(s) specified: %s\n\n"
> > +			"\tlazy_itable_init=<0 to disable, 1 to enable>\n\n"),
> 
> It looks a bit confusing "=<0 to disable", I thought initially that meant any value <= 0 would disable it, though I later see that there is a closing '>'.  I think it is more standard to use "{}" braces for "one of these options must be given".

:) I did not noticed that before, but you're right, I'll change that to
use "{}".

> 
> > @@ -232,6 +290,12 @@ int main (int argc, char ** argv)
> > +	if (access("/sys/fs/ext4/features/lazy_itable_init", R_OK) == 0)
> > +		flags |= RESIZE_LAZY_ITABLE_INIT;
> > +
> > +	if (extended_opts)
> > +		parse_extended_opts(&flags, extended_opts);
> 
> Good that the command-line options override the default value.

Yes, it suppose to be that way.

> 
> > +.B lazy_itable_init\fR[\fB= \fI<0 to disable, 1 to enable>\fR]
> 
> Similarly, this should use "{}" around the options instead of "<>".
> 
> > +If enabled and the uninit_bg feature is enabled, the inode table will
> > +not be fully initialized by
> 
> I would write "not be zeroed out on disk", since it is otherwise unclear
> if "not fully initialized" means that there will be less inodes available
> or some other issues if the inode table is not "fully" initialized.

Right.

> 
> Cheers, Andreas
> 

Thanks!
-Lukas
