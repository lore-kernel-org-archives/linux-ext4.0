From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] ext3: Fix typos in messages and comments (journalled ->
 journaled)
Date: Thu, 1 May 2008 00:20:18 +0100
Message-ID: <20080501002018.2729adcc@core>
References: <12095679813226-git-send-email-jack@suse.cz>
	<12095679812375-git-send-email-jack@suse.cz>
	<12095679812452-git-send-email-jack@suse.cz>
	<1209567981639-git-send-email-jack@suse.cz>
	<20080430104330.66c44d4f.akpm@linux-foundation.org>
	<20080430212711.168bdcc0@core>
	<1209592973.6113.23.camel@norville.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:58938 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755198AbYD3X3U (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Apr 2008 19:29:20 -0400
In-Reply-To: <1209592973.6113.23.camel@norville.austin.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> > A search of the ACM literature finds "journalized", "journalled" and
> > "journaled" are all in use for this operation.
> 
> I hate to get into these discussions, but I've used "journaled" a lot,
> so I feel I should chime in.

I noticed and IBM cannot even agree internally 8)

"Tivoli Storage Manager Journal Based Backup troubleshooting techniques
 and solutions to common problems seen with journalized backups and the
 journal database. This is from a 2005_November_07 Support Technical
 Exchange Web seminar presented by TSM Support staff"

"IBM Journaled File System (JFS)"


> That would probably be more correct, but the use of "journal" as a verb
> has really gotten ingrained in file system developers brains.  I
> personally haven't heard or used "journalized" and it would take some
> getting used to.

Mandrake use Journalized File System in various press articles. Mac
people seem to like journalized too and google shows it used in various
reviews and articles.

I think I'm going to follow this up with the professional bodies and see
if there is an opinion because either the computing world needs to agree
on a proper English name, or they need to agree on a new one and talk to
the dictionary people about it.


Alan
