From: Alberto Bertogli <albertito@blitiri.com.ar>
Subject: Re: jbd2 inside a device mapper module
Date: Thu, 25 Dec 2008 22:00:05 -0200
Message-ID: <20081226000005.GB4127@blitiri.com.ar>
References: <20081224211038.GT4127@blitiri.com.ar> <20081224234915.GA23723@mit.edu> <20081225143535.GA4127@blitiri.com.ar> <20081225155248.GJ9871@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, dm-devel@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from alerce.vps.bitfolk.com ([212.13.194.134]:4611 "EHLO
	alerce.vps.bitfolk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbYLZACH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Dec 2008 19:02:07 -0500
Content-Disposition: inline
In-Reply-To: <20081225155248.GJ9871@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 25, 2008 at 10:52:48AM -0500, Theodore Tso wrote:
> On Thu, Dec 25, 2008 at 12:35:35PM -0200, Alberto Bertogli wrote:
> >  - What is the reason behind the j_inode check in jbd2_journal_create()?
> 
> jbd2_journal_create was only designed for creating inode-based
> journals, and it's a deprecated function that will likely be removed
> soon.

Thanks, I didn't know that!


> >  - Does mke2fs -O journal_dev creates a journal that jbd2_journal_load()
> >    is supposed to read without any knowledge of ext2/3/4 stuff? If not,
> >    how can I create such a journal? I'll be looking at the e2fsprogs
> >    code for the answer to this question later today (I haven't looked at
> >    it yet).
> 
> mke2fs -O journal_dev creates an external journal, but when you create
> a filesystem, you need to specify need to specify location of the
> external journal.    Hence:
> 
> 	 mke2fs -O journal_dev /dev/extern_journal_dev
> 	 mke2fs -t ext4 -J device=/dev/extern_journal_dev /dev/filesystem_dev
> 
> As I said in my last message.  I've tested it, and it works Just Fine.

I think I'm not explaining myself correctly. My code has _nothing_ to do
with ext2/3/4 (or any other filesystem) whatsoever. I'm not using the
journal as an external one for a filesystem. I want to use it to be able
to do atomic writes in my own, filesystem independant, device-mapper
code.

After what you told me (both this and the deprecation of
jbd2_journal_create()), I took a look at e2fsprogs' source. From what I
could see, "mke2fs -O journal_dev" creates the external journal inside
some ext2/3/4 structures, which caused my journal-loading code to fail
(because it doesn't know about ext stuff).

So, I wrote a small "mkjournal" utility that creates a journal on the
block device without any ext2/3/4 stuff. It's based on e2fsprogs'
mkjournal.c, except it doesn't have any ext2 stuff. And it worked great!
I'm now able to load the journal just fine.

Thanks a lot for all the help!

		Alberto

