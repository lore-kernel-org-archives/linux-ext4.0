From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Filesystem state: clean with errors - what errors?
Date: Tue, 4 Jun 2013 09:49:38 -0400
Message-ID: <20130604134938.GC23132@thunk.org>
References: <CADzUK1K08XjYuz_Mrv6sF8e7-M9ToStfjN7e7s3v+2q9wX+-xQ@mail.gmail.com>
 <51ACEAEF.6040109@redhat.com>
 <CADzUK1KXvQbb+jUK=JpYLXD1S+-dCLnYRU8Dc+mPDf3b4ipU8A@mail.gmail.com>
 <51ACEFA8.8000907@redhat.com>
 <CADzUK1JvWW=YkS2e1gZM=Zt3SDKbhLhqH0_i_UnVLhBY51r2Nw@mail.gmail.com>
 <51ACF922.2050306@redhat.com>
 <CADzUK1JyZA=2+yn7K30K5te-cZTiS0RY9L8YYKn+Dr1JxhHOtQ@mail.gmail.com>
 <CADzUK1+fVXBWjuhEJpQp3skSkxxa7oM=KKM370LacVAyqY0TeQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Autif Khan <autif.mlist@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54677 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317Ab3FDNto (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Jun 2013 09:49:44 -0400
Content-Disposition: inline
In-Reply-To: <CADzUK1+fVXBWjuhEJpQp3skSkxxa7oM=KKM370LacVAyqY0TeQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hmm... what version of e2fsprogs are you using?  Is there any chance
it's older than 1.42.4?  Hmmm, yes, you're using a positively ancient
(and filled with bugs that have since been fixed e2fsprogs 1.42).

I suspect you're getting hit bug a problem which we fixed in e2fsprogs
1.42.4 (and you *REALLY* want to upgrade to the latest released
version of e2fsprogs):

   Fixed e2fsck's handling of the journal's s_errno field.  E2fsck was
   not properly propagating the journal's s_errno field to the superblock
   field; it was not checking this field if the journal had already been
   replayed, and if the journal *was* being replayed, the "error bit"
   wasn't getting flushed out to disk.

The kernel side fix for this particular issue (if this is what is
going on) is:

commit d796c52ef0b71a988364f6109aeb63d79c5b116b
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Sun Aug 5 19:04:57 2012 -0400

    ext4: make sure the journal sb is written in ext4_clear_journal_err()
    
    After we transfer set the EXT4_ERROR_FS bit in the file system
    superblock, it's not enough to call jbd2_journal_clear_err() to clear
    the error indication from journal superblock --- we need to call
    jbd2_journal_update_sb_errno() as well.  Otherwise, when the root file
    system is mounted read-only, the journal is replayed, and the error
    indicator is transferred to the superblock --- but the s_errno field
    in the jbd2 superblock is left set (since although we cleared it in
    memory, we never flushed it out to disk).
    
    This can end up confusing e2fsck.  We should make e2fsck more robust
    in this case, but the kernel shouldn't be leaving things in this
    confused state, either.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
    Cc: stable@kernel.org

... which first appeared in the 3.6 kernel, and which for some reason
was never backported to the 3.2 stable series.

Regards,

						- Ted
