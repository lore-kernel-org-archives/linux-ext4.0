From: "U.Mutlu" <for-gmane@mutluit.com>
Subject: Re: Htree concept
Date: Thu, 14 May 2015 04:50:15 +0200
Message-ID: <mj12h7$nq3$1@ger.gmane.org>
References: <mivr40$2lj$1@ger.gmane.org> <55537BF7.8000602@redhat.com>
 <mj019e$f8f$1@ger.gmane.org> <mj0250$tvl$1@ger.gmane.org>
 <20150513211854.GA25272@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33912 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933345AbbENCuZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 May 2015 22:50:25 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1YsjE6-000845-A7
	for linux-ext4@vger.kernel.org; Thu, 14 May 2015 04:50:22 +0200
Received: from ip4d14ab60.dynamic.kabel-deutschland.de ([77.20.171.96])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Thu, 14 May 2015 04:50:22 +0200
Received: from for-gmane by ip4d14ab60.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Thu, 14 May 2015 04:50:22 +0200
In-Reply-To: <20150513211854.GA25272@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Ts'o wrote on 05/13/2015 11:18 PM:
> On Wed, May 13, 2015 at 07:37:36PM +0200, U.Mutlu wrote:
>> I think I slowly grasp how HTree works: it keeps a (rb/avl tree)
>> b*tree-db (I guess it stores it on disk) of the hashes (as keys).
>
> The reason for using hashes is it keeps the fanout of the tree very
> high, which in turn keeps the depth of the tree very short.  This
> means that we can do search a very large directory using at most three
> disk reads (two levels of internal node, where each node can store up
> to 340 hashes plus pointers the next level of the tree, plus a
> directory leaf block).

Yes, I see. I'll do similar in my prj, perhaps adding one more level,
ie. 3 reads to locate an item among about 10 million items (as said
just a toy-fs for fun :-), plus 1 more read for the item itself.

>> In contrast to that here my idea: keep the hdr blocks (ie. where the
>> dir/file names are) always in a sorted order. Then a bsearch should be doable.
>> This would eliminate the need for any b*tree-db usage.
>
> The problem with using a binary search is (a) it's more expensive to
> search each disk read divides the search space in half (in contrast,
> in the best case using htree, the first disk read can divide the
> search space by factor of 340), and (b) insertions are very expensive;
> suppose you have a 400 megabyte directory, and you need to insert a
> filename into the very beginning of the list.  You will have to
> performance 800 megabytes of I/O to make room for directory entry, if
> you want to keep all of the directory entries sorted.

Yes, my initial idea to use bsearch leads to much more disk i/o.
Thx for the info.

-- 
cu
Uenal


