From: =?GB2312?B?tqG2qLuq?= <dingdinghua85@gmail.com>
Subject: Should we discard jbddirty bit if BH_Freed is set?
Date: Wed, 27 Jan 2010 10:39:13 +0800
Message-ID: <7bb361261001261839w52466ca9t102ae88930baecf5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f173.google.com ([209.85.223.173]:57058 "EHLO
	mail-iw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473Ab0A0CjO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Jan 2010 21:39:14 -0500
Received: by iwn3 with SMTP id 3so1085296iwn.19
        for <linux-ext4@vger.kernel.org>; Tue, 26 Jan 2010 18:39:13 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all:
        I'm a little confused about BH_Freed bit. The only place it is
set is journal_unmap_buffer, which is called by
jbd2_journal_invalidatepage when we want to truncate a file. Since
jbd2_journal_invalidatepage is called outside of transaction, We can't
make sure whether the "add to orphan" operation belongs to committing
transaction or not,  so we can't touch the buffer belongs to
committing transaction, instead BH_Freed bit is set to indicate that
this buffer can be discarded in running transaction. But i think we
shouldn't clear BH_JBDdirty in jbd2_journal_commit_transaction, as
following codes does:
                /* A buffer which has been freed while still being
                 * journaled by a previous transaction may end up still
                 * being dirty here, but we want to avoid writing back
                 * that buffer in the future now that the last use has
                 * been committed.  That's not only a performance gain,
                 * it also stops aliasing problems if the buffer is lef=
t
                 * behind for writeback and gets reallocated for anothe=
r
                 * use in a different page. */
                if (buffer_freed(bh)) {
                        clear_buffer_freed(bh);
                        clear_buffer_jbddirty(bh);
                }
Note that, We can't make sure "current running transaction" can
complete commit work. If we clear BH_JBDdirty bit here, this buffer
may be freed here,  the log space of older transaction may be freed
before the "current running transaction" complete commit work, and if
this happends and system crashed at this moment, filesystem will be
inconsistent.

Above is my analysis, please let me know if it's wrong, and if it's a
bug, may be I can send a patch out, thanks.

--
=B6=A1=B6=A8=BB=AA
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
