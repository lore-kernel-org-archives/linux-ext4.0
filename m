From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: buggy readdir with inline dirs
Date: Sat, 23 Mar 2013 10:28:05 -0700
Message-ID: <587B312D-DED3-4251-B6C9-46DB40E27D60@dilger.ca>
References: <20130322182608.GT10038@lenny.home.zabbo.net> <514DAD11.1010709@tao.ma>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Zach Brown <zab@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Eric Sandeen <sandeen@redhat.com>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f42.google.com ([209.85.210.42]:54423 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab3CWRfL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 23 Mar 2013 13:35:11 -0400
Received: by mail-da0-f42.google.com with SMTP id n15so2666674dad.15
        for <linux-ext4@vger.kernel.org>; Sat, 23 Mar 2013 10:35:10 -0700 (PDT)
In-Reply-To: <514DAD11.1010709@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2013-03-23, at 6:24, Tao Ma <tm@tao.ma> wrote:
> On 03/23/2013 02:26 AM, Zach Brown wrote:
>> I don't remember quite how, but I found myself flipping through the
>> inline dir code that's in mainline now.  It looked pretty fishy so Eric
>> and I played around with it.  It's very buggy in its current form.
> Sorry about any inconvenience brought to you.
>> 
>> ext4_read_inline_dir() doesn't seem to undertand the filldir arguments.
>> It suggests that offset 0 is the next offset after both the "." and ".."
>> entries.  It needs to have specific offsets for "." and ".." and return them
>> accordingly.  It looks like fixing this will trickle down into the
>> revalidation loop.
> yes, it is my fault, I guess at the very first beginning,  I just can't
> figured out how to return a proper 'offset' to the user to indicate
> '..'. Now we don't save anything about '.', so offset 0 is OK for it,
> but maybe we should return some offset like '2' to the user about it.
> Anyway it should be fixed.

FYI, ZFS (which generates "." and ".." entries on-the-fly also) uses "0" for start of readdir, "1" for ".", and "2" for "..".

Cheers, Andreas 

>> It doesn't understand that it's possible to only return a single "."
>> entry in getdents and have a subsequent call have f_pos pointing at the
>> fake ".." entry.  With the current code if your getdents buffer only has
>> room for "." it just spins returning that entry leaving f_pos at 0.
> Sorry.
>> 
>> Those are all relatively simple bugs that just need to be fixed.
>> 
>> But the big bug is that it changes the d_off values for entries as it
>> converts from byte offsets in the inline dir xattr to hashed offsets in
>> indexed dir leaves.  A concurrent readdir could be unlucky enough to get
>> a bunch of duplicate entries as it reads past the nice low inline byte
>> offsets into the huge hashed offsets.
>> 
>> I'm not sure how to easily fix that.  It feels like it'd want to
>> maintain the dir entries in the xattr blob with the offsets that they'll
>> have once converted to full dir blocks.  So instead of being a magical
>> readdir path maybe it wants to be in the path of looking up dir blocks
>> so existing unindexed and indexed code would operate on the data in the
>> xattr blob as though it were a block?
>> 
>> Dunno, just wanted to share what we found.  Are these all known problems
>> in prototype code that isn't intended to be used?
> I will check what xfs does in this case as Dave mentioned in another
> reply and come back with a fix about it.
> 
> Thanks,
> Tao
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
