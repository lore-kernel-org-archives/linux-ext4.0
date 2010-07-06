From: tytso@mit.edu
Subject: Re: inconsistent file placement
Date: Tue, 6 Jul 2010 18:01:01 -0400
Message-ID: <20100706220101.GA6603@thunk.org>
References: <469D2D911E4BF043BFC8AD32E8E30F5B24AED8@wdscexbe07.sc.wdc.com>
 <20100706185548.GA26677@thunk.org>
 <4C337D16.9000200@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Daniel Taylor <Daniel.Taylor@wdc.com>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:58089 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755645Ab0GFWB0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Jul 2010 18:01:26 -0400
Content-Disposition: inline
In-Reply-To: <4C337D16.9000200@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 06, 2010 at 01:59:34PM -0500, Eric Sandeen wrote:
> However, from the test description it looks like it is writing
> a file to the root dir, so there should be no parent-dir random spreading,
> right?

Hmm, yes, I missed that part of Daniel's e-mail.  He's just writing a
single file.  In that case, Amir is right, the only thing which would
be causing this is the colour offset, at least for ext2 and ext3.
This is avoid fragmented files caused by two or more processes running
on different CPU's all writing into the same block group.

In the case of ext4, we don't use a pid-determined colour algorithm if
delayed allocation is used, and the randomness is caused by the
writeback system deciding to write out different chunks of pages
first.  The way to fix this when writing large files is to use
fallocate(2) when writing a large file, so it can be allocated
contiguously.

In any case, Daniel, if you want the best results for your benchmark,
use ext4, and tweak the script slightly:

touch /DataVolume/hex.txt
fallocate -l 5G /DataVolume/hex.txt
for i in 0 1 2 3 4
do
    dd if=/hex.txt of=/DataVolume/hex.txt bs=64k conv=notrunc \
       oflag=direct,append
done

Best regards,

					- Ted
