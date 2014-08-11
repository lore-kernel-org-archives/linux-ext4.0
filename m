From: Li Xi <pkuelelixi@gmail.com>
Subject: Re: [PATCH v2 0/4] quota: add project quota support
Date: Mon, 11 Aug 2014 22:49:58 +0800
Message-ID: <CAPTn0cAeN6-JJ4LZp_fpb_+nrx7A80CBeCA15dR6Fjnxf8bWCg@mail.gmail.com>
References: <CAPTn0cCh0fh2REPgyXg_nBrJVVppiujVyj6XKruocg1q7MVVVA@mail.gmail.com>
	<20140811144535.GD3506@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"hch@infradead.org" <hch@infradead.org>, Jan Kara <jack@suse.cz>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:63145 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700AbaHKOt7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Aug 2014 10:49:59 -0400
In-Reply-To: <20140811144535.GD3506@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 11, 2014 at 10:41 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Sat, Aug 09, 2014 at 12:39:58AM +0800, Li Xi wrote:
>> It is obvious that extended attribute implementation has performance
>> impact when creating files. That is why we choose to push the patches
>> which use internal inode field to save project ID.
>
> Looking at your numbers more closely, I bit you are parsing the
> extended attributes each time you need to adjust the project quota for
> the file, correct?  I suspect that if you cache the project ID in the
> in-memory struct ext4_inode_info, the performance difference between
> using an extended attribute versus an internal inode field will be
> negligible.  The only difference would be a tiny amount of CPU time
> when you first create the inode, and when you read the inode from the
> inode table block on disk, since the project ID will under normal
> circumstances never or hardly ever change.
Yeah, I cached project ID in memory, not only for this internal inode field
implementation but also for xattr based implementation. Yeah, that is
right that reading project ID doesn't impact performance. However, as
the results shows, creating xattr costs extra time. That is why creating files
on xattr based implemetation is significantly slower than internal inode filed
implementation. Other operations won't be effected at all. We confirmed
this in varible way. If we remove xattr saving when creating files, the
performance will go up immediately. And also, we confirmed that ACL
has similar performance problem.

Regards,
Li Xi
