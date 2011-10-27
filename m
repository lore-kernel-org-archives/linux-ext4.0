From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: [PATCH V1 02/17] ext4: Add the basic function for inline data support.
Date: Thu, 27 Oct 2011 03:57:34 -0600
Message-ID: <42CED85D-7936-4D51-B405-787F65F0C10A@whamcloud.com>
References: <4EA7B788.3040503@tao.ma> <1319614468-11227-1-git-send-email-tm@tao.ma> <1319614468-11227-2-git-send-email-tm@tao.ma> <E38E92E9-2937-47BA-A9F4-B1F75C9FDE4A@dilger.ca> <4EA81B50.1060802@tao.ma> <DACDC44B-F60E-493E-9C15-67EDFCDFD34D@dilger.ca> <4EA8AB25.4030506@tao.ma>
Mime-Version: 1.0 (iPhone Mail 8L1)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"tytso@mit.edu" <tytso@mit.edu>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:46875 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443Ab1J0O3v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 27 Oct 2011 10:29:51 -0400
In-Reply-To: <4EA8AB25.4030506@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-10-26, at 6:51 PM, Tao Ma <tm@tao.ma> wrote:
> On 10/27/2011 06:28 AM, Andreas Dilger wrote:
>> On 2011-10-26, at 8:38 AM, Tao Ma wrote:
>>> On 10/26/2011 04:36 PM, Andreas Dilger wrote:
>>>> Since file data is changed very rarely, instead of consuming the full
>>>> xattr space that may not be needed, wouldn't it be better to change
>>>> ext4_write_inline_data() to just to the ext4_xattr_ibody_set() to save
>>>> the exact-sized buffer into the xattr?  That will allow other xattrs
>>>> to be stored in this space as well as the inline data.
>>> 
>>> I am just worried about the cpu usage. You know, the xattr values in
>>> ext4 has to be packed so if we change the content of an inline file
>>> frequently (say append), the inline xattr value will be removed and added

Given the small size of the space, it seems unlikely that apps would be growing the size of the file many times before it overflowed the inode xattr space, so I don't think this is a valid concern. I think such small files will normally be written once at the proper size, or if they are written repeatedly the offset will not change. 

>>> frequently which should consume much cpu cycles.  What's more, the other
>>> xattr values has to be moved also if they are not aligned to the end of
>>> the inode. I am not sure whether it is good for performance or not.
>> 
>> I'd also guess it isn't the most CPU efficient mechanism, but the main
>> question is whether this extra CPU usage is even noticeable compared
>> to the IO time?  Even with the added CPU usage, there is a dramatic
>> reduction in the IO (no external block to write), so it would always
>> be a net win to do it that way.

> It seems so. anyway, I will do some tests for file appending to see how
> much these 2 methods differs.

Great. 

>>> Another side effect is that we have to write the whole inline data every
>>> time as a new xattr value replace every time while the current solution
>>> just needs to memcpy the appended bytes.
>> 
>> What about only storing a new xattr if the file size is increasing, or
>> when it is truncated to zero?  If the write is <= existing xattr size
>> then it can use the same mechanism as today (inline overwrite of the
>> xattr buffer, and update of the xattr checksum).  That avoids overhead
>> for the case of repeatedly writing a small same-size value into the file.
>> If some application is appending 1 byte at a time to a file, I think
>> the CPU overhead in the xattr code is the least of their worries.
>> 
>> The main reason I don't like to consume all of the xattr space right
>> away is that this will cause OTHER xattrs to immediately be pushed
>> into the external xattr block (e.g. selinux, security, etc) and then
>> we will be even worse off than before (file data in inode, xattr in
>> external block, and added complexity for no benefit).

> To be honest, with inode size = 256, we don't have much spaces left in
> the inode. With current i_extra_isize 28, we have only 92 bytes left for
> xattrs(4 bytes for the xattr header magic and 4 bytes for the gap
> between ext4_xattr_entry and the value, 256 - 128 - 28 - 4 - 4). So
> considering one ext4_xattr_entry have 16 bytes and with the miminum
> namelen of 4, if we support 2 entries(one for inline data and one for a
> real xattr), these will take 40 bytes. And only 52 bytes are left. I
> don't think these bytes are enough for 2 xattr values. ;)

This is enough for an empty dir (24 bytes) and another 28 bytes for a security xattr. 

> So why not
> take all of them(72 bytes)? As for inode size > 256, the inline data
> will only takes half of the spaces left and leaves the space for other
> xattrs. Does it make sense?

No, because if ANY other xattr exists it will be pushed to an external block, and then if this data xattr grows (much more likely than the other xattr changing) it won't fit into the inode, and now performance is permanently worse than before. 

> btw, I have no idea of what a normal acl xattr takes, but if it takes
> more than 10 bytes, it will almost make the inline dir almost no use,
> since we have to store dot and dotdot first and then the real file
> names. Too small space isn't good but adds overhead of converting from
> inline to external block.

In our environment we use at least 512-byte inodes on the metadata server, but I still don't want half if that space wasted on this xattr if so much is not needed. 

Cheers, Andreas 