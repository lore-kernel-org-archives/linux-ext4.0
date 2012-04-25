From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [RFC] jbd2: reduce the number of writes when commiting a
 transacation
Date: Tue, 24 Apr 2012 21:27:07 -0400
Message-ID: <20120425012707.GK18865@thunk.org>
References: <20120420110627.GA30373@gmail.com>
 <E5D2F131-A01C-4CB2-8A7C-88CACBBC450B@dilger.ca>
 <20120423022505.GA7855@gmail.com>
 <67060CC0-9F64-40ED-9467-572996ECF21F@whamcloud.com>
 <20120424215709.GA7636@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@whamcloud.com>,
	Zheng Liu <gnehzuil.liu@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56425 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757808Ab2DYB1N (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Apr 2012 21:27:13 -0400
Content-Disposition: inline
In-Reply-To: <20120424215709.GA7636@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 24, 2012 at 11:57:09PM +0200, Jan Kara wrote:
>   Also currently the async commit code has essentially unfixable bugs in
> handling of cache flushes as I wrote in
> http://www.spinics.net/lists/linux-ext4/msg30452.html. Because data blocks
> are not part of journal checksum, it can happen with async commit code that
> data is not safely on disk although transaction is completely committed. So
> async commit code isn't really safe to use unless you are fine with
> exposure of uninitialized data...

With the old journal checksum, the data blocks *are* part of the
journal checksum.  That's not the reason I haven't enabled it as a
default (even though it would close to double fs_mark benchmarks).
The main issue is that e2fsck doesn't deal intelligently if some
commit *other* than the last one has a bad intelligent.

With the new journal checksum patches, each individual data block has
its own checksum, so we don't need to discard the entire commit;
instead we can just drop the individual block(s) that have a bad
checksum, and then force a full fsck run afterwards.

						- Ted
