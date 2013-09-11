From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH v3 0/2] ext4: increase mbcache scalability
Date: Wed, 11 Sep 2013 11:49:43 -0500
Message-ID: <52309F27.8060008@redhat.com>
References: <1374108934-50550-1-git-send-email-tmac@hp.com> <1378312756-68597-1-git-send-email-tmac@hp.com> <20130905023522.GA21268@thunk.org> <52285395.1070508@hp.com> <0787C579-7E2C-4864-B8F4-98816E1E50A2@dilger.ca> <5229C939.8030108@hp.com> <62D71A85-C7EE-4F5F-B481-5329F0282044@dilger.ca> <20130910210250.GH29237@thunk.org> <522FDFCC.1070007@redhat.com> <20130911113001.GB13315@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger@dilger.ca>,
	Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>,
	T Makphaibulchoke <tmac@hp.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	"linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org Devel" <linux-fsdevel@vger.kernel.org>,
	aswin@hp.com, Linus Torvalds <torvalds@linux-foundation.org>,
	aswin_proj@lists.hp.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130911113001.GB13315@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 9/11/13 6:30 AM, Theodore Ts'o wrote:
> On Tue, Sep 10, 2013 at 10:13:16PM -0500, Eric Sandeen wrote:
>>
>> Above doesn't tell us the prevalence of various contexts on the actual system,
>> but they are all under 100 bytes in any case.
> 
> OK, so in other words, on your system i_file_acl and i_file_acl_high
> (which is where we store the block # for the external xattr block),
> should always be zero for all inodes, yes?

Oh, hum - ok, so that would have been the better thing to check (or at
least an additional thing).

# find / -xdev -exec filefrag -x {} \; | awk -F : '{print $NF}' | sort | uniq -c

Finds quite a lot that claim to have external blocks, but it seems broken:

# filefrag -xv /var/lib/yum/repos/x86_64/6Server/epel
Filesystem type is: ef53
File size of /var/lib/yum/repos/x86_64/6Server/epel is 4096 (1 block, blocksize 4096)
 ext logical physical expected length flags
   0       0 32212996252             100 not_aligned,inline
/var/lib/yum/repos/x86_64/6Server/epel: 1 extent found

So _filefrag_ says it has a block (at a 120T physical address not on my fs!)

And yet it's a small attr:

# getfattr -m - -d /var/lib/yum/repos/x86_64/6Server/epel
getfattr: Removing leading '/' from absolute path names
# file: var/lib/yum/repos/x86_64/6Server/epel
security.selinux="unconfined_u:object_r:rpm_var_lib_t:s0"

And debugfs thinks it's stored within the inode:

debugfs:  stat var/lib/yum/repos/x86_64/6Server/epel
Inode: 1968466   Type: directory    Mode:  0755   Flags: 0x80000
Generation: 2728788146    Version: 0x00000000:00000001
User:     0   Group:     0   Size: 4096
File ACL: 0    Directory ACL: 0
Links: 2   Blockcount: 8
Fragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x50b4d808:cb7dd9a8 -- Tue Nov 27 09:11:04 2012
 atime: 0x522fc8fa:62eb2d90 -- Tue Sep 10 20:35:54 2013
 mtime: 0x50b4d808:cb7dd9a8 -- Tue Nov 27 09:11:04 2012
crtime: 0x50b4d808:cb7dd9a8 -- Tue Nov 27 09:11:04 2012
Size of extra inode fields: 28
Extended attributes stored in inode body: 
  selinux = "unconfined_u:object_r:rpm_var_lib_t:s0\000" (39)
EXTENTS:
(0): 7873422

sooo seems like filefrag -x is buggy and can't be trusted.  :(

> Thavatchai, can you check to see whether or not this is true on your
> system?  You can use debugfs on the file system, and then use the
> "stat" command to sample various inodes in your system.  Or I can make
> a version of e2fsck which counts the number of inodes with external
> xattr blocks --- it sounds like this is something we should do anyway.
> 
> One difference might be that Eric ran this test on RHEL 6, and
> Thavatchai is using an upstream kernel, so maybe this is bloat has
> been added recently?

It's a userspace policy so the kernel shouldn't matter... "bloat" would
only come from new, longer contexts (outside the kernel).

> The reason why I'm pushing here is that mbcache shouldn't be showing
> up in the profiles at all if there is no external xattr block.  And so
> if newer versions of SELinux (like Adnreas, I've been burned by
> SELinux too many times in the past, so I don't use SELinux on any of
> my systems) is somehow causing mbcache to get triggered, we should
> figure this out and understand what's really going on.

selinux, from an fs allocation behavior perspective, is simply setxattr.

And as I showed earlier, name+value for all of the attrs set by at least RHEL6
selinux policy are well under 100 bytes.

(Add in a bunch of other non-selinux xattrs, and you'll go out of a 256b inode,
sure, but selinux on its own should not).

> Sigh, I suppose I should figure out how to create a minimal KVM setup
> which uses SELinux just so I can see what the heck is going on....

http://fedoraproject.org/en/get-fedora ;)

-Eric

>       	  	      	     	      	 - Ted
> 
