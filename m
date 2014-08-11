From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 0/4] quota: add project quota support
Date: Mon, 11 Aug 2014 10:41:12 -0400
Message-ID: <20140811144112.GC3506@thunk.org>
References: <CAPTn0cAKi64Fh1pAVTDLvSS5-1Kjv7KN2HpGxtm4J8-ym-4nOQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	viro@ZenIV.linux.org.uk, hch@infradead.org, Jan Kara <jack@suse.cz>
To: Li Xi <pkuelelixi@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54529 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753235AbaHKOlW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Aug 2014 10:41:22 -0400
Content-Disposition: inline
In-Reply-To: <CAPTn0cAKi64Fh1pAVTDLvSS5-1Kjv7KN2HpGxtm4J8-ym-4nOQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Aug 09, 2014 at 12:39:58AM +0800, Li Xi wrote:
> It is obvious that extended attribute implementation has performance
> impact when creating files. That is why we choose to push the patches
> which use internal inode field to save project ID.

Looking at your numbers more closely, I bit you are parsing the
extended attributes each time you need to adjust the project quota for
the file, correct?  I suspect that if you cache the project ID in the
in-memory struct ext4_inode_info, the performance difference between
using an extended attribute versus an internal inode field will be
negligible.  The only difference would be a tiny amount of CPU time
when you first create the inode, and when you read the inode from the
inode table block on disk, since the project ID will under normal
circumstances never or hardly ever change.

Regards,

					- Ted
