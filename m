From: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH] Improve buffered streaming write ordering
Date: Wed, 8 Oct 2008 01:46:06 +1100
Message-ID: <200810080146.06692.nickpiggin@yahoo.com.au>
References: <1222950054.6745.18.camel@think.oraclecorp.com> <20081007132911.GA6905@mit.edu> <20081007133651.GA19895@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Chris Mason <chris.mason@oracle.com>,
	Dave Chinner <david@fromorbit.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	ext4 <linux-ext4@vger.kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755369AbYJGOq3@vger.kernel.org>
In-Reply-To: <20081007133651.GA19895@infradead.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wednesday 08 October 2008 00:36, Christoph Hellwig wrote:
> On Tue, Oct 07, 2008 at 09:29:11AM -0400, Theodore Tso wrote:
> > That's true, but there is a lot of code duplication, which means that
> > bugs or changes in write_cache_pages() would need to be fixed in
> > ext4_write_cache_pages().  So another approach that might be better
> > from a long-term code maintenance point of view is to add a flag in
> > struct writeback_control that tells write_cache_pages() not to update
> > those fields, and avoid duplicating approximately 95 lines of code.
> > It means a change in a core mm function, though, so if folks thinks
> > its too ugly, we can make our own copy in fs/ext4.

Heh, funny you should mention that. I was looking at it just the other
day. It's riddled with bugs (some of which supposedly are by-design
circumventing of data integrity).

http://linux.derkeiler.com/Mailing-Lists/Kernel/2008-10/msg00917.html

I'm also looking (in the same thread) at doing a patch to improve fsync
performance and ensure it doesn't get stuck behind concurrent dirtiers
by adding another tag to the radix-tree. Mikulas is also looking at
improving that problem with another method. It would be nice if fsdevel
gurus would participate (I'll send out my patchset when I get it working,
and recap the situation and competing ideas).
