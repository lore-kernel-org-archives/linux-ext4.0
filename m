From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/3] ext4 directory index: read-ahead blocks v2
Date: Sun, 17 Jul 2011 20:23:14 -0400
Message-ID: <20110718002314.GD2717@thunk.org>
References: <20110620202631.2473133.4166.stgit@localhost.localdomain>
 <20110620202854.2473133.32514.stgit@localhost.localdomain>
 <20110716235950.GC2717@thunk.org>
 <4E22348E.5060707@fastmail.fm>
 <31F2FDF7-1CED-4831-87E1-861752A6899A@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>,
	linux-ext4@vger.kernel.org, adilger@whamcloud.com, colyli@gmail.com
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55297 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755958Ab1GRAXV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 17 Jul 2011 20:23:21 -0400
Content-Disposition: inline
In-Reply-To: <31F2FDF7-1CED-4831-87E1-861752A6899A@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On Jul 16, 2011, at 9:02 PM, Bernd Schubert wrote:
> 
> > I don't understand it either yet why we have so many, but each directory
> > has about 20 to 30 index blocks

OK, I think I know what's goign on.  Those are 20-30 index blocks;
those are 20-30 leaf blocks.  Your directories are approximately
80-120k, each, right?

So what your patch is doing is constantly doing readahead to bring the
*entire* directory into the buffer cache any time you do a dx_probe.
That's definitely not what we would want to enable by default, but I
really don't like the idea of adding Yet Another Mount option.  It
expands our testing effort, and the reality is very few people will
take advantage of the mount option.

How about this?  What if we don't actually perform readahead, but
instead try to look up all of the blocks to see if they are in the
buffer cache using sb_find_get_block().  If it is in the the buffer
cache, it will get touched, so it will be less likely to be evicted
from the page cache.  So for a workload like yours, it should do what
you want.  But if won't cause all of the pages to get pulled in after
the first reference of the directory in question.

I'm still worried about the case of a very large directory (say an
unreaped tmp directory that has grown to be tens of megabytes).  If a
program does a sequential scan through the directory doing a
"readdir+stat" (i.e., for example a tmp cleaner or someone running the
command ls -sF"), we probably shouldn't be trying to keep all of those
directory blocks in memory.  So if a sequential scan is detected, that
should probably suppress the calls to sb_find_get_block(0.

					- Ted
