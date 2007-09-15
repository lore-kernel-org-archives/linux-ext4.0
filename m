From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Fw: ext3 dir_index causes an error
Date: Fri, 14 Sep 2007 22:24:24 -0500
Message-ID: <46EB5068.3040605@redhat.com>
References: <20070531211546.86fc9db8.akpm@linux-foundation.org>	<46E840A0.4030504@redhat.com> <46EAC164.6000900@redhat.com> <87y7f8lrvx.fsf@informatik.uni-tuebingen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Theodore Ts'o" <tytso@mit.edu>, hooanon05@yahoo.co.jp,
	sct@redhat.com, adilger@clusterfs.com,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:38356 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508AbXIODYf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 14 Sep 2007 23:24:35 -0400
In-Reply-To: <87y7f8lrvx.fsf@informatik.uni-tuebingen.de>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Goswin von Brederlow wrote:
> Eric Sandeen <sandeen@redhat.com> writes:
> 
>> Eric Sandeen wrote:
>>> Andrew Morton wrote:
>>>> Ted is dir_index maintainer ;)
>> ...
>>
>>>> [1.] One line summary of the problem:
>>>> ext3 dir_index causes an error
>>> I'm looking at this now, FWIW... pretty easy to reproduce on ppc64,
>>> though I've not yet hit it on x86.
>> The issue here is that do_split() splits a leaf node at the entry with
>> the median hash value, after sorting by hash... but it pays no attention
>> to the resulting size of the records in the old & new blocks.
> 
> http://en.wikipedia.org/wiki/Median
> 
> | At most half the population have values less than the median and at
> | most half have values greater than the median. If both groups
> | contain less than half the population, then some of the population
> | is exactly equal to the median.
> 
> That would mean that both records will be the same size and to have an
> overflow both would have to overflow. They should both be half full
> +-1.

No, it means that both blocks will have +/-1 the same *number* of
entries.  It says nothing about how much space is used in each.

>> If you're unlucky, and your split is lopsided size-wise, you may not
>> have space in the block chosen for the new entry.  This is not checked,
>> however, and things go bad quickly.
> 
> Maybe you did not mean median although it would be the logical choice.

Semantics aside, we don't want the median hash value, the middle hash
value, or the average hash value... as far as I can see, we don't care
about the hash value when we make this decision.  We care about the
sizes of the objects, not their hashes, and not where they fall in an
ordered list of hashes.

When deciding how many entries to move, we have to pay attention to how
much space they're taking up, not just how many of them there are.  If
we only move the tiny entries, even if they accounts for half of the
entries in the dir, that may not create enough room for the big entry
we're trying to fit.   Moving exactly half the entries may create a very
lopsided size distribution.

-Eric
