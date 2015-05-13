From: "U.Mutlu" <for-gmane@mutluit.com>
Subject: Re: Htree concept
Date: Wed, 13 May 2015 19:37:36 +0200
Message-ID: <mj0250$tvl$1@ger.gmane.org>
References: <mivr40$2lj$1@ger.gmane.org> <55537BF7.8000602@redhat.com>
 <mj019e$f8f$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35975 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933578AbbEMRhw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 May 2015 13:37:52 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1YsabO-0007bM-9X
	for linux-ext4@vger.kernel.org; Wed, 13 May 2015 19:37:50 +0200
Received: from ip4d14ab60.dynamic.kabel-deutschland.de ([77.20.171.96])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Wed, 13 May 2015 19:37:50 +0200
Received: from for-gmane by ip4d14ab60.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Wed, 13 May 2015 19:37:50 +0200
In-Reply-To: <mj019e$f8f$1@ger.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

U.Mutlu wrote on 05/13/2015 07:22 PM:
> Eric Sandeen wrote on 05/13/2015 06:29 PM:
>> On 5/13/15 10:37 AM, U.Mutlu wrote:
>>> Hi,
>>> I'm writing a toy-fs, and discover a major shortcoming
>>> (finding a given child (dir/file) as fast as possible),
>>> which other developers (ie. ext3/4) had encountered long ago too.
>>> They introduced HTree. The info on HTree on the web is scarce
>>> or I couldn't find the right texts/papers yet.
>>> I wonder how HTree works on a conceptual basis.
>>> Could a kind soul enligten me pls. TIA.
>>
>> Regarding htree details, did you look at:
>>
>> http://en.wikipedia.org/wiki/HTree
>>
>> which points to:
>>
>> http://ext2.sourceforge.net/2005-ols/paper-html/node3.html
>> and more specifically,
>> http://web.archive.org/web/20131203105316/http://www.linuxshowcase.org/2001/full_papers/phillips/phillips_html/index.html
>>
>>
>> ?
>
> Thanks, the wiki page and its refs I knew, but needed some more info.
>
> Ok, it is written that HTree uses 32bit (or 64?) hashes for keys.
> I wonder if it wouldn't be better if one instead would use that space
> (32/64 bit) for storing the first n chars of the key (ie. of the dir/file name)
> and keeping the directory entries in a sorted order on the disk,
> and then do a bsearch instead of doing sequential table lookup using HTree?
> I wonder what the "Tree"-part of HTree stand for in this context.
> Am I right in my assumption that HTree mainly means the hashing mechanism,
> but does not use any binary search mechanism for searching the key?

Addendum:
I think I slowly grasp how HTree works: it keeps a (rb/avl tree)
b*tree-db (I guess it stores it on disk) of the hashes (as keys).

In contrast to that here my idea: keep the hdr blocks (ie. where the
dir/file names are) always in a sorted order. Then a bsearch should be doable.
This would eliminate the need for any b*tree-db usage.

-- 
cu
Uenal


