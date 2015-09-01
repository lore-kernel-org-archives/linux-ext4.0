From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [GIT PULL] Ext3 removal, quota & udf fixes
Date: Mon, 31 Aug 2015 23:44:22 -0700
Message-ID: <20150901064422.GA16503@infradead.org>
References: <20150831061920.GA2751@quack.suse.cz>
 <CA+55aFweA1J+a5MYxgWDOAg0p+UdqfP+Z1aFKs1c8n0hWUiBDw@mail.gmail.com>
 <55E4D5DE.2030709@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Raymond Jennings <shentino@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55E4D5DE.2030709@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Aug 31, 2015 at 03:31:58PM -0700, Raymond Jennings wrote:
> I think also that we should remove the ext2 driver before we remove the ext3
> driver.

Very strong disagreement here.  Compare to ext4 and ext3, ext2 is a very
different beast with a different architecture.  It's basically our
template for "simple" file system drivers, and very useful for that
alone, nevermind for all the systems that don't want a complicated
journaling or log based file system for various reasons.
