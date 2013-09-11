From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3 0/2] ext4: increase mbcache scalability
Date: Wed, 11 Sep 2013 07:30:01 -0400
Message-ID: <20130911113001.GB13315@thunk.org>
References: <1374108934-50550-1-git-send-email-tmac@hp.com>
 <1378312756-68597-1-git-send-email-tmac@hp.com>
 <20130905023522.GA21268@thunk.org>
 <52285395.1070508@hp.com>
 <0787C579-7E2C-4864-B8F4-98816E1E50A2@dilger.ca>
 <5229C939.8030108@hp.com>
 <62D71A85-C7EE-4F5F-B481-5329F0282044@dilger.ca>
 <20130910210250.GH29237@thunk.org>
 <522FDFCC.1070007@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>,
	T Makphaibulchoke <tmac@hp.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	"linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org Devel" <linux-fsdevel@vger.kernel.org>,
	aswin@hp.com, Linus Torvalds <torvalds@linux-foundation.org>,
	aswin_proj@lists.hp.com
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <522FDFCC.1070007@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Sep 10, 2013 at 10:13:16PM -0500, Eric Sandeen wrote:
> 
> Above doesn't tell us the prevalence of various contexts on the actual system,
> but they are all under 100 bytes in any case.

OK, so in other words, on your system i_file_acl and i_file_acl_high
(which is where we store the block # for the external xattr block),
should always be zero for all inodes, yes?

Thavatchai, can you check to see whether or not this is true on your
system?  You can use debugfs on the file system, and then use the
"stat" command to sample various inodes in your system.  Or I can make
a version of e2fsck which counts the number of inodes with external
xattr blocks --- it sounds like this is something we should do anyway.

One difference might be that Eric ran this test on RHEL 6, and
Thavatchai is using an upstream kernel, so maybe this is bloat has
been added recently?

The reason why I'm pushing here is that mbcache shouldn't be showing
up in the profiles at all if there is no external xattr block.  And so
if newer versions of SELinux (like Adnreas, I've been burned by
SELinux too many times in the past, so I don't use SELinux on any of
my systems) is somehow causing mbcache to get triggered, we should
figure this out and understand what's really going on.

Sigh, I suppose I should figure out how to create a minimal KVM setup
which uses SELinux just so I can see what the heck is going on....

      	  	      	     	      	 - Ted
