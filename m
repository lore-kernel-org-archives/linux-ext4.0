From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH RFC] ext3 data=guarded v5
Date: Wed, 29 Apr 2009 13:47:31 -0600
Message-ID: <20090429194731.GJ3209@webber.adilger.int>
References: <1240941840.15136.44.camel@think.oraclecorp.com>
 <20090429085632.GA18273@duck.suse.cz>
 <1241014093.20099.28.camel@think.oraclecorp.com>
 <1241016181.20099.31.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Jan Kara <jack@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Mike Galbraith <efault@gmx.de>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:63130 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760808AbZD2Trs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 29 Apr 2009 15:47:48 -0400
Content-disposition: inline
In-reply-to: <1241016181.20099.31.camel@think.oraclecorp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Apr 29, 2009  10:43 -0400, Chris Mason wrote:
> On Wed, 2009-04-29 at 10:08 -0400, Chris Mason wrote:
> > This would mean IO completion (clearing PG_writeback) would have to wait
> > on the inode mutex, which we can't quite do in O_SYNC and O_DIRECT.
> > But, what I can do is check i_nlink after the ext3_orphan_del call and
> > put the inode back on the orphan list if it has gone to zero.
> 
> Ugh, that won't work, we'll just race with link and risk an orphan that
> never gets removed.  I'll make a version of ext3_orphan_del that expects
> the super lock held and use that instead.

I looks like ext3_link() checks for i_nlink == 0 and returns -ENOENT to
avoid this race.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

