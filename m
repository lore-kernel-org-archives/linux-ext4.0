From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Do you know about this ext4 file system corruption in RHEL 7.3?
 (block bitmap and and bg descriptor mismatch)
Date: Sun, 19 Feb 2017 22:45:48 -0500
Message-ID: <20170220034548.naexjfecprym2xel@thunk.org>
References: <CAEtPA0DhZpvFWWiyDBRCjFD3T+WGheTKLyWOZ+UftnmvYuT0qQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-ext4@vger.kernel.org
To: Patrick Dung <mpatdung@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34508 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752035AbdBTDpw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 19 Feb 2017 22:45:52 -0500
Content-Disposition: inline
In-Reply-To: <CAEtPA0DhZpvFWWiyDBRCjFD3T+WGheTKLyWOZ+UftnmvYuT0qQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 16, 2017 at 01:54:08AM +0800, Patrick Dung wrote:
> Hello,
> 
> I had a RHEL 7.3 vmware workstaion VM (host is Linux running Fedora).
> The VM used LSI SAS adapter. I had previously used it for a few weeks
> without problem.
> 
> When I reboot it in yesterday, there is file system corruption (check
> the end of the log):
> 
> Feb 15 04:37:51 server02 kernel: EXT4-fs error (device dm-0):
> mb_free_blocks:1448: group 38, block 1249221:freeing already freed
> block (bit 4037); block bitmap corrupt.
> Feb 15 04:37:51 server02 kernel: EXT4-fs error (device dm-0):
> ext4_mb_generate_buddy:757: group 38, block bitmap and bg descriptor
> inconsistent: 14676 vs 14677 free clusters

So one of the things to understand is that this is just a symptom.
But there are many different causes which can cause that particular
symptom.  It can be caused by hardware problems; it can caused by
kernel bugs.  For example, there was one bug[1] which had the exact
symptom, but it was *only* showing up on people using Debian 3.16
kernels on Guest VM's.  The people who were reporting this problem
where *sure* that it was an ext4 problem, and there were multiple
people who were seeing it.  As it turns out, it was actually a bug in
KVM subsystem, and it only showed up if you were running in a guest VM
***and*** you were using a specific generation of buggy Intel CPU's.

[1] https://bugzilla.kernel.org/show_bug.cgi?id=102731


Worse, the bug was fixed in 3.17 in this commit[2] --- and Debian had
frozen their stable kernel on 3.16, which was not a long-term support
kernel as far as the upstream kernel developers were concerned.  You
can see the whole debugging experience here[2].  Note that it took
over half a year to finally figure out what was going on, because I
couldn't reproduce it.

[2] https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?h=7dec5603b6b8dc4c3e1c65d318bd2a5a8c62a424 

Since kernel developers tend to run bleeding edge kernels (I'm
currently running 4.9, and Linus just released 4.10 a few hours ago;
my laptop will probably be upgraded to 4.10 plus the ext4 changes due
to be pushed to Linus in the next few days), *we* certainly tend not
to see any of these problems.  So when end-users asked kernel
developers to fix what they were **sure** was an ext4 bug, about all
we could do is:

	¯\_(ツ)_/¯

Which is to say, I run extensive regression testing on ext4 as we do
development.  (This is why I'm willing to run bleeding edge kernels;
I'm actually very confident in the stability of the ext4 code, because
it's been well tested; when I go the latest bleeding edge kernel, my
problems tend to be regressions in the WiFi or Intel i915 graphics
drivers; and since these don't cause data loss, it's pretty easy to
roll back to 4.9 if 4.10 proves problematic.)  The test system I use
is called gce-xfstests, which runs a *very* exhaustive regression test
suite on Google Compute Engine.  (For more information, please see [3].)

[3] https://thunk.org/gce-xfstests

But the problem is that distributions, especially the enterprise
distributions, tend to freeze on ancient kernels, and then they cherry
pick new features from newer kernels.  So even though RHEL 7.3 uses a
3.10 kernel, which was released upstream over ***three*** years ago
(June 30, 2013), Red Had has applied literally thousands of commits on
top of 3.10.  So they are using an ext4 file system which has some
huge number of new features and bug fixes backported to their 3.10
kernel.  I do actually periodically run regression tests on the
upstream 3.10 stable kernel branch --- but that has very little to do
with what Red Hat is using, or the 3.10 kernel that was used on a
number of Android Handsets.

The main reason why I do the 3.10.y testing is mainly because it
doesn't take that much effort (I can kick off a regression test with a
single command, and seven hours later I get a test report e-mailed to
me), but then what I can do with that knowledge is that latest 3.10.x
kernel is passing all or most tests cleanly.  And then when some
mobile developer complains (especially if they work at my company :-),
I can say, well.... you're using a Qualcomm kernel which was branched
off of 3.10.23, and the bug fix was backported to the 3.10.89 kernel
as commit xyzzy.  Cherry pick that patch, and you should be good.  And
then I curse Qualcomm for doing such a terrible job maintaining their
Board Support Kernels, and so they foist off what should be *their*
job on me.  As a result, I am sometimes am not so patient when it's
some other random mobile handset developer asking me for help ---
because I don't get paid enough for this sh*t.  (Actually, as far as
supporting random customers and handset vendors, I don't get paid at
*all* for this kind of thing.  It's all volunteer work.)

In the case of Red Hat, this is why Red Hat sells support contracts.
They have made so many changes, which represent bug fixes and features
requested by their customers, and their customers **want** to use an
ancient kernel so their proprietary device drivers and kernel modules
from EMC, VMWare, et. al., still work.  But as a result ***only*** Red
Hat can really maintain and support their kernel for their customers.
Which, in fact, is a key part of Red Hat's business model.  :-)

The bottom line is that this could very easily not be an ext4 bug, but
rather a fiber channel or other device driver bug; it could be that
KVM bug (although I would have expected they should have cherry picked
that into their kernel if it was applicable), or any number of other
things.  But your best bet is really to open a support ticket with Red
Hat's help desk.

Cheers, and good luck,

						- Ted
