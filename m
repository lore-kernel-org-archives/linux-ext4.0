From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext3: Fix typos in messages and comments (journalled
	-> journaled)
Date: Wed, 30 Apr 2008 21:28:07 -0500
Message-ID: <1209608887.7650.6.camel@norville.austin.ibm.com>
References: <12095679813226-git-send-email-jack@suse.cz>
	 <12095679812375-git-send-email-jack@suse.cz>
	 <12095679812452-git-send-email-jack@suse.cz>
	 <1209567981639-git-send-email-jack@suse.cz>
	 <20080430104330.66c44d4f.akpm@linux-foundation.org>
	 <20080430212711.168bdcc0@core>
	 <1209592973.6113.23.camel@norville.austin.ibm.com>
	 <20080501002018.2729adcc@core>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:55443 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754470AbYEAC2K (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Apr 2008 22:28:10 -0400
In-Reply-To: <20080501002018.2729adcc@core>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Thu, 2008-05-01 at 00:20 +0100, Alan Cox wrote:
> > > A search of the ACM literature finds "journalized", "journalled" and
> > > "journaled" are all in use for this operation.
> > 
> > I hate to get into these discussions, but I've used "journaled" a lot,
> > so I feel I should chime in.
> 
> I noticed and IBM cannot even agree internally 8)
> 
> "Tivoli Storage Manager Journal Based Backup troubleshooting techniques
>  and solutions to common problems seen with journalized backups and the
>  journal database. This is from a 2005_November_07 Support Technical
>  Exchange Web seminar presented by TSM Support staff"
> 
> "IBM Journaled File System (JFS)"

IBM's big.  What can I say?  :-)

> > That would probably be more correct, but the use of "journal" as a verb
> > has really gotten ingrained in file system developers brains.  I
> > personally haven't heard or used "journalized" and it would take some
> > getting used to.
> 
> Mandrake use Journalized File System in various press articles. Mac
> people seem to like journalized too and google shows it used in various
> reviews and articles.

I guess it's more common that I thought.

> I think I'm going to follow this up with the professional bodies and see
> if there is an opinion because either the computing world needs to agree
> on a proper English name, or they need to agree on a new one and talk to
> the dictionary people about it.

If there's some kind of consensus, I don't have strong feelings either
way.
-- 
David Kleikamp
IBM Linux Technology Center

