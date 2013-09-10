From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v3 0/2] ext4: increase mbcache scalability
Date: Tue, 10 Sep 2013 14:47:33 -0600
Message-ID: <62D71A85-C7EE-4F5F-B481-5329F0282044@dilger.ca>
References: <1374108934-50550-1-git-send-email-tmac@hp.com> <1378312756-68597-1-git-send-email-tmac@hp.com> <20130905023522.GA21268@thunk.org> <52285395.1070508@hp.com> <0787C579-7E2C-4864-B8F4-98816E1E50A2@dilger.ca> <5229C939.8030108@hp.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Theodore Ts'o <tytso@mit.edu>, T Makphaibulchoke <tmac@hp.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	"linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org Devel" <linux-fsdevel@vger.kernel.org>,
	aswin@hp.com, Linus Torvalds <torvalds@linux-foundation.org>,
	aswin_proj@lists.hp.com
To: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5229C939.8030108@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 2013-09-06, at 6:23 AM, Thavatchai Makphaibulchoke wrote:
> On 09/06/2013 05:10 AM, Andreas Dilger wrote:
>> On 2013-09-05, at 3:49 AM, Thavatchai Makphaibulchoke wrote:
>>> No, I did not do anything special, including changing an inode's size. I just used the profile data, which indicated mb_cache module as one of the bottleneck.  Please see below for perf data from one of th new_fserver run, which also shows some mb_cache activities.
>>> 
>>> 
>>>                       |--3.51%-- __mb_cache_entry_find
>>>                       |          mb_cache_entry_find_first
>>>                       |          ext4_xattr_cache_find
>>>                       |          ext4_xattr_block_set
>>>                       |          ext4_xattr_set_handle
>>>                       |          ext4_initxattrs
>>>                       |          security_inode_init_security
>>>                       |          ext4_init_security
>> 
>> Looks like this is some large security xattr, or enough smaller
>> xattrs to exceed the ~120 bytes of in-inode xattr storage.  How
>> big is the SELinux xattr (assuming that is what it is)?
>> 
>> You could try a few different things here:
>> - disable selinux completely (boot with "selinux=0" on the kernel
>>  command line) and see how much faster it is

> Sorry I'm

not?

> familiar with SELinux enough to say how big its xattr is. Anyway, I'm positive that SELinux is what is generating these xattrs.  With SELinux disabled, there seems to be no call ext4_xattr_cache_find().

What is the relative performance of your benchmark with SELinux disabled?
While the oprofile graphs will be of passing interest to see that the
mbcache overhead is gone, they will not show the reduction in disk IO
from not writing/updating the external xattr blocks at all.

>> - format your ext4 filesystem with larger inodes (-I 512) and see
>>  if this is an improvement or not.  That depends on the size of
>>  the selinux xattrs and if they will fit into the extra 256 bytes
>>  of xattr space these larger inodes will give you.  The performance
>>  might also be worse, since there will be more data to read/write
>>  for each inode, but it would avoid seeking to the xattr blocks.
> 
> Thanks for the above suggestions. Could you please clarify if we are
> attempting to look for a workaround here? Since we agree the way
> mb_cache uses one global spinlock is incorrect and SELinux exposes
> the problem (which is not uncommon with Enterprise installations),
> I believe we should look at fixing it (patch 1/2). As you also
> mentioned, this will also impact both ext2 and ext3 filesystems.

I agree that SELinux is enabled on enterprise distributions by default,
but I'm also interested to know how much overhead this imposes.  I would
expect that writing large external xattrs for each file would have quite
a significant performance overhead that should not be ignored.  Reducing
the mbcache overhead is good, but eliminating it entirely is better.

Depending on how much overhead SELinux has, it might be important to
spend more time to optimize it (not just the mbcache part), or users
may consider disabling SELinux entirely on systems where they care
about peak performance.

> Anyway, please let me know if you still think any of the above
> experiments is relevant.

You have already done one of the tests that I'm interested in (the above
test which showed that disabling SELinux removed the mbcache overhead).
What I'm interested in is the actual performance (or relative performance
if you are not allowed to publish the actual numbers) of your AIM7
benchmark between SELinux enabled and SELinux disabled.

Next would be a new test that has SELinux enabled, but formatting the
filesystem with 512-byte inodes instead of the ext4 default of 256-byte
inodes.  If this makes a significant improvement, it would potentially
mean users and the upstream distros should use different formatting
options along with SELinux.  This is less clearly a win, since I don't
know enough details of how SELinux uses xattrs (I always disable it,
so I don't have any systems to check).

Cheers, Andreas
