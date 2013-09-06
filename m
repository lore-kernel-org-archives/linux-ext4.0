From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v3 0/2] ext4: increase mbcache scalability
Date: Thu, 5 Sep 2013 23:10:31 -0600
Message-ID: <0787C579-7E2C-4864-B8F4-98816E1E50A2@dilger.ca>
References: <1374108934-50550-1-git-send-email-tmac@hp.com> <1378312756-68597-1-git-send-email-tmac@hp.com> <20130905023522.GA21268@thunk.org> <52285395.1070508@hp.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Theodore Ts'o <tytso@mit.edu>, T Makphaibulchoke <tmac@hp.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	"linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org Devel" <linux-fsdevel@vger.kernel.org>,
	aswin@hp.com, Linus Torvalds <torvalds@linux-foundation.org>,
	aswin_proj@groups.hp.com
To: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:45590 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730Ab3IFFKl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Sep 2013 01:10:41 -0400
Received: by mail-pb0-f41.google.com with SMTP id rp2so2743433pbb.14
        for <linux-ext4@vger.kernel.org>; Thu, 05 Sep 2013 22:10:41 -0700 (PDT)
In-Reply-To: <52285395.1070508@hp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2013-09-05, at 3:49 AM, Thavatchai Makphaibulchoke wrote:
> On 09/05/2013 02:35 AM, Theodore Ts'o wrote:
>> How did you gather these results?  The mbcache is only used if you
>> are using extended attributes, and only if the extended attributes don't fit in the inode's extra space.
>> 
>> I checked aim7, and it doesn't do any extended attribute operations.
>> So why are you seeing differences?  Are you doing something like
>> deliberately using 128 byte inodes (which is not the default inode
>> size), and then enabling SELinux, or some such?
> 
> No, I did not do anything special, including changing an inode's size. I just used the profile data, which indicated mb_cache module as one of the bottleneck.  Please see below for perf data from one of th new_fserver run, which also shows some mb_cache activities.
> 
> 
>                        |--3.51%-- __mb_cache_entry_find
>                        |          mb_cache_entry_find_first
>                        |          ext4_xattr_cache_find
>                        |          ext4_xattr_block_set
>                        |          ext4_xattr_set_handle
>                        |          ext4_initxattrs
>                        |          security_inode_init_security
>                        |          ext4_init_security

Looks like this is some large security xattr, or enough smaller
xattrs to exceed the ~120 bytes of in-inode xattr storage.  How
big is the SELinux xattr (assuming that is what it is)?

> Looks like it's a bit harder to disable mbcache than I thought.
> I ended up adding code to collect the statics.
> 
> With selinux enabled, for new_fserver workload of aim7, there
> are a total of 0x7e05420100000000 ext4_xattr_cache_find() calls
> that result in a hit and 0xc100000000000000 calls that are not.
> The number does not seem to favor the complete disabling of
> mbcache in this case.

This is about a 65% hit rate, which seems reasonable.

You could try a few different things here:
- disable selinux completely (boot with "selinux=0" on the kernel
  command line) and see how much faster it is
- format your ext4 filesystem with larger inodes (-I 512) and see
  if this is an improvement or not.  That depends on the size of
  the selinux xattrs and if they will fit into the extra 256 bytes
  of xattr space these larger inodes will give you.  The performance
  might also be worse, since there will be more data to read/write
  for each inode, but it would avoid seeking to the xattr blocks.

Cheers, Andreas





