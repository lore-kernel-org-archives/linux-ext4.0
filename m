From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH v3 0/2] ext4: increase mbcache scalability
Date: Wed, 11 Sep 2013 15:48:57 -0500
Message-ID: <5230D739.9010109@redhat.com>
References: <1374108934-50550-1-git-send-email-tmac@hp.com> <1378312756-68597-1-git-send-email-tmac@hp.com> <20130905023522.GA21268@thunk.org> <52285395.1070508@hp.com> <0787C579-7E2C-4864-B8F4-98816E1E50A2@dilger.ca> <5229C939.8030108@hp.com> <62D71A85-C7EE-4F5F-B481-5329F0282044@dilger.ca> <20130910210250.GH29237@thunk.org> <522FDFCC.1070007@redhat.com> <20130911113001.GB13315@thunk.org> <52309F27.8060008@redhat.com> <alpine.DEB.2.02.1309111325270.5862@nftneq.ynat.uz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger@dilger.ca>,
	Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>,
	T Makphaibulchoke <tmac@hp.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	"linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org Devel" <linux-fsdevel@vger.kernel.org>,
	aswin@hp.com, Linus Torvalds <torvalds@linux-foundation.org>,
	aswin_proj@lists.hp.com
To: David Lang <david@lang.hm>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1309111325270.5862@nftneq.ynat.uz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 9/11/13 3:32 PM, David Lang wrote:
> On Wed, 11 Sep 2013, Eric Sandeen wrote:
> 
>>> The reason why I'm pushing here is that mbcache shouldn't be showing
>>> up in the profiles at all if there is no external xattr block.  And so
>>> if newer versions of SELinux (like Adnreas, I've been burned by
>>> SELinux too many times in the past, so I don't use SELinux on any of
>>> my systems) is somehow causing mbcache to get triggered, we should
>>> figure this out and understand what's really going on.
>>
>> selinux, from an fs allocation behavior perspective, is simply setxattr.
> 
> what you are missing is that Ted is saying that unless you are using xattrs, the mbcache should not show up at all.
> 
> The fact that you are using SElinux, and SELinux sets the xattrs is
> what makes this show up on your system, but other people who don't
> use SELinux (and so don't have any xattrs set) don't see the same
> bottleneck.

Sure, I understand that quite well.  But Ted was also saying that perhaps selinux had "gotten piggy" and was causing this.  I've showed that it hasn't.


This matters because unless the selinux xattrs go out of the inode into their own block, mbcache should STILL not come into it at all.

And for attrs < 100 bytes, they stay in the inode.  And on inspection, my SELinux boxes have no external attr blocks allocated.

mbcache only handles extended attributes that live in separately-allocated blocks, and selinux does not cause that on its own.

Soo... selinux by itself should not be triggering any mbcache codepaths.

Ted suggested that "selinux had gotten piggy" so I checked, and showed that it hadn't.  That's all.

So at this point I think it's up to Mak to figure out why on his system, aim7 is triggering mbcache codepaths.

-Eric

> David Lang
