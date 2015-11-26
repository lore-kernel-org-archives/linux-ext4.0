From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH] fix an endianness bug in ext4_encrypted_follow_link()
Date: Thu, 26 Nov 2015 22:28:19 +0100 (CET)
Message-ID: <alpine.DEB.2.02.1511262227080.2034@localhost6.localdomain6>
References: <20151126152728.GT22011@ZenIV.linux.org.uk> <1448566837.18647.16.camel@perches.com> <20151126210223.GV22011@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Joe Perches <joe@perches.com>, Theodore Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151126210223.GV22011@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



On Thu, 26 Nov 2015, Al Viro wrote:

> On Thu, Nov 26, 2015 at 11:40:37AM -0800, Joe Perches wrote:
> > (cc'ing Julia Lawall)
> > 
> > On Thu, 2015-11-26 at 15:27 +0000, Al Viro wrote:
> > > applying le32_to_cpu() to 16bit value is a bad idea...
> > 
> > Julia, perhaps you or your crew could produce a coccinelle test
> > for this class of error?
> 
> What's wrong with something like make C=2 CF=-D__CHECK_ENDIAN__ fs/ext4/ ?
> Worked just fine, TYVM -
>   CHECK   fs/ext4/symlink.c
> fs/ext4/symlink.c:55:21: warning: cast to restricted __le32
> fs/ext4/symlink.c:55:21: warning: cast from restricted __le16
> points to exact location...  Sure, you need to figure out _how_ it's
> broken (e.g. with something like
> struct foo {
> 	__le32 a;
> 	__le16 b;
> } *p;
> le32_to_cpu(p->b) might have been misspelled le16_to_cpu(p->b) as well
> as le32_to_cpu(p->a)) - no way to tell one from another without actually
> reading and understanding the code in question. But that doesn't depend
> upon the tool used to locate the damn thing and sparse does locate them...

As long as the code of interest is getting compiled in the current 
configuration, relying on the compiler fo this seems like a better choice.  
Coccinelle has no idea what types represent 16 values, and if one were to 
try to enumerate them one would surely miss something.

julia
