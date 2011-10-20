From: Andy Lutomirski <luto@amacapital.net>
Subject: Latency writing to an mlocked ext4 mapping
Date: Wed, 19 Oct 2011 17:39:37 -0700
Message-ID: <CALCETrXbPWsgaZmsvHZGEX-CxB579tG+zusXiYhR-13RcEnGvQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:44620 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755501Ab1JTAji (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Oct 2011 20:39:38 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I have a real-time program that has everything mlocked (i.e.
mlockall(MCL_CURRENT | MCL_FUTURE)).  It has some log files opened for
writing.  Those files are opened and memset to zero in another thread
to fault everything in.  The system is under light I/O load with very
little memory pressure.

Latencytop shows frequent latency in the real-time threads.  The main
offenders are:

schedule sleep_on_page wait_on_page_bit ext4_page_mkwrite do_wp_page
handle_pte_fault handle_mm_fault do_page_fault page_fault

schedule do_get_write_access jbd2_journal_get_write_access
__ext4_journal_get_write_access ext4_reserve_inode_write
ext4_mark_inode_dirty ext4_dirty_inode __mark_inode_dirty
file_update_time do_wp_page handle_pte_fault handle_mm_fault


I imagine the problem is that the system is periodically writing out
my dirty pages and marking them clean (and hence write protected).
When I try to write to them, the kernel makes them writable again,
which causes latency either due to updating the inode mtime or because
the file is being written to disk when I try to write to it.

Is there any way to prevent this?  One possibility would be a way to
ask the kernel not to write the file out to disk.  Another would be a
way to ask the kernel to make a copy of the file when it writes it
disk and leave the original mapping writable.

Obviously I can fix this by mapping anonymous memory, but then I need
another thread to periodically write my logs out to disk, and if that
crashes, I lose data.

-- 
Andy Lutomirski
AMA Capital Management, LLC
Office: (310) 553-5322
Mobile: (650) 906-0647
