From: Evgeniy Ivanov <lolkaantimat@gmail.com>
Subject: Re: Question about e2fsck and HTree
Date: Mon, 26 Apr 2010 02:10:08 +0400
Message-ID: <o2ne1e08eb01004251510h64d7915arb977d7d9a77959d7@mail.gmail.com>
References: <z2ne1e08eb01004221243m89a97acei72316abe62daaba@mail.gmail.com>
	 <20100424004544.GM14986@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53689 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018Ab0DYWKJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 25 Apr 2010 18:10:09 -0400
Received: by gyg13 with SMTP id 13so6017818gyg.19
        for <linux-ext4@vger.kernel.org>; Sun, 25 Apr 2010 15:10:08 -0700 (PDT)
In-Reply-To: <20100424004544.GM14986@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Apr 24, 2010 at 4:45 AM,  <tytso@mit.edu> wrote:
> On Thu, Apr 22, 2010 at 11:43:30PM +0400, Evgeniy Ivanov wrote:
>> Hello,
>>
>> I have a question about ext2/ext3.
>>
>> As I understand directory indexing is compatible feature, currently =
my
>> implementations doesn't support HTree.
>> I do some things (make kernel and libs) with FS and check it with
>> e2fsck: it creates index (everything else is ok, exit status is 1).
>> Then I do same things with FS and check again:
>>
>> HTree directory inode 23316 has an invalid root node.
>>
>> Is it OK for implementation without directory indexing?
>
> If your implementation of extN don't support HTree, then it's
> important that when you modify a filesystem you clear the inode's
> EXT2_INDEX_FL flag. =A0 Then the right thing will happen....

Thank you very much again :)



--=20
Evgeniy Ivanov
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
