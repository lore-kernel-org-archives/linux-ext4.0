From: Ric Mason <ric.masonn@gmail.com>
Subject: Re: [PATCH 2/3] mm: Ensure that mark_page_accessed moves pages to
 the active list
Date: Wed, 01 May 2013 16:14:16 +0800
Message-ID: <5180CED8.9040505@gmail.com>
References: <1367253119-6461-1-git-send-email-mgorman@suse.de> <1367253119-6461-3-git-send-email-mgorman@suse.de> <5180AB0E.6030407@gmail.com> <20130501080644.GE11497@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Sam Ben <sam.bennn@gmail.com>,
	Alexey Lyahkov <alexey.lyashkov@gmail.com>,
	Andrew Perepechko <anserper@ya.ru>,
	Robin Dong <sanbai@taobao.com>, Theodore Tso <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hugh Dickins <hughd@google.com>,
	Rik van Riel <riel@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Bernd Schubert <bernd.schubert@fastmail.fm>,
	David Howells <dhowells@redhat.com>,
	Trond Myklebust <Trond.Myklebust@netapp.com>,
	Linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Linux-ext4 <linux-ext4@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Linux-mm <linux-mm@kvack.org>
To: Mel Gorman <mgorman@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:37597 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289Ab3EAIOZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 May 2013 04:14:25 -0400
In-Reply-To: <20130501080644.GE11497@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 05/01/2013 04:06 PM, Mel Gorman wrote:
> On Wed, May 01, 2013 at 01:41:34PM +0800, Sam Ben wrote:
>> Hi Mel,
>> On 04/30/2013 12:31 AM, Mel Gorman wrote:
>>> If a page is on a pagevec then it is !PageLRU and mark_page_accessed()
>>> may fail to move a page to the active list as expected. Now that the
>>> LRU is selected at LRU drain time, mark pages PageActive if they are
>>> on a pagevec so it gets moved to the correct list at LRU drain time.
>>> Using a debugging patch it was found that for a simple git checkout
>>> based workload that pages were never added to the active file list in
>> Could you show us the details of your workload?
>>
> The workload is git checkouts of a fixed number of commits for the

Is there script which you used?

> kernel git tree. It starts with a warm-up run that is not timed and then
> records the time for a number of iterations.

How to record the time for a number of iterations? Is the iteration here 
means lru scan?

>

