From: supersud501 <supersud501@yahoo.de>
Subject: Re: frequent kernel bugs with 2.6.26-gentoo-r1
Date: Sun, 17 Aug 2008 19:52:22 +0200
Message-ID: <48A86556.5030205@yahoo.de>
References: <609868.63309.qm@web25408.mail.ukl.yahoo.com> <48A76992.7090709@redhat.com> <20080817121123.GD8774@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from n8b.bullet.sp1.yahoo.com ([69.147.64.169]:39544 "HELO
	n8b.bullet.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751593AbYHQSAu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Aug 2008 14:00:50 -0400
In-Reply-To: <20080817121123.GD8774@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:

> You don't have to use debugfs to set "ssv flags 4" anymore.  If you
> are converting an existing ext3 filesystem, "tune2fs -E test_fs -O
> extents /dev/sdXXX" works just fine.  Please see:
> 
> 	http://ext4.wiki.kernel.org/index.php/Ext4_Howto

allright, didn't know that address before - i'll check it out


>>> [  830.270166] ------------[ cut here ]------------
>>> [  830.270166] kernel BUG at fs/ext4/inode.c:1561!
>>> [  830.270166] invalid opcode: 0000 [1] PREEMPT SMP
>>
>> <lazy>can you correlate to where this is in the 2.6.26.2 kernel?</lazy>
> 
> I'm guessing that it's this BUG_ON in ext4_da_release_space:
> 
>     BUG_ON(mdb > EXT4_I(inode)->i_reserved_meta_blocks);
> 
> which was addressed by fix-delalloc-release-block-reservation-for-truncate
> in the ex4 patch queue.  
> 
> The only thing which is funny is that if this is true, this bug has
> only hit ext3 filesysem that had been converted to ext4 --- and
> Markus, you said you have hit errors on a filesystem that was freshly
> created using mkfs.ext4dev?

i think i wasn't clear enough in my last mail - i tested on both types,
fresh formated and existing ones. i think the error happened on a
converted ext3-drive, so no need to worry.

> 
> Ah....  I think I know, #1 are you using e2fsprogs 1.41.0, and #2,
> I'll bet you compiled from source and didn't install the new
> mke2fs.conf file that comes with e2fsprogs 1.41.0.  It is critically
> important that mke2fs for 1.41.0 use the mke2fs.conf file that is
> shipped with e2fsprogs 1.41.0 as a starting point.  If you don't, and
> you use the old mke2fs.conf from previous releases, mkfs.ext4dev won't
> actually enable extents, so you don't get the benefits of ext4, and
> the bugs trigger when you delete non-extent files when the filesystem
> is mounted using ext4dev.

you're right with #1, but i'm using the new mke2fs.conf. but as i wrote
above, the error happened on an ex3-converted drive. nevertheless thanks
for looking into my problem.

> 
> In any case, the two patches that you want are:
> 
> 	ext4-fix-no-extent-truncate-i_prealloc-bug
> 	fix-delalloc-release-block-reservation-for-truncate

i applied them already after reading eric's mail - and no problems so
far! thanks.

> in the ext4 patch queue[1], or just wait a few days and I'll get a
> patchset out versus 2.6.26 quickly.  It would be sooner, but there are
> few other patches I'm hoping we can stablize, and I'm currently at a
> family reunion in Baltimore for the next few days, so I don't know how
> much ext4 hacking time I'll have.

no need to hurry, at least not for me, it works now!


i must say your and eric's support is really great - like last time you
helped me very fast. thanks for it. so i'll try out using ext4 now as my
primary filesystem (let's see when i run into the next kernel bug ;) )

regards,
Markus

