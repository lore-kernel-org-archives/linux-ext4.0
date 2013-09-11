From: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Subject: Re: [PATCH v3 0/2] ext4: increase mbcache scalability
Date: Wed, 11 Sep 2013 20:36:32 +0000
Message-ID: <5230D450.7000609@hp.com>
References: <52285395.1070508@hp.com> <0787C579-7E2C-4864-B8F4-98816E1E50A2@dilger.ca> <5229C939.8030108@hp.com> <62D71A85-C7EE-4F5F-B481-5329F0282044@dilger.ca> <20130910210250.GH29237@thunk.org> <522FDFCC.1070007@redhat.com> <20130911113001.GB13315@thunk.org> <52309F27.8060008@redhat.com> <alpine.DEB.2.02.1309111325270.5862@nftneq.ynat.uz> <5230D739.9010109@redhat.com> <20130911212523.GE13397@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: David Lang <david@lang.hm>, Andreas Dilger <adilger@dilger.ca>,
	T Makphaibulchoke <tmac@hp.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	"linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org Devel" <linux-fsdevel@vger.kernel.org>,
	aswin@hp.com, Linus Torvalds <torvalds@linux-foundation.org>,
	aswin_proj@lists.hp.com
To: Theodore Ts'o <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:19075 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab3ILCj3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Sep 2013 22:39:29 -0400
In-Reply-To: <20130911212523.GE13397@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 09/11/2013 09:25 PM, Theodore Ts'o wrote:
> On Wed, Sep 11, 2013 at 03:48:57PM -0500, Eric Sandeen wrote:
>>
>> So at this point I think it's up to Mak to figure out why on his system, aim7 is triggering mbcache codepaths.
>>
> 
> Yes, the next thing is to see if on his systems, whether or not he's
> seeing external xattr blocks.
> 
> 					- Ted
> 

I seem to be seeing the same thing as Eric is seeing.

On one of my systems,

# find / -mount -exec getfattr --only-values -m security.* {} 2>/dev/null \; | wc -c
2725655
# df -i /
Filesystem            Inodes   IUsed   IFree IUse% Mounted on
/dev/mapper/vg_dhg1-lv_root
[tmac@lxbuild linux]$ man find
                     1974272   84737 1889535    5% /
# find /home -mount -exec getfattr --only-values -m security.* {} 2>/dev/null \; | wc -c
274173
# df -i /home
Filesystem            Inodes   IUsed   IFree IUse% Mounted on
/dev/mapper/vg_dhg1-lv_home
                      192384    7862  184522    5% /home

For both filesystems, the security xattr are about 32.17 and 34.87 bytes respectively.

I also see a similar problem with filefrag.

# filefrag -xv /bin/sh
Filesystem type is: ef53
File size of /bin/sh is 938736 (230 blocks, blocksize 4096)
 ext logical physical expected length flags
   0       0 23622459548             100 not_aligned,inline
/bin/sh: 1 extent found
 
# getfattr -m - -d /bin/sh
getfattr: Removing leading '/' from absolute path names
# file: bin/sh
security.selinux="system_u:object_r:shell_exec_t:s0"

debugfs:  stat /bin/sh
Inode: 1441795   Type: symlink    Mode:  0777   Flags: 0x0
Generation: 3470616846    Version: 0x00000000:00000001
User:     0   Group:     0   Size: 4
File ACL: 0    Directory ACL: 0
Links: 1   Blockcount: 0
Fragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x50c2779d:ad792a58 -- Fri Dec  7 16:11:25 2012
 atime: 0x52311211:006d1658 -- Wed Sep 11 19:00:01 2013
 mtime: 0x50c2779d:ad792a58 -- Fri Dec  7 16:11:25 2012
crtime: 0x50c2779d:ad792a58 -- Fri Dec  7 16:11:25 2012
Size of extra inode fields: 28
Extended attributes stored in inode body: 
  selinux = "system_u:object_r:bin_t:s0\000" (27)
Fast_link_dest: bash

At this point, I'm not sure why we get into the mbcache path when SELinux is enabled.  As mentioned in one my earlier replies to Andreas, I did see actual calls into ext4_xattr_cache.

There seems to be one difference between 3.11 kernel and 2.6 kernel in set_inode_init_security(). There is an additional attempt to initialize evm xattr.  But I do not seem to be seeing any evm xattr in any file.

I will continue to try to find out how we get into the mbcache path.  Please let me know if anyone has any suggestion.

Thanks,
Mak.



