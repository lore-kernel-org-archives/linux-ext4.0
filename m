From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: [PATCH] FS: ext4: fix integer overflow in alloc_flex_gd()
Date: Tue, 21 Feb 2012 10:19:25 -0700
Message-ID: <F06E948D-CB59-4222-977A-EEE18BC02038@dilger.ca>
References: <1329777684-18396-1-git-send-email-haogangchen@gmail.com> <4F42DBA0.4090502@redhat.com> <0E72E3B2-DAA7-45F4-845D-AF4E76174A33@gmail.com> <4F43C825.1040501@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Xi Wang <xi.wang@gmail.com>, Haogang Chen <haogangchen@gmail.com>,
	Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:61929 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232Ab2BURT2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Feb 2012 12:19:28 -0500
In-Reply-To: <4F43C825.1040501@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-02-21, at 9:36 AM, Eric Sandeen wrote:
> On 02/21/2012 07:55 AM, Xi Wang wrote:
>> On Feb 20, 2012, at 6:47 PM, Eric Sandeen wrote:
>>> Hm this raises a few questions I think.
>>> 
>>> On the one hand, making sure the kmalloc arg doesn't overflow here is
>>> certainly a good thing and probably the right thing to do in the short term.
>>> 
>>> So I guess:
>>> 
>>> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
>>> 
>>> for that, to close the hole.
>> 
>> Another possibility is to wait for knalloc/kmalloc_array in the -mm
>> tree, which is basically the non-zeroing version of kcalloc that
>> performs overflow checking.
>> 
>>> Doesn't this also mean that a valid s_log_groups_per_flex (i.e. 31)
>>> will fail in this resize code?  That would be an unexpected outcome.
>>> 2^31 groups per flex is a little crazy, but still technically valid
>>> according to the limits in the code.
>> 
>> Or we could limit s_log_groups_per_flex/groups_per_flex to a
>> reasonable upper bound in ext4_fill_flex_info(), right?
> 
> Depends on the "flex_bg" design intent, I guess.
> 
> I don't know if the 2^31 was an intended design limit, or just a
> mathematical limit that based on container sizes etc...
> 
> I'd have to look at the resize code more carefully but I can't imagine
> that it's imperative to allocate this stuff all at once.

We previously tried to use a large flex_bg size to put all metadata into a
single group so it could easily be allocated on a separate SSD device, but
that didn't work very well.  Once the number of bitmaps in group 0 is more
than the number of free blocks in that group (below 16k groups, due to group
descriptors) then they need to overflow into group 1 and collide with the
group descriptors there.  Then mke2fs chokes, AFAIR.

It may be different with bigalloc, since the number of blocks in a group can
be very large, I haven't tried that.

In any case, I don't think anyone expects vmalloc(2^32 * struct size) to work,
but I wouldn't sweat fixing this until there is some real reason to do so.

Cheers, Andreas





