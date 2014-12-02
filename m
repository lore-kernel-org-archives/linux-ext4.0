From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH-v5 1/5] vfs: add support for a lazytime mount option
Date: Tue, 2 Dec 2014 13:37:27 -0700
Message-ID: <0CAF91FD-F713-4E98-8967-9CA0390CA784@dilger.ca>
References: <1417154411-5367-1-git-send-email-tytso@mit.edu>
	<1417154411-5367-2-git-send-email-tytso@mit.edu>
	<20141128172323.GD738@quack.suse.cz>
	<20141128181421.GA19461@google.com>
	<20141202125820.GE9092@quack.suse.cz>
	<547DFD24.9070805@plexistor.com> <20141202192337.GA13618@thunk.org>
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Boaz Harrosh <boaz@plexistor.com>, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <20141202192337.GA13618@thunk.org>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

On Dec 2, 2014, at 12:23 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Tue, Dec 02, 2014 at 07:55:48PM +0200, Boaz Harrosh wrote:
>> 
>> This I do not understand. I thought that I_DIRTY_TIME, and the all
>> lazytime mount option, is only for atime. So if there are dirty
>> pages then there are also m/ctime that changed and surly we want to
>> write these times to disk ASAP.
> 
> What are the situations where you are most concerned about mtime or
> ctime being accurate after a crash?
> 
> I've been running with it on my laptop for a while now, and it's
> certainly not a problem for build trees; remember, whenever you need
> to update the inode to update i_blocks or i_size, the inode (with its
> updated timestamps) will be flushed to disk anyway.
[snip]
> I'm not aware of an application which is doing a large number of
> non-allocating random writes (for example, such as a database), where
> said database actually cares about mtime being correct.
[snip]
> Did you have such a use case or application in mind?


One thing that comes to mind is touch/utimes()/utimensat().  Those
should definitely not result in timestamps being kept only in memory
for 24h, since the whole point of those calls is to update the times.
It makes sense for these APIs to dirty the inode for proper writeout.

Cheers, Andreas

>> if we are lazytime also with m/ctime then I think I would like an
>> option for only atime lazy. because m/ctime is cardinal to some
>> operations even though I might want atime lazy.
> 
> If there's a sufficiently compelling use case where we do actually
> care about mtime/ctime being accurate, and the current semantics don't
> provide enough of a guarantee, it's certainly something we could do.
> I'd rather keep things simple unless it's really there.  (After all,
> we did create the strictatime mount option, but I'm not sure anyone
> every ends up using it.  It woud be a shame if we created a
> strictcmtime, which had the same usage rate.)
> 
> I'll also note that if it's only about atime updates, with the default
> relatime mount option, I'm not sure there's enough of a win to hae a
> mode to justify a lazyatime only option.  If you really neeed strict
> c/mtime after a crash, maybe the best thing to do is to just simply
> not use the lazytime mount option and be done with it.
> 
> Cheeres,
> 
> 					- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
