From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 11/15] mke2fs: fix determination of size_type
Date: Wed, 1 Dec 2010 16:46:20 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1012011645450.3071@dhcp-lab-213.englab.brq.redhat.com>
References: <1291020917-8671-1-git-send-email-namhyung@gmail.com>  <1291020917-8671-12-git-send-email-namhyung@gmail.com>  <alpine.LFD.2.00.1011301328040.3004@dhcp-lab-213.englab.brq.redhat.com> <1291207057.1684.30.camel@leonhard>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="571108635-418234644-1291218383=:3071"
Cc: Lukas Czerner <lczerner@redhat.com>, Theodore Tso <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752147Ab0LAPq0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 1 Dec 2010 10:46:26 -0500
In-Reply-To: <1291207057.1684.30.camel@leonhard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--571108635-418234644-1291218383=:3071
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 1 Dec 2010, Namhyung Kim wrote:

> 2010-11-30 (화), 13:33 +0100, Lukas Czerner:
> > On Mon, 29 Nov 2010, Namhyung Kim wrote:
> > 
> > > In original code, 'huge' type could not be selected because it
> > > always be caught for 'big' type. Change the ordering.
> > > 
> > > Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> > > ---
> > >  misc/mke2fs.c |    4 ++--
> > >  1 files changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> > > index 90cc206..b88decf 100644
> > > --- a/misc/mke2fs.c
> > > +++ b/misc/mke2fs.c
> > > @@ -947,10 +947,10 @@ static char **parse_fs_type(const char *fs_type,
> > >  		size_type = "floppy";
> > >  	else if (fs_blocks_count < 512 * meg)
> > >  		size_type = "small";
> > > -	else if (fs_blocks_count >= 4 * 1024 * 1024 * meg)
> > > -		size_type = "big";
> > >  	else if (fs_blocks_count >= 16 * 1024 * 1024 * meg)
> > >  		size_type = "huge";
> > > +	else if (fs_blocks_count >= 4 * 1024 * 1024 * meg)
> > > +		size_type = "big";
> > >  	else
> > >  		size_type = "default";
> > >  
> > > 
> > 
> > Personally, I do not like it very much. Either sort this in ascending order
> > and use "<" or sort it in descending order and use ">=". But since it
> > was originally sorted in ascending order I would do that this way.
> > 
> > -Lukas
> 
> No problem. You mean "floppy, small, default, big and huge", right? I'll
> resend v2 if you prefer that, Ted.
> 
> Thanks.
> 

Right.

Thanks!

-Lukas
--571108635-418234644-1291218383=:3071--
