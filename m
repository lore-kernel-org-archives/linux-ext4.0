From: Vegard Nossum <vegard.nossum@oracle.com>
Subject: Re: ext4: fix reference counting bug on block allocation error
Date: Sun, 14 Aug 2016 21:02:48 +0200
Message-ID: <57B0C058.9010800@oracle.com>
References: <20160727052921.5B41C35574@git2.kroah.org>
 <20160814183206.GA11040@kroah.com> <57B0BA84.1000600@oracle.com>
 <20160814185125.GA4077@kroah.com> <20160814185805.GA8087@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Greg KH <gregkh@linuxfoundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26751 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbcHNTC7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 14 Aug 2016 15:02:59 -0400
In-Reply-To: <20160814185805.GA8087@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/14/2016 08:58 PM, Greg KH wrote:
> On Sun, Aug 14, 2016 at 08:51:25PM +0200, Greg KH wrote:
>> On Sun, Aug 14, 2016 at 08:37:56PM +0200, Vegard Nossum wrote:
>>> On 08/14/2016 08:32 PM, Greg KH wrote:
>>>> Hi Vegard and ext4 developers,
>>>>
>>>> The patch below, in Linus's tree, references a patch in the Fixes: line
>>>> that is not in Linus's tree (neither the git commit id, nor the subject
>>>> line.)
>>>>
>>>
>>> It seems to exist?
>>>
>>>>> Fixes: 8556e8f3b6 ("ext4: Don't allow new groups to be added during block
>>> allocation")
>>>
>>> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=8556e8f3b6c4c11601ce1e9ea8090a6d8bd5daae
>>>
>>>> That's a bit confusing, what is this patch supposed to be fixing up?
>>>> What stable tree(s) should it go to if the original patch it fixes isn't
>>>> even in any tree?
>>>
>>> The referenced commit adds the ext4_mb_release_context(ac); line which
>>> is what is causing problems because that releases the context which is
>>> still in fact in use.
>>
>> Oh doh, sorry for the noise, I was only looking at 4.8-rc1 and older, my
>> fault.
>
> Hm, wait.  Commit 8556e8f3b6 didn't show up in my filters for some
> reason (which it not good, and makes me worry), but also, it doesn't
> apply to the stable trees at all.
>
> So can you please send backports of that commit, and this one, if you
> want them both queued up to any stable kernel tree?

The commit which is being fixed is ancient:

$ git describe 8556e8f3b6
v2.6.28-5758-g8556e8f3

It's probably already in the base of every current stable tree, no?


Vegard
