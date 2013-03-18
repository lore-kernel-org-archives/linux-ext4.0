From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: possible dev branch regression - xfstest 285/1k
Date: Mon, 18 Mar 2013 13:09:28 -0400
Message-ID: <20130318170927.GA5639@thunk.org>
References: <20130315222818.GA16100@wallace>
 <20130316150923.GA18589@gmail.com>
 <20130317030648.GA14225@thunk.org>
 <51473C8B.5070509@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Whitney <enwlinux@gmail.com>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54157 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506Ab3CRRJc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Mar 2013 13:09:32 -0400
Content-Disposition: inline
In-Reply-To: <51473C8B.5070509@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 18, 2013 at 11:10:51AM -0500, Eric Sandeen wrote:
> 
> The test could do this too, right?
> 
> _need_to_be_root
> 
> and:
> 
> if [ "$FSTYP" == "ext4" ]; then
> 	ORIG_ZEROOUT_KB=`cat /sys/fs/ext4/$TEST_DEV/extent_max_zeroout_kb`
> 	echo 0 > /sys/fs/ext4/$TEST_DEV/extent_max_zeroout_kb
> fi
> 
> and put it back to default in _cleanup:
> 
> 	echo $ORIG_ZEROOUT_KB > /sys/fs/ext4/$TEST_DEV/extent_max_zeroout_kb
> 
> That way we'd be testing seek hole correctness w/o being subject to
> the vagaries in allocator behavior.

Yeah, the question is whether it would be more acceptable to put
ext4-specific hacks like this into the test, or to modify
src/seek_sanity_test.c so that it writes the test block-size block
using pwrite at offset blocksize*42 instead of offset blocksize*10.

I had assumed putting hacks which tweaked sysfs tunables into the
xfstest script itself would be frowned upon, but if that's considered
OK, that would be great.

	      	 		       - Ted

