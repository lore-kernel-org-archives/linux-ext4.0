From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3 0/2] ext4: increase mbcache scalability
Date: Tue, 10 Sep 2013 17:02:50 -0400
Message-ID: <20130910210250.GH29237@thunk.org>
References: <1374108934-50550-1-git-send-email-tmac@hp.com>
 <1378312756-68597-1-git-send-email-tmac@hp.com>
 <20130905023522.GA21268@thunk.org>
 <52285395.1070508@hp.com>
 <0787C579-7E2C-4864-B8F4-98816E1E50A2@dilger.ca>
 <5229C939.8030108@hp.com>
 <62D71A85-C7EE-4F5F-B481-5329F0282044@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>,
	T Makphaibulchoke <tmac@hp.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	"linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org Devel" <linux-fsdevel@vger.kernel.org>,
	aswin@hp.com, Linus Torvalds <torvalds@linux-foundation.org>,
	aswin_proj@lists.hp.com
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <62D71A85-C7EE-4F5F-B481-5329F0282044@dilger.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Sep 10, 2013 at 02:47:33PM -0600, Andreas Dilger wrote:
> I agree that SELinux is enabled on enterprise distributions by default,
> but I'm also interested to know how much overhead this imposes.  I would
> expect that writing large external xattrs for each file would have quite
> a significant performance overhead that should not be ignored.  Reducing
> the mbcache overhead is good, but eliminating it entirely is better.

I was under the impression that using a 256 byte inode (which gives a
bit over 100 bytes worth of xattr space) was plenty for SELinux.  If
it turns out that SELinux's use of xattrs have gotten especially
piggy, then we may need to revisit the recommended inode size for
those systems who insist on using SELinux...  even if we eliminate the
overhead associated with mbcache, the fact that files are requiring a
separate xattr is going to seriously degrade performance.

	       	  	   	     - Ted
