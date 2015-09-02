From: Chuck Ebbert <cebbert.lkml@gmail.com>
Subject: Re: [GIT PULL] Ext3 removal, quota & udf fixes
Date: Wed, 2 Sep 2015 07:58:20 -0400
Message-ID: <20150902075821.53108f0e@as>
References: <20150831061920.GA2751@quack.suse.cz>
	<CA+55aFweA1J+a5MYxgWDOAg0p+UdqfP+Z1aFKs1c8n0hWUiBDw@mail.gmail.com>
	<55E4D5DE.2030709@gmail.com>
	<CAMu38x+4V2JbGfCB_BxgbMOfR7QtQHFY_ebac1h1WY6wspjWFA@mail.gmail.com>
	<55E5FF01.2000304@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Albino B Neto <bino@riseup.net>,
	Raymond Jennings <shentino@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <55E5FF01.2000304@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 1 Sep 2015 15:39:45 -0400
Austin S Hemmelgarn <ahferroin7@gmail.com> wrote:

> On 2015-09-01 06:29, Albino B Neto wrote:
> > 2015-08-31 19:31 GMT-03:00 Raymond Jennings <shentino@gmail.com>:
> >> I think also that we should remove the ext2 driver before we remove the ext3
> >> driver.
> >
> > Yes. It is logical to remove the old ext2 drive, because there are
> > more computers with ext3 that ext2. Ext2 is obsolete by existing
> > technologies.
> >
> NO, it is not logical.  A vast majority of Android smartphones in the 
> wild use ext2, as do a very significant portion of embedded systems that 
> don't have room for the few hundred kilobytes of extra code that the 
> ext4 driver has in comparison to ext2.

Would it be possible to discard the code used for ext4 and ext3
features at module init time? So you could do something like:

  modprobe ext4 no_ext4 no_ext3

and all the space used by those functions would be freed and the
filesystem driver would mark all the ext3/ext4 features as
unsupported.
