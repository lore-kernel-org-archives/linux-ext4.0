From: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Subject: Re: Fw: ext3 dir_index causes an error
Date: Sat, 15 Sep 2007 02:00:18 +0200
Message-ID: <87y7f8lrvx.fsf@informatik.uni-tuebingen.de>
References: <20070531211546.86fc9db8.akpm@linux-foundation.org>
	<46E840A0.4030504@redhat.com> <46EAC164.6000900@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Theodore Ts'o" <tytso@mit.edu>, hooanon05@yahoo.co.jp,
	sct@redhat.com, adilger@clusterfs.com,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.Informatik.Uni-Tuebingen.De ([134.2.12.5]:33878 "EHLO
	mx1.informatik.uni-tuebingen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759525AbXIOAce (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 14 Sep 2007 20:32:34 -0400
In-Reply-To: <46EAC164.6000900@redhat.com> (Eric Sandeen's message of "Fri, 14
	Sep 2007 12:14:12 -0500")
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Eric Sandeen <sandeen@redhat.com> writes:

> Eric Sandeen wrote:
>> Andrew Morton wrote:
>
>>> Ted is dir_index maintainer ;)
>
> ...
>
>>> [1.] One line summary of the problem:
>>> ext3 dir_index causes an error
>> 
>> I'm looking at this now, FWIW... pretty easy to reproduce on ppc64,
>> though I've not yet hit it on x86.
>
> The issue here is that do_split() splits a leaf node at the entry with
> the median hash value, after sorting by hash... but it pays no attention
> to the resulting size of the records in the old & new blocks.

http://en.wikipedia.org/wiki/Median

| At most half the population have values less than the median and at
| most half have values greater than the median. If both groups
| contain less than half the population, then some of the population
| is exactly equal to the median.

That would mean that both records will be the same size and to have an
overflow both would have to overflow. They should both be half full
+-1.

> If you're unlucky, and your split is lopsided size-wise, you may not
> have space in the block chosen for the new entry.  This is not checked,
> however, and things go bad quickly.

Maybe you did not mean median although it would be the logical choice.

> Talked with Andreas a little about this, looking into the best way to
> fix it up.
>
> -Eric

MfG
        Goswin
