From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] fix an endianness bug in ext4_encrypted_follow_link()
Date: Thu, 26 Nov 2015 21:02:24 +0000
Message-ID: <20151126210223.GV22011@ZenIV.linux.org.uk>
References: <20151126152728.GT22011@ZenIV.linux.org.uk>
 <1448566837.18647.16.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, Julia Lawall <julia.lawall@lip6.fr>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Joe Perches <joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1448566837.18647.16.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Nov 26, 2015 at 11:40:37AM -0800, Joe Perches wrote:
> (cc'ing Julia Lawall)
> 
> On Thu, 2015-11-26 at 15:27 +0000, Al Viro wrote:
> > applying le32_to_cpu() to 16bit value is a bad idea...
> 
> Julia, perhaps you or your crew could produce a coccinelle test
> for this class of error?

What's wrong with something like make C=2 CF=-D__CHECK_ENDIAN__ fs/ext4/ ?
Worked just fine, TYVM -
  CHECK   fs/ext4/symlink.c
fs/ext4/symlink.c:55:21: warning: cast to restricted __le32
fs/ext4/symlink.c:55:21: warning: cast from restricted __le16
points to exact location...  Sure, you need to figure out _how_ it's
broken (e.g. with something like
struct foo {
	__le32 a;
	__le16 b;
} *p;
le32_to_cpu(p->b) might have been misspelled le16_to_cpu(p->b) as well
as le32_to_cpu(p->a)) - no way to tell one from another without actually
reading and understanding the code in question. But that doesn't depend
upon the tool used to locate the damn thing and sparse does locate them...
