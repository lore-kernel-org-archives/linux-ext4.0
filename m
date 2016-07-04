From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/1]ext4: Fix WARN_ON_ONCE when marking buffer dirty
Date: Mon, 4 Jul 2016 10:29:38 -0400
Message-ID: <20160704142938.GB29557@thunk.org>
References: <1467285150-15977-1-git-send-email-pranjas@gmail.com>
 <1467285150-15977-2-git-send-email-pranjas@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: "Pranay Kr. Srivastava" <pranjas@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1467285150-15977-2-git-send-email-pranjas@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jun 30, 2016 at 02:12:30PM +0300, Pranay Kr. Srivastava wrote:
> Signed-off-by: Pranay Kr. Srivastava <pranjas@gmail.com>

The description for why the change is being made should go in the
commit.  (No need to put the description in a separate cover letter.)
I ended up rewriting the commit description as follows, to make it
much more understandable:

    ext4: Fix WARN_ON_ONCE in ext4_commit_super()

    If there are racing calls to ext4_commit_super() it's possible for
    another writeback of the superblock to result in the buffer being
    marked with an error after we check if the buffer is marked as
    having a write error and the buffer up-to-date flag is set again.
    If that happens mark_buffer_dirty() can end up throwing a
    WARN_ON_ONCE.

    Fix this by moving this check to write before we call
    write_buffer_dirty(), and keeping the buffer locked during this
    whole sequence.

    Signed-off-by: Pranay Kr. Srivastava <pranjas@gmail.com>
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Note that the one-line summary needs to carry as much information as
possible so someone who is scanning the commits using git log
--oneline has a chance of understanding it.  This means the high-level
*why* of the commit, not a summary of what the changes in the C code.
Also note the increased context of when the misbehaviour could occur
in the commit description, which was missing in the cover letter.

When I'm processing patches, if I'm in a hurry, patches that require
extra work or which aren't Obviously Right, sometimes get deferred by
a few days.  This patch fell in that category.

Adding to the commit descrtipion additional context and/or
instructions for how to reproduce the problem you are trying to
remediate will often make life much easier for me, and accelerate how
quickly I'll get to your patch.

Cheers,

							- Ted
