From: mhocko@kernel.org
Subject: [RFC 0/8] Allow GFP_NOFS allocation to fail
Date: Wed,  5 Aug 2015 11:51:16 +0200
Message-ID: <1438768284-30927-1-git-send-email-mhocko@kernel.org>
Cc: <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Dave Chinner <david@fromorbit.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Return-path: <owner-linux-mm@kvack.org>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

Hi,
small GFP_NOFS, like GFP_KERNEL, allocations have not been not failing
traditionally even though their reclaim capabilities are restricted
because the VM code cannot recurse into filesystems to clean dirty
pages. At the same time these allocation requests do not allow to
trigger the OOM killer because that would lead to pre-mature OOM killing
during heavy fs metadata workloads.

This leaves the VM code in an unfortunate situation where GFP_NOFS
requests is looping inside the allocator relying on somebody else to
make a progress on its behalf. This is prone to deadlocks when the
request is holding resources which are necessary for other task to make
a progress and release memory (e.g. OOM victim is blocked on the lock
held by the NONFS request). Another drawback is that the caller of
the allocator cannot define any fallback strategy because the request
doesn't fail.

As the VM cannot do much about these requests we should face the reality
and allow those allocations to fail. Johannes has already posted the
patch which does that (http://marc.info/?l=linux-mm&m=142726428514236&w=2)
but the discussion died pretty quickly.

I was playing with this patch and xfs, ext[34] and btrfs for a while to
see what is the effect under heavy memory pressure. As expected this led
to some fallouts.
My test consisted of a simple memory hog which allocates a lot of
anonymous memory and writes to a fs mainly to trigger a fs activity on
exit. In parallel there is a parallel fs metadata load (multiple tasks
creating thousands of empty files and directories). All is running
in a VM with small amount of memory to emulate an under provisioned
system. The metadata load is triggering a sufficient load to invoke the
direct reclaim even without the memory hog. The memory hog forks several
tasks sharing the VM and OOM killer manages to kill it without locking
up the system (this was based on the test case from Tetsuo Handa -
http://www.spinics.net/lists/linux-fsdevel/msg82958.html - I just didn't
want to kill my machine ;)).
With all the patches applied none of the 4 filesystems gets aborted
transactions and RO remount (well xfs didn't need any special
treatment). This is obviously not sufficient to claim that failing
GFP_NOFS is OK now but I think it is a good start for the further
discussion. I would be grateful if FS people could have a look at those
patches.  I have simply used __GFP_NOFAIL in the critical paths. This
might be not the best strategy but it sounds like a good first step.

The first patch in the series also allows __GFP_NOFAIL allocations to
access memory reserves when the system is OOM which should help those
requests to make a forward progress - especially in combination with
GFP_NOFS.

The second patch tries to address a potential pre-mature OOM killer from
the page fault path. I have posted it separately but it didn't get much
traction.

The third patch allows GFP_NOFS to fail and I believe it should see much
more testing coverage. It would be really great if it could sit in the
mmotm tree for few release cycles so that we can catch more fallouts.

The rest are the FS specific patches to fortify allocations
requests which are really needed to finish transactions without RO
remounts. There might be more needed but my test case survives with
these in place.
They would obviously need some rewording if they are going to be applied
even without Patch3 and I will do that if respective maintainers will
take them. Ext3 and JBD are going away soon so they might be dropped but
they have been in the tree while I was testing so I've kept them.

Thoughts? Opinions?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
