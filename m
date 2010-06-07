From: Evgeniy Ivanov <lolkaantimat@gmail.com>
Subject: Re: ext2 and directory indexing
Date: Mon, 7 Jun 2010 18:10:24 +0400
Message-ID: <AANLkTikQksGJqFlZPUw0aZ87JyYh8w-DedfXyzCNvb9S@mail.gmail.com>
References: <AANLkTimPsiqmWPXYXmP6fODEJaS4GrU2y5nzhN9U5Cj3@mail.gmail.com>
	<20100607125634.GB13440@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55008 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046Ab0FGOK0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Jun 2010 10:10:26 -0400
Received: by fxm8 with SMTP id 8so2106213fxm.19
        for <linux-ext4@vger.kernel.org>; Mon, 07 Jun 2010 07:10:25 -0700 (PDT)
In-Reply-To: <20100607125634.GB13440@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 7, 2010 at 4:56 PM,  <tytso@mit.edu> wrote:
> On Sun, Jun 06, 2010 at 03:29:56PM +0400, Evgeniy Ivanov wrote:
>> Hello,
>>
>> I'm a bit confused by indexing and ext2. It looks like there is no
>> hash code in ext2, but ext2_fs.h has EXT2_INDEX_FL (most confusing),
>> EXT2_FEATURE_COMPAT_DIR_INDEX and some other HTree things, but
>> EXT2_INDEX_FL and EXT2_FEATURE_COMPAT_DIR_INDEX =A0are not used
>> anywhere.
>
> It's there, but in ext2 it was called EXT2_BTREE_FL (same bit
> position, different name), since we originally planned to implement i=
t
> using a BTREE. =A0We ultimately implemented directory indexing by
> storing the tree information inside what looks like deleted directory
> entries to ext2, but since we don't rebalance the trees on deletion,
> they're technically not b-trees. =A0We also hash the keys before stor=
ing
> them in the tree, which is why you'll sometimes see references to
> "hash tree", or "htree".

Thank you for explanation. I've looked into the code and it only
resets EXT2_BTREE_FL and that's all. Thus ext2 doesn't support
indexing, right? Unlike in ext2, in ext3 I see that you set/reset this
flag, check the feature, work with hashes.

>> I have ext2 partition created with mkfs.ext2 and when I check this
>> partition e2fsck converts some directories to the indexed format and
>> sets EXT2_INDEX_FL/EXT3_INDEX_FL. But since I failed grep any usage =
of
>> EXT2_INDEX_FL in fs/ext2 that code doesn't reset EXT2_INDEX_FL (some
>> time ago I was suggested to make my ext2 implementation to reset thi=
s
>> flag which looks correct for ext3, but not ext2). Is it expected
>> behavior of e2fsck?
>
> Yes, it's expected. =A0The fact that e2fsck is complaining and
> converting directories back to be indexed is because you didn't follo=
w
> my advice. =A0:-)

Oh, I followed :) It works fine now (the only confusing thing was
dir_index set by default for ext2 and converting directories).
I'm just wondering about what is ext2 and what is ext3.

> =A0Sorry for the EXT2_INDEX_FL vs. EXT2_BTREE_FL
> confusion; it's something that I suppose we should clean up, but my
> advice would have prevented e2fsck from complaining about corrupted
> directory and re-indexing the directories.

> I'm curious BTW --- for what operating system are you implementing
> this ext2 implementation?

It's for MINIX 3. There is working and tested ext2 server already, now
only Orlov block allocator and preallocation left. Probably directory
indexing depending on your answer, but ext3 is in the project's TODO
list anyway.


--=20
Evgeniy Ivanov
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
