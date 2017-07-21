From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 196405] mkdir mishandles st_nlink in ext4 directory with 64997
 subdirectories
Date: Fri, 21 Jul 2017 15:25:34 +0000
Message-ID: <bug-196405-13602-DncJvU1X4o@https.bugzilla.kernel.org/>
References: <bug-196405-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:46290 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753917AbdGUPZg (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 21 Jul 2017 11:25:36 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 1EE36286DE
        for <linux-ext4@vger.kernel.org>; Fri, 21 Jul 2017 15:25:36 +0000 (UTC)
In-Reply-To: <bug-196405-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=196405

--- Comment #18 from Theodore Tso (tytso@mit.edu) ---
On Fri, Jul 21, 2017 at 08:22:05AM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> I'm worried about code intended to run on traditional Unix and GNU/Linux, not
> about portable POSIX code. There is a reasonable amount of code that uses
> st_nlink as a way to avoid unnecessary stat calls when traversing a file
> system. This provides a significant performance boost on traditional Unix and
> GNU/Linux, and it would be a shame to lose this performance benefit.

One of the things which confuses me is why you think there's so much
code which tries to use the st_nlink hack.  It's ***much*** simpler to
just rely on d_type if it exists (and it does on most systems).  If
the answer is that d_type might not be supported on all file systems,
and a recursive descent might enter a file system which didn't support
d_type:

1) The assumption that st_nlink always has the property that it is >2
   and can be used to derive the number of subdirectories was never
   valid across all file system types, so you could descend into a
   file system type where that wasn't true.

2) If you did descend into a file system which didn't support d_type,
   d_type would be DT_UNKNOWN instead of DT_REG or DT_DIR

3) Using DT_DIR is means you can skip the stat check for all directory
   entries.  If you are doing a recursive descent where you care about
   the name, you need to call readdir() on all of the directory
   entries anyway, so you will have access to d_type.  If you are
   doing a recursive descent where you are checking on file ownership,
   you are doing the stat(2) anyway, so why not check
   S_ISDIR(st.st_mode) instead of blindly using the st_nlink hack?

4) Using d_type/DT_DIR is implemented in anything that was BSD
   derived, and many of the SysV derived systems (to the extent that
   they imported in the BSD Fast Filesystem), would have also had
   d_type support.  So if your argument is what about legacy Unix
   code, I would think that most of them would have used the much more
   performant and simpler-to-use d_type interface.

> > allowing tune2fs to clear the dir_nlink flag is not a safe thing to do.
> That depends on what the dir_nlink flag is supposed to mean. (Since the flag
> does not work now, we can define it to mean what we like. :-) If dir_nlink 1
> means "set a directory link count to 1 if it would overflow", and if a link
> count of 1 never changes regardless of what dir_nlink is set to, then why
> would
> it be a problem to allow tunefs to alter the dir_nlink flag? dir_nlink would
> affect only future calls to mkdir, not past ones.

Well, it's mostly safe now because ten years have passed and even the
most pathetically obsolete Enterprice Distro installation has updated
to something more recent.  But the reason why dir_nlink was defined as
an RO_INCOMPAT feature (EXT4_FEATURE_RO_COMPAT_DIR_NLINK) was because
a dir_nlink oblivious kernel could get upset when trying to rmdir a
directory where n_link was 1.

> > The fact that we've gone ten years without anyone noticing or complaining
> More accurately, we've gone ten years before people connected the dots. This
> time, the original bug report was about 'ls'.

Can you give me a pointer to the original bug report?  I'm curious how
things were misbehaving.

> From my point of view The worst thing about all this, is that the dir_nlink
> feature is misdocumented and does not work as intended (i.e., it's a flag
> that
> in effect cannot be turned off). Either dir_nlink needs to be documented and
> fixed; or failing that, the dir_nlink flag should be withdrawn and the ext4
> documentation should clearly say that the link count of a directory is
> permanently set to 1 after it overflows past 64999. If you take the latter
> approach, you needn't update the ext4 code at all, just the documentation
> (though the documentation should note that 64999 is off-by-one compared to
> the
> 65000 that is nominally the maximum link count).

There was a time when we tried documenting things in terms that users
could understand, as opposed to going into gory details that only a fs
programmer would love.  And that retrospect as a mistake.  We should
have done both, with the civilian-friendly bit coming first.

It was also a mistake to have dir_nlink be automatically turned on in
the case of ext4 file systems.  As I said, we used to do this much
more often, and ten years ago we weren't so strict about this rule.
The issue is that at this point there are multiple implementations of
the ext2/3/4 file system format, and not just Linux, so we can't
assume that turning on some feature which is supported by a particular
Linux kernel won't break things on some other implementation (e.g.,
Grub, BSD etc.).  It was a bad idea back then as well because
sometimes people want to downgrade to old kernels, so having a new
kernel automatically do something which causes the file system to
become unmountable by a new kernel is unfriendly.  Since dir_nlink was
close to one of the first ext4 features that was added, it was perhaps
more excusable --- but it was still wrong.

The problem withdrawing the feature is that it would break a lot of
users who want to have more than 65,000 subdirectories.  Ext4 has been
out there for a long time, and while it's true that many people don't
create directory trees which are that bushy, I've gotten people
screaming at us for much more minor bugs.  So that's why I'm curious
to see the original ls bug.  (Maybe because most people don't use ls
-lR on huge directory trees, because they don't like to grow old
waiting for it to complete?  :-)

So I think the right thing to do is to fix the documentation.  We
actually added the feature first, and only added the documentation
much later, so it is the documentation which is wrong.  So this is not
a case of writing the spec first and then implementing to the spec.
This is much more like Unix came first, and Posix came later to
document how Unix worked.  Except we weren't smart enough to add a
clause, as Posix did, that anything that was allowed to use the
Unix(tm) trademark was automatically spec/documentation compliant.  :-)

And even before we added the documentation, it wasn't like it was a
secret; it was just not that well known.  But there were some blog
entries that talked about it[1], and the description of how it worked
was in the git commit message.

[1] https://www.whatastruggle.com/maximum-number-of-sub-directories-in-ext4

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
