From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: inconsistent file placement
Date: Tue, 06 Jul 2010 13:59:34 -0500
Message-ID: <4C337D16.9000200@redhat.com>
References: <469D2D911E4BF043BFC8AD32E8E30F5B24AED8@wdscexbe07.sc.wdc.com> <20100706185548.GA26677@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Daniel Taylor <Daniel.Taylor@wdc.com>, linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1151 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755674Ab0GFS7k (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Jul 2010 14:59:40 -0400
In-Reply-To: <20100706185548.GA26677@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

tytso@mit.edu wrote:
> On Mon, Jul 05, 2010 at 06:49:34PM -0700, Daniel Taylor wrote:
>> I realize that it is enerally not a good idea to tune
>> an operating system, or subsystem, for benchmarking, but
>> there's something that I don't understand about ext[234]
>> that is badly affecting our product.  File placement on
>> newly-created file systems is inconsistent.  I can't,
>> yet, call it a bug, but I really need to understand what
>> is happening, and I cannot find, in the source code, the
>> source of the randomization (related to "goal"???).
> 
> In ext3, it really is random.  The randomness you're looking for can
> be found in fs/ext3/ialloc.c:find_group_orlov(), when it calls
> get_random_bytes().  This is responsible for "spreading" directories
> so they are spread across the block groups, to try to prevent
> fragmented files.  Yes, if all you care about is benchmarks which only
> use 10% of the entire file system, and for which the benchmarks don't
> adequately simulate file system aging, the algorithms in ext3 will
> cause a lot of variability.

However, from the test description it looks like it is writing
a file to the root dir, so there should be no parent-dir random spreading,
right?

-Eric

