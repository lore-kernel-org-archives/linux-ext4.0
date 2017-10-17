From: Vijay Chidambaram <vvijay03@gmail.com>
Subject: Re: [PATCH] ext4: fix interaction between i_size, fallocate, and
 delalloc after a crash
Date: Mon, 16 Oct 2017 20:02:04 -0500
Message-ID: <CAPaz=ELtZtd+-_TWjn-OnnG4AjNb5RJx18BYBDE0pBbj-zWJoA@mail.gmail.com>
References: <59D5DEE0.6080506@cn.fujitsu.com> <CAFk8rvbi3MHbRBtaZVTJKDcORaDTtMpwy2X2ZdXTZt=LE5smZw@mail.gmail.com>
 <CAOQ4uxgc77_P472KEyHfAXSOE6DD7c=2VrJWBJT6ahiSYb=iJQ@mail.gmail.com>
 <CAFk8rvYtyraezVEP1e3LFEE+9t5YoRH2YwjKxex8hgSY74Lw7A@mail.gmail.com>
 <20171007032917.bntgnubthdstmrrt@thunk.org> <59DDFC47.3050300@cn.fujitsu.com>
 <CAFk8rvbi6eDn4P7rfBr6+90xbsQcfEBJAp0wQh+tczNEwdMTpw@mail.gmail.com>
 <CAOQ4uxjtf8_y7Hmb4GU9YN7DvMa7WNtpeRzGoK5m2=Vw=ChStA@mail.gmail.com>
 <CAFk8rvZoOcU4Di8mkV_uPd3e4ccqPrB5kg2Y5WufhJX6W73k7w@mail.gmail.com>
 <CAOQ4uxiKdRq1KyiEW-d9rp+hWQanVzMXQa1vW2JHmhtEVM1-GA@mail.gmail.com> <20171017000925.jdh6j66ejnebbckg@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: fstests <fstests@vger.kernel.org>,
        Ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vk0-f49.google.com ([209.85.213.49]:50711 "EHLO
        mail-vk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752991AbdJQBCq (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Oct 2017 21:02:46 -0400
In-Reply-To: <20171017000925.jdh6j66ejnebbckg@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

This was what we were suspecting as well. If the bug being exposed or
not only depends on the number of transactions in the journal before
the test workload starts, that=E2=80=99s something we could easily capture =
in
CrashMonkey. It would be one more parameter to tweak, and we would
potentially have to get multiple traces of the test workload with the
journal being X percent full.

It does expand our already-large search space, but our first order of
business is making sure CrashMonkey can reproduce every
crash-consistency bug reported in recent times (mostly by Amir :) ).

So for now we were just analyzing the bug and trying to understand it,
but it looks like the post-recovery image is not very useful for this.
We do want CrashMonkey to remain file-system agnostic.

(resending since earlier email failed)

Thanks,
Vijay

On Mon, Oct 16, 2017 at 7:09 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Tue, Oct 17, 2017 at 12:11:40AM +0300, Amir Goldstein wrote:
>>
>> The disk image SHOULD reflect a state on a disk after the power was
>> cut in the middle of mounted fs. Then power came back on, filesystem
>> was mounted, journal recovered, then filesystem was cleanly unmounted.
>> At this stage, I don't expect there should be anything interesting in th=
e
>> journal.
>
> I suspect what Ashlie was hoping for was a file system image *before*
> the file system was remounted and the journal replayed (and then
> truncated).  That would allow for an analysis of image right after the
> simulated power cut, so it could be seen what was in the journal.
>
> The only way to get that is to modify the test so that it aborts
> before the file system is remounted.  I did some investigations where
> I ran commands (such as "debugfs -R "logdump -ac /dev/vdc") before the
> file system was remounted to gather debugging information.  That's how
> I tracked down the problem.  Unfortunately I never bothered to grab
> full file system snapshot, so I can't give Ashlie what she's hoping
> for.
>
>> I believe umount call should be blocked until all writes have been flush=
ed
>> out to flakey device.
>
> That is correct.
>
>> Ted explained that the bug related to very specific timing of flusher
>> thread vs. fallocate thread.
>> I was under the impression that CrashMonkey can only reorder writes
>> between recorded FLUSH requests, so I am not really sure how you intent =
to
>> modify CrashMonkey to catch this bug.
>
> The real issue is that what CrashMonkey is testing is given a test
> trace with N CACHE FLUSH operations, given a random X such that:
>
>        1 <=3D X < N
>
> If of the writes before the Xth CACHE FLUSH are completed, and a
> random set of writes between the Xth and (X+1)th CACHE FLUSH are
> completed, is the file system still consistent after a journal replay.
>
> That's a fine thing to test, although you can probably do that more
> efficiently by simply looking at all of the metadata writes between
> the Xth and X+1th CACHE FLUSH.  Those writes must be effective no-ops
> after the journal is replayed up to the Xth cache flush.  Which is to
> say, the writes must either (a) be to a data block, or (b) the
> contents of the writes must match either (a) the most recent journal
> entry for that block (up to the Xth cache flush), or (b) the current
> state of the disk.
>
> So if you are willing to assume knowledge of what is stored in the
> journal and how ext4 works, it should be possible to implement
> CrashMonkey much more effectively.
>
>
> The problem that this bug exposed is different sort of problem.  To
> find this bug, given the I/O stream, you can simply examine the file
> system state after each journal commit.  (e.g., after each CACHE
> FLUSH).  And just make sure the file system state is consistent.
> There is no need to include some random set of writes from the last
> commit epoch.
>
> The sort of searching of the test space new CrashMonkey' would have to
> test can't be done just by looking at the io traces.  Instead, a
> workload consists of a series of micro-transactions (jbd2 handles)
> which are assigned to a set of journal transactions.  Normally, which
> handles get assigned to a given transaction is based on timing (we
> close a transaction every 5 seconds), or based on the size of the
> transaction (we limit the number of blocks in a transaction), or based
> file system operations --- e.g., a fsync() will cause a transaction to
> close.
>
> This CrashMoney' would have to explore a different set of transaction
> boundaries (e.g., which handles are assigned to a transaction before a
> transaction closes), and whether the file system is consistent at each
> transaction boundary given a each possible assignment of handles to
> transactions.
>
> It's doable, but it would have to be done by logging the data passed
> to the jbd2 logging layer, and checking file system consistency at
> each handle boundary.
>
>                                                         - Ted
