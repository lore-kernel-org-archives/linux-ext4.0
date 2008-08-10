From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Bug in delayed allocation: really bad block layouts!
Date: Sun, 10 Aug 2008 13:54:50 -0500
Message-ID: <489F397A.1040709@redhat.com>
References: <E1KSEkA-00009o-CV@closure.thunk.org> <489F2B38.3060104@redhat.com> <20080810182231.GB15353@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47209 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753291AbYHJSyy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Aug 2008 14:54:54 -0400
In-Reply-To: <20080810182231.GB15353@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Sun, Aug 10, 2008 at 12:54:00PM -0500, Eric Sandeen wrote:
>> Hm, and I tried writing out 10 files in order as a simple test but
>> umount/remount brought me back many 0-byte files, I need to update my
>> patchset I guess.  :)
>>
> 
> One of the questions in my mind is whether this is a regression
> triggered by the some of our most recent patches....  since I only
> have 2.2% files reported a fragmented by e2fsck, and if this problem
> had always been there, I would have expected a much higher
> fragmentation number.  So if you have some older kernels, you might
> want to see if you can replicate the problem.  I've since found that
> just doing a copy via "(tar -cf - -C / usr/include ) | tar -C /mnt -xf -)"
> is sufficient to see the problem.  Just add a "sync; sleep 5" before 
> the umount.  :-)

It may be; I tried this and then a quick filefrag run:

# filefrag  usr/include/*.h | grep -v extents | awk -F : '{print $2}' |
sort | uniq -c
    146  1 extent found

so everything came out contiguous.

This was with 2.6.27-0.186.rc0.git15.fc10.x86_64

-Eric
