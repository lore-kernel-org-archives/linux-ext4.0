From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 11/37] e2fsck: fix the extended attribute checksum error
 message
Date: Tue, 6 May 2014 12:12:18 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1405061212030.2255@localhost.localdomain>
References: <20140501231222.31890.82860.stgit@birch.djwong.org> <20140501231334.31890.49878.stgit@birch.djwong.org> <alpine.LFD.2.00.1405021445200.2154@localhost.localdomain> <20140505230829.GK8434@birch.djwong.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1040641587-1399371141=:2255"
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21185 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934609AbaEFKMX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 May 2014 06:12:23 -0400
In-Reply-To: <20140505230829.GK8434@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1040641587-1399371141=:2255
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Mon, 5 May 2014, Darrick J. Wong wrote:

> Date: Mon, 5 May 2014 16:08:29 -0700
> From: Darrick J. Wong <darrick.wong@oracle.com>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
> Subject: Re: [PATCH 11/37] e2fsck: fix the extended attribute checksum error
>     message
> 
> On Fri, May 02, 2014 at 02:46:56PM +0200, Lukáš Czerner wrote:
> > On Thu, 1 May 2014, Darrick J. Wong wrote:
> > 
> > > Date: Thu, 01 May 2014 16:13:34 -0700
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > To: tytso@mit.edu, darrick.wong@oracle.com
> > > Cc: linux-ext4@vger.kernel.org
> > > Subject: [PATCH 11/37] e2fsck: fix the extended attribute checksum error
> > >     message
> > > 
> > > Make the "EA block passes checks but fails checksum" message less
> > > strange.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  e2fsck/problem.c |   12 +++++-------
> > >  1 file changed, 5 insertions(+), 7 deletions(-)
> > > 
> > > 
> > > diff --git a/e2fsck/problem.c b/e2fsck/problem.c
> > > index 0999399..ec20bd1 100644
> > > --- a/e2fsck/problem.c
> > > +++ b/e2fsck/problem.c
> > > @@ -992,19 +992,17 @@ static struct e2fsck_problem problem_table[] = {
> > >  	     "extent\n\t(logical @b %c, @n physical @b %b, len %N)\n"),
> > >  	  PROMPT_FIX, 0 },
> > >  
> > > -	/* Extended attribute block checksum for inode does not match. */
> > > +	/* Extended attribute block checksum does not match. */
> > 
> > The "for inode" is still there in the message, so I do not think
> > there is a reason to remove it from the comment.
> 
> Oops.
> 
> > >  	{ PR_1_EA_BLOCK_CSUM_INVALID,
> > > -	  N_("Extended attribute @a @b %b checksum for @i %i does not "
> > > -	     "match.  "),
> > > +	  N_("@a @b %b checksum for @i %i does not match.  "),
> > >  	  PROMPT_CLEAR, PR_INITIAL_CSUM },
> > >  
> > >  	/*
> > > -	 * Extended attribute block passes checks, but checksum for inode does
> > > -	 * not match.
> > > +	 * Extended attribute block passes checks, but checksum does not
> > > +	 * match.
> > >  	 */
> > >  	{ PR_1_EA_BLOCK_ONLY_CSUM_INVALID,
> > > -	  N_("Extended attribute @a @b %b passes checks, but checksum for "
> > > -	     "@i %i does not match.  "),
> > > +	  N_("@a @b %b passes checks, but checksum does not match.  "),
> > 
> > Is there a reason to remove the inode number from the message ?
> 
> For whatever reason, I was confused by this message and thought it was
> referring to a checksum failure in the inode itself.  On the other hand, it's
> helpful to map an EA block back to an inode, so perhaps the message should be
> changed to:
> 
> "Inode XXX's extended attribute block YYY passes checks, but checksum does not
> match."

That sounds better, thanks!
-Lukas

> 
> Now that I look at the other metadata_csum checks, the failure message starts
> with "@i %i..." so these two might as well follow the convention.  Sorry that I
> seem to have strayed from it.
> 
> --D
> > 
> > Thanks!
> > -Lukas
> > 
> > >  	  PROMPT_FIX, 0 },
> > >  
> > >  	/*
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--8323328-1040641587-1399371141=:2255--
