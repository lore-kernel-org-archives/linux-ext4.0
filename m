From: "Peter Kukol" <pkukol@google.com>
Subject: No-journal option for ext4
Date: Mon, 6 Oct 2008 18:39:50 -0700
Message-ID: <929ffc5e0810061839l6d5977b4o96ea1699c8451446@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Michael Rubin" <mrubin@google.com>,
	"Frank Mayhar" <fmayhar@google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:59003 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413AbYJGBj5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Oct 2008 21:39:57 -0400
Received: from spaceape14.eur.corp.google.com (spaceape14.eur.corp.google.com [172.28.16.148])
	by smtp-out.google.com with ESMTP id m971dqn6012393
	for <linux-ext4@vger.kernel.org>; Tue, 7 Oct 2008 02:39:53 +0100
Received: from gxk9 (gxk9.prod.google.com [10.202.11.9])
	by spaceape14.eur.corp.google.com with ESMTP id m971dU4t007953
	for <linux-ext4@vger.kernel.org>; Mon, 6 Oct 2008 18:39:51 -0700
Received: by gxk9 with SMTP id 9so5969828gxk.13
        for <linux-ext4@vger.kernel.org>; Mon, 06 Oct 2008 18:39:51 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Due to some interest in having an ext4 option not to use a journal at
all (for various reasons that I'd rather not get into right now), I've
been looking at adding an option to mount and use a volume as ext4
without a journal present, and I'm wondering if folks would be willing
to chime in to help direct this effort (for one thing, I'm fairly new
to the ext4 code base so I can certainly use all the help and guidance
I can get ;-). The way I've gone about this so far is as follows.

To start with, I added an "incompat" option to ext4 allow the journal
not to be present - when the right option string is given at mount
time, the journaling functionality is disabled. The exact naming and
mechanism by which this happens  actually doesn't seem terribly
important to the real "guts" of the making the feature work, but if
anyone feels strongly that it should be done in a certain way please
do let me know.

My first attempt at actually implementing the no-journal option was to
disable all of the journaling logic "early" - i.e. not create handles
and journal instances, and so on. This ran into a bit of trouble in
the handful of journaling functions that only accept handles and have
no obvious way of determining whether journaling is disabled or not
(other than the handle being NULL, which seems like a poor
determinant). In addition to this, I ran into a few places where tests
for a handle being non-NULL guard code that is needed even when
journaling is disabled.

Undeterred, in my next attempt I changed the code to create the
journal instance and allocate handles and transactions and all that,
since this way a handle is always good enough to determine whether
"real" journaling is to happen or not; incidentally, this also allows
the "no-journal" flag to go in the journal superblock which seems like
a pretty good place to keep it. Sadly, this second approach ran into
even more trouble: basically, the number of places where the "are we
really journaling or just pretending to" flag had to be tested seemed
excessive and all the changes all too intrusive (not to mention that
it seems a bit silly to create all those data structures needed only
for the journal and then not do any journaling). So, in the end, I
went back to disabling journal-only functionality "early", i.e.
typically at the points where the ext4_ or jbd2_ functions are called
in ext4 code, and storing the "no-journal" bit in the superblock (not
the journal superblock but the "main" sb of the file system).

One effect of doing things this way is that there are quite a number
of places in the ext4 code that now need to test the "are we really
journaling" bit, though having tried the obvious alternative described
above (i.e. pushing the "real journal" tests farther into the journal
code itself), I think that on balance this seems like a reasonable
approach. By now I've added the necessary tests to enough ext4 code to
be able to mount a volume with no journal and create directories and
files, but there are plenty more places that still need to check the
bit and not call the journal code when it's disabled. To show a
specific example of doing this, the following is my current diff for
mballoc.c:

diff 2.6.26/fs/ext4/mballoc.c noj/2.6.26/fs/ext4/mballoc.c
2906,2908c2906,2910
<     err = ext4_journal_get_write_access(handle, bitmap_bh);
<     if (err)
<         goto out_err;
---
>     if (!EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_NULL_JOURNAL)) {
>         err = ext4_journal_get_write_access(handle, bitmap_bh);
>         if (err)
>             goto out_err;
>     }
2918,2920c2920,2924
<     err = ext4_journal_get_write_access(handle, gdp_bh);
<     if (err)
<         goto out_err;
---
>     if (!EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_NULL_JOURNAL)) {
>         err = ext4_journal_get_write_access(handle, gdp_bh);
>         if (err)
>             goto out_err;
>     }
2943,2945c2947,2951
<         err = ext4_journal_dirty_metadata(handle, bitmap_bh);
<         if (!err)
<             err = -EAGAIN;
---
>         if (!EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_NULL_JOURNAL)) {
>             err = ext4_journal_dirty_metadata(handle, bitmap_bh);
>             if (!err)
>                 err = -EAGAIN;
>         }
2989,2992c2995,3001
<     err = ext4_journal_dirty_metadata(handle, bitmap_bh);
<     if (err)
<         goto out_err;
<     err = ext4_journal_dirty_metadata(handle, gdp_bh);
---
>     if (!EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_NULL_JOURNAL)) {
>         err = ext4_journal_dirty_metadata(handle, bitmap_bh);
>         if (err)
>             goto out_err;
>         err = ext4_journal_dirty_metadata(handle, gdp_bh);
>     } else
>         err = 0;

Of course, the rather long-winded test for the no-journal bit should
probably be wrapped in a simple macro, but the main point is that
explicit checks are required in quite a few places. The few locations
in the code where a NULL handle currently causes code needed even with
no journal to execute are simply changed to check for NULL handle
*and* the new no-journal bit not being set, which doesn't seem too
bad.

The bottom line is, I'm wondering if folks are interested in having an
option to disable journaling in ext4 to begin with, and if the above
sounds like the right approach or if there might be a better way that
I've overlooked. I've done enough work in this direction (I think) to
verify that it's likely doable and not terribly ugly or burdensome,
but before I continue to change all the remaining places that need to
be no-journal-aware I'd like to check with folks to see if perhaps
there might be a simpler / more effective approach. BTW, the complete
diff at this point a few hundred lines long and I'd be happy to post
it to this list or e-mail it to folks who'd like to see more of it.

Thanks!

PeterK
