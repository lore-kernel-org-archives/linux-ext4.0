From: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Subject: Re: [PATCH v3 0/2] ext4: increase mbcache scalability
Date: Thu, 05 Sep 2013 15:22:19 +0000
Message-ID: <5228A1AB.2030308@hp.com>
References: <1374108934-50550-1-git-send-email-tmac@hp.com> <1378312756-68597-1-git-send-email-tmac@hp.com> <FDD6EB21-7C40-4F4D-904C-8514535CC7C3@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: T Makphaibulchoke <tmac@hp.com>, Theodore Ts'o <tytso@mit.edu>,
	Al Viro <viro@zeniv.linux.org.uk>,
	"linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org Devel" <linux-fsdevel@vger.kernel.org>,
	aswin@hp.com, Linus Torvalds <torvalds@linux-foundation.org>,
	aswin_proj@groups.hp.com
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <FDD6EB21-7C40-4F4D-904C-8514535CC7C3@dilger.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 09/04/2013 08:00 PM, Andreas Dilger wrote:
> 
> In the past, I've raised the question of whether mbcache is even
> useful on real-world systems.  Essentially, this is providing a
> "deduplication" service for ext2/3/4 xattr blocks that are identical.
> The question is how often this is actually the case in modern use?
> The original design was for allowing external ACL blocks to be
> shared between inodes, at a time when ACLs where pretty much the
> only xattrs stored on inodes.
> 
> The question now is whether there are common uses where all of the
> xattrs stored on multiple inodes are identical?  If that is not the
> case, mbcache is just adding overhead and should just be disabled
> entirely instead of just adding less overhead.
> 
> There aren't good statistics on the hit rate for mbcache, but it
> might be possible to generate some with systemtap or similar to
> see how often ext4_xattr_cache_find() returns NULL vs. non-NULL.
> 
> Cheers, Andreas
> 

Looks like it's a bit harder to disable mbcache than I thought. I ended up adding code to collect the statics.

With selinux enabled, for new_fserver workload of aim7, there are a total of 0x7e05420100000000 ext4_xattr_cache_find() calls that result in a hit and 0xc100000000000000 calls that are not.  The number does not seem to favor the complete disabling of mbcache in this case.

Thanks,
Mak.
