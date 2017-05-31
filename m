From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v5 00/17] fs: introduce new writeback error reporting
 and convert ext2 and ext4 to use it
Date: Wed, 31 May 2017 14:37:13 -0700
Message-ID: <20170531143713.95796a8bce699d263b764763@linux-foundation.org>
References: <20170531124540.8782-1-jlayton@redhat.com>
        <20170531132728.2e60bd607bd4174739b6b661@linux-foundation.org>
        <1496266309.2984.13.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>,
        tytso@mit.edu, axboe@kernel.dk, mawilcox@microsoft.com,
        ross.zwisler@linux.intel.com, corbet@lwn.net,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-doc@vger.kernel.org
To: Jeff Layton <jlayton@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1496266309.2984.13.camel@redhat.com>
Sender: linux-block-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 31 May 2017 17:31:49 -0400 Jeff Layton <jlayton@redhat.com> wrote:

> On Wed, 2017-05-31 at 13:27 -0700, Andrew Morton wrote:
> > On Wed, 31 May 2017 08:45:23 -0400 Jeff Layton <jlayton@redhat.com> wrote:
> > 
> > > This is v5 of the patchset to improve how we're tracking and reporting
> > > errors that occur during pagecache writeback.
> > 
> > I'm curious to know how you've been testing this?
> 
> >  Is that testing
> > strong enough for us to be confident that all nature of I/O errors
> > will be reported to userspace?
> > 
> 
> That's a tall order. This is a difficult thing to test as these sorts of
> errors are pretty rare by nature.
> 
> I have an xfstest that I posted just after this set that demonstrates
> that it works correctly, at least on ext2/3/4 when run by the ext4
> driver (ext2 legacy driver reports too many errors currently). I had
> btrfs and xfs working on that test too in an earlier incarnation of this
> set, so I think we can fix this in them as well without too much
> difficulty.
> 
> I'm happy to run other tests if someone wants to suggest them.
> 
> Now, all that said, I don't think this will make things any worse than
> they are today as far as reporting errors properly to userland goes.
> It's rather easy for an incidental synchronous writeback request from an
> internal caller to clear the AS_* flags today. This will at least ensure
> that we're reporting errors since a well-defined point in time when you
> call fsync.

Were you using error injection of some form?  If so, how was that all
set up?
