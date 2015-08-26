From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 13/19] tune2fs: Add support for changing number of
 reserved inodes
Date: Wed, 26 Aug 2015 18:07:05 +0200
Message-ID: <20150826160705.GE14012@quack.suse.cz>
References: <1438944689-24562-1-git-send-email-jack@suse.com>
 <1438944689-24562-14-git-send-email-jack@suse.com>
 <9A74D391-E8E3-42A1-9319-5A0B54BDBC5F@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org,
	Ted Tso <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>
To: Alexey Lyashkov <alexey.lyashkov@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60841 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671AbbHZQHK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Aug 2015 12:07:10 -0400
Content-Disposition: inline
In-Reply-To: <9A74D391-E8E3-42A1-9319-5A0B54BDBC5F@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat 08-08-15 10:45:00, Alexey Lyashkov wrote:
> 
> > On Aug 7, 2015, at 1:51 PM, Jan Kara <jack@suse.com> wrote:
> > 
> > Signed-off-by: Jan Kara <jack@suse.com>
> > ---
> > 
> > +			new_first_ino = strtoul(arg, &p, 0);
> > +			if (*p) {
> > +				fprintf(stderr,
> > +					_("Invalid number of reserved inodes "
> > +					  "%s\n"),
> > +					arg);
> > +				r_usage++;
> > +				continue;
> > +			}
> > 
> 
> this check invalid - you need check an errno for ERANGE also. 
> add check against maximal number inodes on FS is also good.

Good point. Added both checks.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
