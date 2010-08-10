From: Eric Whitney <eric.whitney@hp.com>
Subject: Re: [PATCH, RFC 0/3] *** SUBJECT HERE ***  (ext4 scalability patches)
Date: Mon, 09 Aug 2010 23:40:42 -0400
Message-ID: <4C60CA3A.5070807@hp.com>
References: <1280851315-9167-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	ocfs2-devel@oss.oracle.com, John Stultz <johnstul@us.ibm.com>,
	Keith Maanthey <kmannth@us.ibm.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:18278 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756506Ab0HJDkn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Aug 2010 23:40:43 -0400
In-Reply-To: <1280851315-9167-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/03/2010 12:01 PM, Theodore Ts'o wrote:
> The first patch in this patch series hasn't changed since when I had
> last posted it, but I'm including it again for the benefit of the folks
> on ocfs2-dev.
>
> Thanks to some work done by Eric Whitney, when he accidentally ran the
> command "mkfs.ext4 -t xfs", and created a ext4 file system without a
> journal, it appears that main scalability bottleneck for ext4 is in the
> jbd2 layer.  In fact, his testing on a 48-core system shows that on some
> workloads, ext4 is roughly comparable with XFS!
>
> The lockstat results indicate that the main bottlenecks are in the
> j_state_lock and t_handle_lock, especially in start_this_handle() in
> fs/jbd2/transaction.c.  A previous patch, which removed an unneeded
> grabbing of j_state_lock jbd2_journal_stop() relieved pressure on that
> lock and was noted to make a significant difference for dbench on a
> kernel with CONFIG_PREEMPT_RT enabled, as well as on a 48-core AMD
> system from HP.   This patch is already in 2.6.35, and the benchmark
> results can be found here: http://free.linux.hp.com/~enw/ext4/2.6.34/
>
> This patch series removes all exclusive spinlocks when starting and
> stopping jbd2 handles, which should improve things even more.  Since
> OCFS2 uses the jbd2 layer, and the second patch in this patch series
> touches ocfs2 a wee bit, I'd appreciate it if you could take a look and
> let me know what you think.  Hopefully, this should also improve OCFS2's
> scalability.
>
> Best regards,
>
>       					- Ted
>
> Theodore Ts'o (3):
>    jbd2: Use atomic variables to avoid taking t_handle_lock in
>      jbd2_journal_stop
>    jbd2: Change j_state_lock to be a rwlock_t
>    jbd2: Remove t_handle_lock from start_this_handle()
>
>   fs/ext4/inode.c       |    4 +-
>   fs/ext4/super.c       |    4 +-
>   fs/jbd2/checkpoint.c  |   18 +++---
>   fs/jbd2/commit.c      |   42 +++++++-------
>   fs/jbd2/journal.c     |   94 +++++++++++++++----------------
>   fs/jbd2/transaction.c |  149 ++++++++++++++++++++++++++++---------------------
>   fs/ocfs2/journal.c    |    4 +-
>   include/linux/jbd2.h  |   12 ++--
>   8 files changed, 174 insertions(+), 153 deletions(-)
>


My 48 core test results for these patches as applied to 2.6.35 can be 
found at:

http://free.linux.hp.com/~enw/ext4/2.6.35

Both the Boxacle large_file_creates and random_writes workloads improved 
significantly and consistently with these patches, and apparently in the 
single threaded case as well as at increased scale.
The graphs at the URL show one instance of several runs I made to 
establish repeatability.

I've also taken unmodified 2.6.35 ext4, ext4 without a journal, and xfs 
data for comparison.  In addition, I've collected lock stats and more 
detailed performance data for reference.

Thanks, Ted!
Eric

