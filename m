From: Killian De Volder <killian.de.volder@scarlet.be>
Subject: Re: Recovery after mkfs.ext4 on a ext4
Date: Mon, 23 Jun 2014 20:34:51 +0200
Message-ID: <53A8734B.8030908@scarlet.be>
References: <539D555E.3050707@scarlet.be> <20140615132026.GC2180@thunk.org> <539E019C.6060600@scarlet.be> <20140615214403.GA1420@thunk.org> <53A7C4A1.4000603@scarlet.be> <20140623123758.GA14887@thunk.org> <53A857C0.3060401@scarlet.be> <20140623173151.GD14887@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:46610 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539AbaFWSf1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Jun 2014 14:35:27 -0400
In-Reply-To: <20140623173151.GD14887@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 23-06-14 19:31, Theodore Ts'o wrote:
> On Mon, Jun 23, 2014 at 06:37:20PM +0200, Killian De Volder wrote:
>> On 23-06-14 14:37, Theodore Ts'o wrote:
>>> On Mon, Jun 23, 2014 at 08:09:37AM +0200, Killian De Volder wrote:
>>>> It's still checking due to the high amount of ram it's using.
>>>> However if I start a parallel check with -nf if find other errors the one with the high memory usage hasn't found yet ?
>>> No, definitely not that!  Running two e2fsck's in parallel will do far
>>> more harm than good.
>> In parallel is a big word: the check repair is SOOO slow, it might as well been killed when the second (read-only) test is done.
>> I once has a OOM because of tomuch ZRAM allocated, after I restarted e2fsck, it found more error before going into massive ram-usage.
>> So I was wonder what would happen if I restarted it.
>>>> Should I start a new one, or is this not advised ?
>>>> As sometimes I think it's bad inodes causing artificial usage of memory.
>>> What part of the e2fsck run are you in?  If you are in passes
>>> 1b/1c/1d, then one of the things you can do is to analyze the log
>> Pass 1: Checking inodes, blocks, and sizes
>> Notthing else below this except things like:
>>
>> Too many illegal blocks in inode 488.
>> Clear inode<y>? yes
> Does it stop after one of these messages without displaying anything
> else?  Or does it just continue emitting a large number of these
> messages?  And is the time between each one getting longer and longer?
>
> We do actually keep a linked list of these inode numbers so we can try
> to report a directory name so you know which file has been trashed.
> This happens in pass #2, so the inodes which are invalid are stored in
> pass #1 and only removed in pass #2.  
>
> So if you are seeing gazillions of bad inodes, that could very easily
> be what's going on.  If so, I can imagine having some mode that we
> enter after a hundred inodes where we just ask permission to blow away
> all of the corrupted inodes in pass #1, without waiting until we can
> give you a proper pathname.
>
> The other possibility is that a particular indode is so badly
> corrupted that we're looping trying to evaluate a particular inode.
> That's why I'm asking if e2fsck is has just stopped and not printing
> any more messages, in what might be an apparent infinite loop.
>
> 						 - Ted
>
Yes, this is the output so far of this fsck attempt:

Pass 1: Checking inodes, blocks, and sizes

Inode 488 is too big.  Truncate<y>? yes
Block #563048161 (3717262637) causes file to be too big.  CLEARED.
Block #563048162 (3068047020) causes file to be too big.  CLEARED.
Block #563048163 (3476424287) causes file to be too big.  CLEARED.
Block #563048164 (301063316) causes file to be too big.  CLEARED.
Block #563048165 (12584754) causes file to be too big.  CLEARED.
Block #563048166 (528287744) causes file to be too big.  CLEARED.
Block #563048167 (2728512811) causes file to be too big.  CLEARED.
Block #563048168 (1152011501) causes file to be too big.  CLEARED.
Block #563048169 (692919630) causes file to be too big.  CLEARED.
Block #563048170 (3050472104) causes file to be too big.  CLEARED.
Block #563048171 (2888907055) causes file to be too big.  CLEARED.
Too many illegal blocks in inode 488.
Clear inode<y>? yes
Inode 435, i_size is 5006055699917260305, should be 0.  Fix<y>? yes
Inode 435, i_blocks is 190421251318606, should be 0.  Fix<y>? yes
Inode 407 has compression flag set on filesystem without compression support.  Clear<y>? yes

The first times I ran fsck it found quite a few (after which they crashed due to OOM, and other issues not related to fsck).
The following times it only  found 1 to 3 of these before starting to eat memory.
- Killian
