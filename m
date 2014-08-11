From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: New feature/project ideas
Date: Mon, 11 Aug 2014 11:21:11 -0700
Message-ID: <20140811182111.GF2808@birch.djwong.org>
References: <1407700151.84765.YahooMailNeo@web192906.mail.sg3.yahoo.com>
 <6C7C8265-F142-4C07-8EDC-B0DBFAB8CBF5@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Vimal A R <arvimal@yahoo.in>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45131 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbaHKSVR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Aug 2014 14:21:17 -0400
Content-Disposition: inline
In-Reply-To: <6C7C8265-F142-4C07-8EDC-B0DBFAB8CBF5@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 11, 2014 at 08:12:44PM +0200, Andreas Dilger wrote:
> Many of the projects listed on that page are already implemented. 
> 
> I think one of the more important ones that has not yet been done
> is the per-block journal checksums and improved recovery in case
> of checksum failure on a transaction. 

I was about to start poking around with that this afternoon, hoping it doesn't
take 3-4 months. :)

Also piling on are: adding commit.c to e2fsprogs so debugfs can create journal
transactions for testing, and possibly resyncing revoke.c/recovery.c.

--D
> 
> Cheers, Andreas
> 
> > On Aug 10, 2014, at 21:49, Vimal A R <arvimal@yahoo.in> wrote:
> > 
> > Hello,
> > 
> > I came across https://ext4.wiki.kernel.org/index.php/TODO_list while searching for an idea as part of my undergraduate CS project. 
> > 
> > 
> > I would like to know if this list is updated/latest, and if not, are there any project ideas which would be apt for a 3-4 month time-frame. Any ideas and suggestions are welcome.
> > 
> > Thank you,
> > 
> > Vimal
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
