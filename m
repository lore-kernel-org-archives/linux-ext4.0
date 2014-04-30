From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 4/7] mke2fs: create a regular file if necessary
Date: Wed, 30 Apr 2014 16:14:16 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1404301611290.2100@localhost.localdomain>
References: <1398556834-31913-1-git-send-email-tytso@mit.edu> <1398556834-31913-4-git-send-email-tytso@mit.edu> <alpine.LFD.2.00.1404301410590.2100@localhost.localdomain> <20140430140657.GB9213@thunk.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-426410603-1398867258=:2100"
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17632 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759010AbaD3OOW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Apr 2014 10:14:22 -0400
In-Reply-To: <20140430140657.GB9213@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-426410603-1398867258=:2100
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Wed, 30 Apr 2014, Theodore Ts'o wrote:

> Date: Wed, 30 Apr 2014 10:06:57 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
> Subject: Re: [PATCH 4/7] mke2fs: create a regular file if necessary
> 
> On Wed, Apr 30, 2014 at 02:21:46PM +0200, Lukáš Czerner wrote:
> > > +	fd = open(device, fl, 0666);
> > > +	if (fd < 0) {
> > > +		fprintf(stderr, _("Could not open %s: %s\n"),
> > >  			device, error_message(errno));
> > >  		if (errno == ENOENT)
> > >  			fputs(_("\nThe device apparently does not exist; "
> > >  				"did you specify it correctly?\n"), stderr);
> > >  		exit(1);
> > >  	}
> > > +
> > > +	if (ext2fs_fstat(fd, &s) < 0) {
> > > +		perror("stat");
> > 
> > Maybe we can leave the old error printing code for consistency ?
> > 
> > 	fprintf(stderr, _("Could not stat %s --- %s\n"),
> > 		device, error_message(errno));
> > 
> > Otherwise it looks good.
> 
> Well, it's very rare that ext2fs_fstat() would fail in
> practice.  Previously the most common situation where ext2fs_stat()
> would fail would be due to the file not existing or if there was a
> permission denied error.
> 
> So I had modified the "Could not stat..." message to "Could not open",
> since it would now be the open that failed, and if the file doesn't
> exist, we're going to try to create the file first.
> 
> Hmm, it occurs to me if the user typo's the file name in and the user
> specifies the size explicitly (i.e., "mke2fs /dev/scd3 2T) , it could
> result in the the root file system filling up.  I'm not sure that's
> big of a deal, since the user can always control-C the mke2fs and then
> delete the typo'ed file name.  Do we think this is a real problem?
> I'm not too worried...

Oops, yes that would be nasty :) I'm not too worried either, but
I've done my share of typos as well, so I am not sure. And since
we're already asking a lot of questions anyway maybe we can ask
about this one as well ?

-Lukas

> 
>     	    				- Ted
> 
--8323328-426410603-1398867258=:2100--
