From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Fw: ext3 dir_index causes an error
Date: Fri, 14 Sep 2007 12:14:12 -0500
Message-ID: <46EAC164.6000900@redhat.com>
References: <20070531211546.86fc9db8.akpm@linux-foundation.org> <46E840A0.4030504@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Theodore Ts'o" <tytso@mit.edu>, hooanon05@yahoo.co.jp,
	sct@redhat.com, adilger@clusterfs.com,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:58663 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992AbXINROU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 14 Sep 2007 13:14:20 -0400
In-Reply-To: <46E840A0.4030504@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Eric Sandeen wrote:
> Andrew Morton wrote:

>> Ted is dir_index maintainer ;)

...

>> [1.] One line summary of the problem:
>> ext3 dir_index causes an error
> 
> I'm looking at this now, FWIW... pretty easy to reproduce on ppc64,
> though I've not yet hit it on x86.

The issue here is that do_split() splits a leaf node at the entry with
the median hash value, after sorting by hash... but it pays no attention
to the resulting size of the records in the old & new blocks.

If you're unlucky, and your split is lopsided size-wise, you may not
have space in the block chosen for the new entry.  This is not checked,
however, and things go bad quickly.

Talked with Andreas a little about this, looking into the best way to
fix it up.

-Eric
