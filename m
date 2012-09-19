From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: possible bug ?
Date: Wed, 19 Sep 2012 11:35:18 -0500
Message-ID: <5059F446.5010308@redhat.com>
References: <CAEG-z2-5=hYOZ+ZwUAE5ULQPJ2kjZ5WMv9EoTpx=c+Mik6_9ug@mail.gmail.com> <5059E12A.9000306@redhat.com> <20120919162600.GA21210@thunk.org> <5059F32D.10005@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Adrian Sandu <dexter@d3xt3r01.tk>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39498 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753093Ab2ISQfW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Sep 2012 12:35:22 -0400
In-Reply-To: <5059F32D.10005@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 9/19/12 11:30 AM, Eric Sandeen wrote:
> On 9/19/12 11:26 AM, Theodore Ts'o wrote:
>> On Wed, Sep 19, 2012 at 10:13:46AM -0500, Eric Sandeen wrote:
>>> On 9/19/12 9:44 AM, Adrian Sandu wrote:
>>>> Hi people,
>>>>
>>>> While trying to delete a couple of files today, I got into this lil'
>>>> thingy. It first happened in mc, then at a reboot.
>>>
>>> Did you cut off a few lines before this?  Like one that said NULL pointer
>>> dereference, or BUG() at .... or something similar?
>>>
>>> I think we have a few reports of this in the fedora bugzilla, I don't
>>> think we've gotten to the bottom of it yet.
>>
>> The fix is in mainline, and backported to v3.5.3.  If Fedora's kernel
>> hasn't been updated to v3.5.3, it would be great if you could
>> encourage an update to get pushed out.
> 
> Hm I thought we had a similar bug on 3.5.3 so didn't think
> it was fixed.   let me check ... Nope sorry, it was older.
> 
> Thanks for the info, sorry I had missed it.

Actually argh, too many bugs.  ;)  I was thinking of 
https://bugzilla.redhat.com/show_bug.cgi?id=857618

which has been reported a few times, and hits a BUG() in 

1965 ext4_ext_put_in_cache(struct inode *inode, ext4_lblk_t block,
1966                         __u32 len, ext4_fsblk_t start)
1967 {
1968         struct ext4_ext_cache *cex;
1969         BUG_ON(len == 0);

but that's not what this reporter sees, sorry for the noise.

(Lukas pointed at upstream commit 31d4f3a2f3c73f279ff96a7135d7202ef6833f12
to avoid the BUG_ON but we still don't know the root cause I think).

Anyway, now I'm OT for this thread.

-Eric
