From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Large directories and poor order correlation
Date: Tue, 15 Mar 2011 15:08:53 -0400
Message-ID: <4D7FB945.1070209@cfl.rr.com>
References: <4D7E7990.90209@cfl.rr.com> <4D7E7C7F.1040509@redhat.com> <4D7E8005.4030201@cfl.rr.com> <20110314215249.GE8120@thunk.org> <4D7EA83D.20400@cfl.rr.com> <20110315001448.GG8120@thunk.org> <4D7F7134.7080209@cfl.rr.com> <20110315170827.GH8120@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:38651 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab1COTJD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Mar 2011 15:09:03 -0400
In-Reply-To: <20110315170827.GH8120@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 3/15/2011 1:08 PM, Ted Ts'o wrote:
> No, because the directory blocks are the leaf nodes, and in the case
> of a node split, we need to copy half of the directory entries in one
> block, and move it to a newly allocated block.  If readdir() was
> traversing the linear directory entries, and had already traversed
> that directory block that needs to split, then you'll return those
> directory entries that got copied into a new leaf (i.e., new directory
> block) a second time.

When you split the htree node, aren't you just moving around the
"deleted entries"?  So the normal names remain in the same order so
readdir() doesn't have a problem when it is ignoring the htree entries
and just walking the normal names?

Also, how do you deal with this when you do end up re balancing the
htree during a readdir()?  I would think that keeping that straight
would be much more difficult than handling the problem with linear
directory entries.

Why was the htree hidden inside the normal directory structure anyway?

> Unless some files get deleted in between.  Now depending on the
> "holes" in the directory blocks, where the new directory entries are
> added, even in the non-htree case, could either be wherever an empty
> directory entry could be found, or in the worst case, we might need to
> allocate a new block and that new directory entry gets added to the
> end of the block.

Right, but on an otherwise idle system, when you make all the files at
once via rsync or untaring an archive, this shouldn't happen and they
should be ( generally ) in ascending order, shouldn't they?

> I suggest that you try some experiments, using both dir_index and
> non-dir_index file systems, and then looking at the directory using
> the debugfs "ls" and "htree_dump" commands.  Either believe me, or
> learn how things really work.  :-)

Now THAT sounds interesting.  Is this documented somewhere?

Also, why can't chattr set/clear the 'I' flag?  Is it just a runtime
combersome thing?  So setting and clearing the flag with debugfs
followed by a fsck should do the trick?  And when is it automatically
enabled?

> I suppose we could allocate up to some tunable amount worth of
> directory space, say 64k or 128k, and do the sorting inside the
> kernel.  We then have to live with the fact that each badly behaved
> program which calls opendir(), and then a single readdir(), and then
> stops, will consume 128k of non-swappable kernel memory until the
> process gets killed.  A process which does this thousands of times
> could potentially carry out a resource exhaustion attack on the
> system.  Which we could then try to patch over, by say creating a new
> resource limit of the number of directories a process can keep open at
> a time, but then the attacker could just fork some additional child
> processes....

I think you are right in that if sorting is to be done at
opendir()/readdir() time, then it should be done in libc, not the
kernel, but it would be even better if the fs made some effort store the
entries in a good order so no sorting is needed at all.

