From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4: indirect block allocations not sequential in 3.4.67 and
 3.11.7
Date: Mon, 20 Jan 2014 14:52:40 -0600
Message-ID: <52DD8C98.9070505@redhat.com>
References: <20140115192802.GK21295@kvack.org> <20140115202214.GH9229@birch.djwong.org> <20140115203205.GA12751@kvack.org> <20140115215613.GD12751@kvack.org> <20140116035459.GB14736@thunk.org> <20140116184826.GG12751@kvack.org> <20140116191227.GC32098@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>, Benjamin LaHaise <bcrl@kvack.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65214 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbaATUwq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Jan 2014 15:52:46 -0500
In-Reply-To: <20140116191227.GC32098@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 1/16/14, 1:12 PM, Theodore Ts'o wrote:
> On Thu, Jan 16, 2014 at 01:48:26PM -0500, Benjamin LaHaise wrote:
>>
>> Any idea when this commit was made or titled?  I care about random 
>> performance as well, but that can't be at the cost of making sequential 
>> reads suck.
> 
> Thinking about this some more, I think it was made as part of the
> changes to better take advantage of the flex_bg feature in ext4.  The
> idea was to keep metadata blocks such as directory blocks and extent
> trees closer together.  I don't think when we made that change we
> really consciously thought that much about indirect block support,
> since that was viewed as a legacy feature for backwards compatibility
> support in ext4.  (This was years ago, before distributions started
> wanting to support only one code base for ext3 and ext4 file systems.)

Just to nitpick, wasn't this always the plan?  ;)

https://lkml.org/lkml/2006/6/28/454 :

> 4) At some point, probably in 6-9 months when we are satisified with the
> set of features that have been added to fs/ext4, and confident that the
> filesystem format has stablized, we will submit a patch which causes the
> fs/ext4 code to register itself as the ext4 filesystem.

-Eric

p.s. "6-9 months"  ;)
