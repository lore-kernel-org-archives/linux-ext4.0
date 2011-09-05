From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 1/2 v4] e2fsprogs: Fix how we treat user-spcified filesystem
 size
Date: Mon, 5 Sep 2011 13:58:32 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1109051358080.3697@dhcp-27-109.brq.redhat.com>
References: <1307269845-15062-1-git-send-email-lczerner@redhat.com> <20110903151004.GB3687@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55175 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322Ab1IEL6i (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Sep 2011 07:58:38 -0400
In-Reply-To: <20110903151004.GB3687@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 3 Sep 2011, Ted Ts'o wrote:

> On Sun, Jun 05, 2011 at 12:30:44PM +0200, Lukas Czerner wrote:
> > We can not specify filesystem size in blocks count without specifying
> > blocksize as well. It is because we need blocks count to determine
> > filesystem type, and we need filesystem type to determine blocksize. So
> > it should not be allowed, however due to compatibility reason it should
> > be still possible, so at least print warning message for now, so we can
> > easily restrict that later.
> 
> What we currently have is actually very well defined.  The fs-size
> parameter is either an absolute size, if a suffixed value (i.e., 12k,
> 64M, 128G, 2T) is specified.  If the value does not have a suffix,
> then it is either interpreted as a block count if a blocksize is
> specified, or as kilobytes if no blocksize is explicitly specified.
> 
> And this is really only a problem with mke2fs; it's not a problem with
> resize2fs, since we know what the blocksize is.
> 
> > diff --git a/lib/e2p/parse_num.c b/lib/e2p/parse_num.c
> > index 83a329a..8e2751b 100644
> > --- a/lib/e2p/parse_num.c
> > +++ b/lib/e2p/parse_num.c
> > @@ -37,7 +37,6 @@ unsigned long long parse_num_blocks2(const char *arg, int log_block_size)
> >  		num >>= (1+log_block_size);
> >  		break;
> >  	case '\0':
> > -		break;
> >  	default:
> >  		return 0;
> >  	}
> 
> and this doesn't do what the commit description claims.  This change
> actually breaks the use of a number that does not have a suffix.
> 
> I'd rather not break resize2fs at all.  If script wants to specify a
> block count, that's fine.  If we want to add a warning which gets
> printed by mke2fs in the case where there is no explicit blockcount
> specified by the user and no explicit size suffix to the fs-size
> parameter stating that parameter was interpreted as kilobytes, that's
> fine.
> 
> Basically, how mke2fs parses that field has been the way it has been
> for over a decade, and it's really not caused any problems for users.
> 
>     	   	       	    	       - Ted
> 

Ok, than. We can drop the patch.

Thanks!
-Lukas
