From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH v7 00/22] fs: enhanced writeback error reporting with
 errseq_t (pile #1)
Date: Tue, 20 Jun 2017 06:16:01 -0400
Message-ID: <1497953761.4555.1.camel@redhat.com>
References: <20170616193427.13955-1-jlayton@redhat.com>
	 <1497889426.4654.7.camel@redhat.com>
	 <20170620092507.3998e728@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>, Al Viro
 <viro@ZenIV.linux.org.uk>,  Jan Kara <jack@suse.cz>, tytso@mit.edu,
 axboe@kernel.dk, mawilcox@microsoft.com,  ross.zwisler@linux.intel.com,
 corbet@lwn.net, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
 David Sterba <dsterba@suse.com>, "Darrick J . Wong"
 <darrick.wong@oracle.com>, Carlos Maiolino <cmaiolino@redhat.com>, Eryu
 Guan <eguan@redhat.com>, David Howells <dhowells@redhat.com>, Christoph
 Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org,  linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
  linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170620092507.3998e728@canb.auug.org.au>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2017-06-20 at 09:25 +1000, Stephen Rothwell wrote:
> Hi Jeff,
> 
> On Mon, 19 Jun 2017 12:23:46 -0400 Jeff Layton <jlayton@redhat.com> wrote:
> > 
> > If there are no major objections to this set, I'd like to have
> > linux-next start picking it up to get some wider testing. What's the
> > right vehicle for this, given that it touches stuff all over the tree?
> > 
> > I can see 3 potential options:
> > 
> > 1) I could just pull these into the branch that Stephen is already
> > picking up for file-locks in my tree
> > 
> > 2) I could put them into a new branch, and have Stephen pull that one in
> > addition to the file-locks branch
> > 
> > 3) It could go in via someone else's tree entirely (Andrew or Al's
> > maybe?)
> > 
> > I'm fine with any of these. Anyone have thoughts?
> 
> Given that this is a one off development, either 1 or 3 (in Al's tree)
> would be fine.  2 is a possibility (but people forget to ask me to
> remove one shot trees :-()
> 

Ok -- yeah, I'd probably be one of those people who forget too...

In that case, I'll plan to go ahead and just merge these into my
linux-next branch. That's easier than bugging others for it. Hopefully
we won't have a lot in the way of merge conflicts.

I'll see about getting this into branch later today, and hopefully we
can get it into linux-next for tomorrow.

Thanks!
-- 
Jeff Layton <jlayton@redhat.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
