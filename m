From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix interaction between i_size, fallocate, and
 delalloc after a crash
Date: Mon, 16 Oct 2017 20:09:25 -0400
Message-ID: <20171017000925.jdh6j66ejnebbckg@thunk.org>
References: <59D5DEE0.6080506@cn.fujitsu.com>
 <CAFk8rvbi3MHbRBtaZVTJKDcORaDTtMpwy2X2ZdXTZt=LE5smZw@mail.gmail.com>
 <CAOQ4uxgc77_P472KEyHfAXSOE6DD7c=2VrJWBJT6ahiSYb=iJQ@mail.gmail.com>
 <CAFk8rvYtyraezVEP1e3LFEE+9t5YoRH2YwjKxex8hgSY74Lw7A@mail.gmail.com>
 <20171007032917.bntgnubthdstmrrt@thunk.org>
 <59DDFC47.3050300@cn.fujitsu.com>
 <CAFk8rvbi6eDn4P7rfBr6+90xbsQcfEBJAp0wQh+tczNEwdMTpw@mail.gmail.com>
 <CAOQ4uxjtf8_y7Hmb4GU9YN7DvMa7WNtpeRzGoK5m2=Vw=ChStA@mail.gmail.com>
 <CAFk8rvZoOcU4Di8mkV_uPd3e4ccqPrB5kg2Y5WufhJX6W73k7w@mail.gmail.com>
 <CAOQ4uxiKdRq1KyiEW-d9rp+hWQanVzMXQa1vW2JHmhtEVM1-GA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ashlie Martinez <ashmrtn@utexas.edu>,
        Xiao Yang <yangx.jy@cn.fujitsu.com>,
        Eryu Guan <eguan@redhat.com>, Josef Bacik <jbacik@fb.com>,
        fstests <fstests@vger.kernel.org>,
        Ext4 <linux-ext4@vger.kernel.org>,
        Vijay Chidambaram <vvijay03@gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53978 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754985AbdJQAJd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 16 Oct 2017 20:09:33 -0400
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiKdRq1KyiEW-d9rp+hWQanVzMXQa1vW2JHmhtEVM1-GA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 17, 2017 at 12:11:40AM +0300, Amir Goldstein wrote:
> 
> The disk image SHOULD reflect a state on a disk after the power was
> cut in the middle of mounted fs. Then power came back on, filesystem
> was mounted, journal recovered, then filesystem was cleanly unmounted.
> At this stage, I don't expect there should be anything interesting in the
> journal.

I suspect what Ashlie was hoping for was a file system image *before*
the file system was remounted and the journal replayed (and then
truncated).  That would allow for an analysis of image right after the
simulated power cut, so it could be seen what was in the journal.

The only way to get that is to modify the test so that it aborts
before the file system is remounted.  I did some investigations where
I ran commands (such as "debugfs -R "logdump -ac /dev/vdc") before the
file system was remounted to gather debugging information.  That's how
I tracked down the problem.  Unfortunately I never bothered to grab
full file system snapshot, so I can't give Ashlie what she's hoping
for.

> I believe umount call should be blocked until all writes have been flushed
> out to flakey device.

That is correct.

> Ted explained that the bug related to very specific timing of flusher
> thread vs. fallocate thread.
> I was under the impression that CrashMonkey can only reorder writes
> between recorded FLUSH requests, so I am not really sure how you intent to
> modify CrashMonkey to catch this bug.

The real issue is that what CrashMonkey is testing is given a test
trace with N CACHE FLUSH operations, given a random X such that:

       1 <= X < N

If of the writes before the Xth CACHE FLUSH are completed, and a
random set of writes between the Xth and (X+1)th CACHE FLUSH are
completed, is the file system still consistent after a journal replay.

That's a fine thing to test, although you can probably do that more
efficiently by simply looking at all of the metadata writes between
the Xth and X+1th CACHE FLUSH.  Those writes must be effective no-ops
after the journal is replayed up to the Xth cache flush.  Which is to
say, the writes must either (a) be to a data block, or (b) the
contents of the writes must match either (a) the most recent journal
entry for that block (up to the Xth cache flush), or (b) the current
state of the disk.

So if you are willing to assume knowledge of what is stored in the
journal and how ext4 works, it should be possible to implement
CrashMonkey much more effectively.


The problem that this bug exposed is different sort of problem.  To
find this bug, given the I/O stream, you can simply examine the file
system state after each journal commit.  (e.g., after each CACHE
FLUSH).  And just make sure the file system state is consistent.
There is no need to include some random set of writes from the last
commit epoch.

The sort of searching of the test space new CrashMonkey' would have to
test can't be done just by looking at the io traces.  Instead, a
workload consists of a series of micro-transactions (jbd2 handles)
which are assigned to a set of journal transactions.  Normally, which
handles get assigned to a given transaction is based on timing (we
close a transaction every 5 seconds), or based on the size of the
transaction (we limit the number of blocks in a transaction), or based
file system operations --- e.g., a fsync() will cause a transaction to
close.

This CrashMoney' would have to explore a different set of transaction
boundaries (e.g., which handles are assigned to a transaction before a
transaction closes), and whether the file system is consistent at each
transaction boundary given a each possible assignment of handles to
transactions.

It's doable, but it would have to be done by logging the data passed
to the jbd2 logging layer, and checking file system consistency at
each handle boundary.

							- Ted
