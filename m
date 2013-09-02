From: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>
Subject: Re: Which features should I implement in my ext4 reader?
Date: Mon, 2 Sep 2013 14:35:31 +0200
Message-ID: <CACyNnZNQf6a05zE64KfouuT=dUXaNPT7iqPe8HKT1wXKz+pK0Q@mail.gmail.com>
References: <CACyNnZManY_k3SB1-p4mQ8Z1+9B=VAdfXU7bWsFVHDsHV6KyUQ@mail.gmail.com>
	<20130817130204.GA30769@thunk.org>
	<CACyNnZONOUy0+OeDriZaSt4OQrR6LzpyJz4Sj8XvMHvxr2u_Xg@mail.gmail.com>
	<20130819050803.GA10882@gmail.com>
	<CACyNnZN4z_mHq86+FPOaGpzjwBVmmsKNjnd45s53o2LdQjxEsg@mail.gmail.com>
	<20130820103956.GA7846@gmail.com>
	<CACyNnZP6m96Uv_acbVvf3K2UvcMhhqk2S2gmdZS9DG9GwqbUcg@mail.gmail.com>
	<CACyNnZP2SFovG9YeBNeifm4KqrCzi7FU97CWVUjST0YQiqt3pQ@mail.gmail.com>
	<CACyNnZOXOZ-uL+TO8HOuO4DoWsBKuBOX5RLQrZzyoeG1L2a9yg@mail.gmail.com>
	<CACyNnZNhrmcpQRU+JcqSJeUYt3YNpyTyVArW_Jrp3e43owVf5Q@mail.gmail.com>
	<20130902120718.GB1106@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:47934 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758083Ab3IBMfc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Sep 2013 08:35:32 -0400
Received: by mail-pb0-f54.google.com with SMTP id ro12so4730145pbb.27
        for <linux-ext4@vger.kernel.org>; Mon, 02 Sep 2013 05:35:31 -0700 (PDT)
In-Reply-To: <20130902120718.GB1106@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

Ok, I think I got it almost finished =) Just 1 last wierd thing. I
dumped my inode and I found that when the extended attribute is in the
space after the inode, then the attribute data starts 3 bytes before
the end of this area! But in the wiki nothing is said about this. It
was supposed to start at the end of the section ... not 3 bytes before
the end of the section

Here are the 3 zeroes in the end:

7760 4444 4444 4444 4444 4444 4444 0a00 0000 DDDDDDDDDDDD....

Any idea what are those 3 zeroes in the end? I simply hardcoded in my
application that there exists 3 zeroes in the end, but its really
strange as this does not make any sense to waste 3 bytes and I didn't
see any such a thing in the wiki nor the xattr.h header...

Also wierd: This 3 last bytes do no appear when extended attributes
are stored in a separate block.

Full set of dumps:

debugfs: stat smallfile120.txt
Inode: 16 Type: regular Mode: 0644 Flags: 0x10000000
Generation: 230499867 Version: 0x00000000:00000001
User: 0 Group: 0 Size: 121
File ACL: 0 Directory ACL: 0
Links: 1 Blockcount: 0
Fragment: Address: 0 Number: 0 Size: 0
 ctime: 0x52149464:04e2df1c -- Wed Aug 21 06:20:20 2013
 atime: 0x52177658:c0a4e548 -- Fri Aug 23 10:48:56 2013
 mtime: 0x52149464:04e2df1c -- Wed Aug 21 06:20:20 2013
crtime: 0x52149464:04e2df1c -- Wed Aug 21 06:20:20 2013
Size of extra inode fields: 28
Extended attributes stored in inode body:
  data = "CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD\012" (61)
INLINE DATA:
  The size of inline data: 121

More detailed information about the file with extended attribute:

debugfs: imap smallfile120.txt
Inode 16 is part of block group 0
        located at block 65, offset 0x0f00

So we know that it is located in the block 0000065 with offset 0x0f00
= 0740 octal

debugfs: block_dump 65
.....
*
7400 a481 0000 7900 0000 5876 1752 6494 1452 ....y...Xv.Rd..R
7420 6494 1452 0000 0000 0000 0100 0000 0000 d..R............
7440 0000 0010 0100 0000 4141 4141 4141 4141 ........AAAAAAAA
7460 4141 4141 4141 4141 4141 4141 4141 4141 AAAAAAAAAAAAAAAA
7500 4141 4141 4141 4242 4242 4242 4242 4242 AAAAAABBBBBBBBBB
7520 4242 4242 4242 4242 4242 4242 4242 4242 BBBBBBBBBBBBBBBB
7540 4242 4242 1b26 bd0d 0000 0000 0000 0000 BBBB.&..........
7560 0000 0000 0000 0000 0000 0000 0000 0000 ................
7600 1c00 0000 1cdf e204 1cdf e204 48e5 a4c0 ............H...
7620 6494 1452 1cdf e204 0000 0000 0000 02ea d..R............
7640 0407 2000 0000 0000 3d00 0000 0000 0000 .. .....=.......
7660 6461 7461 0000 0000 0000 0000 0000 0000 data............
7700 4343 4343 4343 4343 4343 4343 4343 4343 CCCCCCCCCCCCCCCC
7720 4343 4343 4343 4343 4343 4343 4343 4444 CCCCCCCCCCCCCCDD
7740 4444 4444 4444 4444 4444 4444 4444 4444 DDDDDDDDDDDDDDDD
7760 4444 4444 4444 4444 4444 4444 0a00 0000 DDDDDDDDDDDD....

And thats how I got to this place.

thanks,

Felipe Monteiro de Carvalho

On Mon, Sep 2, 2013 at 2:07 PM, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
> Hello,
>
> Sorry for my late reply.
>
> On Mon, Sep 02, 2013 at 11:40:15AM +0200, Felipe Monteiro de Carvalho wrote:
>> Hello,
>>
>> Ok, I found the extra data over 60 bytes ... it is in an extended
>> attribute called "data" in the space after the inode. The wiki says it
>> should be called "system.data" =(
>>
>> Also the wiki says here
>> https://ext4.wiki.kernel.org/index.php/Ext4_Disk_Layout#Extended_Attributes
>> that "Extended attributes, when >>>not<<<< stored after the inode,
>> have a header ext4_xattr_ibody_header that is 4 bytes long:"
>>
>> Which in my oppinion is false, it should be: "Extended attributes,
>> when stored after the inode, have a header ext4_xattr_ibody_header
>> that is 4 bytes long:"  without the "not"
>>
>> But I still am not sure of one thing: How can I know how many entries
>> of extended attributes there are? Nothing in the wiki explains this =(
>
> You need to traverse the all entries to get this value.
>
>>
>> Otherwise I cannot differentiate between yet another entry and simply
>> data from an extended attribute...
>
> You can use attribute name and name index to differentiate these
> entries.  You can read the comment at the front of fs/ext4/xattr.c and
> it might help you to understand extended attribute.
>
> Regards,
>                                                 - Zheng



-- 
Felipe Monteiro de Carvalho
