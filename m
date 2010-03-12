From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH 3/5] ext4: Implement project ID support for ext4
	filesystem
Date: Fri, 12 Mar 2010 15:07:29 -0500
Message-ID: <20100312200728.GA13448@fieldses.org>
References: <1267727677-11956-1-git-send-email-dmonakhov@openvz.org> <1267727677-11956-2-git-send-email-dmonakhov@openvz.org> <1267727677-11956-3-git-send-email-dmonakhov@openvz.org> <1267727677-11956-4-git-send-email-dmonakhov@openvz.org> <20100311120623.GC4706@infradead.org> <877hpjj88k.fsf@openvz.org> <B4AAD310-8A75-43C8-989E-616CFACFB7A9@sun.com> <20100311220133.GL1497@thunk.org> <87pr39evhi.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, Andreas Dilger <adilger@sun.com>,
	Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87pr39evhi.fsf@openvz.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Mar 12, 2010 at 12:32:09PM +0300, Dmitry Monakhov wrote:
> tytso@mit.edu writes:
> 
> > On Thu, Mar 11, 2010 at 12:54:46PM -0700, Andreas Dilger wrote:
> >> A second possibility (if there is really no desire to have more than
> >> a single project ID per inode) is to add a field to the "large"
> >> inode for ext4, though that doesn't help filesystems that were not
> >> formatted that way, and it also consumes space in all inodes even if
> >> this feature is not used.
> >
> > The big question that I'm still uncertain about is how often are
> > people going to be using this feature, and how many project ID's do we
> > really need?  I know Dimitry believes this is going to be the greatest
> > thing since sliced bread, but even for people running virtualization,
> > I'm not sure how many folks really will consider it critical.
> Most of our customers (hosting providers) use quota, otherwise
> it is impossible to restrict disk usage. Currently they have to
> perform full quotecheck after power failure. Which result in huge
> service down time. If we able to use journalled quota all problems
> will be solved.
> Also NFS people was interesting in projectid feature. They want to
> use it for creating safe file-handles.
> http://marc.info/?l=linux-fsdevel&m=126634832431306&w=2

By the way, have you looked at all at what it would take to be able to
encode and decode filehandles with projectid's in them?

--b.
