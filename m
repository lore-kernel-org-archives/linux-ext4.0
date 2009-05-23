From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13369] kernel BUG at fs/ext4/inode.c:3123
Date: Sat, 23 May 2009 15:06:19 GMT
Message-ID: <200905231506.n4NF6J09001647@demeter.kernel.org>
References: <bug-13369-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:39480 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726AbZEWPGS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 23 May 2009 11:06:18 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n4NF6Jqp001648
	for <linux-ext4@vger.kernel.org>; Sat, 23 May 2009 15:06:19 GMT
In-Reply-To: <bug-13369-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13369


Eric Sandeen <sandeen@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@redhat.com




--- Comment #2 from Eric Sandeen <sandeen@redhat.com>  2009-05-23 15:06:18 ---
This is:
static int ext4_normal_writepage(struct page *page,
                                struct writeback_control *wbc)
{
...
        if (page_has_buffers(page)) {
                /* if page has buffers it should all be mapped
                 * and allocated. If there are not buffers attached
                 * to the page we know the page is dirty but it lost
                 * buffers. That means that at some moment in time
                 * after write_begin() / write_end() has been called
                 * all buffers have been clean and thus they must have been
                 * written at least once. So they are all mapped and we can
                 * happily proceed with mapping them and writing the page.
                 */
                BUG_ON(walk_page_buffers(NULL, page_buffers(page), 0, len,
NULL,
                                        ext4_bh_unmapped_or_delay));
        }

Does ktorrent preallocate space?  You might try turning that off to see if it
goes away, as a hint.  I can't look at this much today, it's my birthday and
I'm going to have some non-computer fun.  ;)

If you want, you could modify the test in ext4_normal_writepage() at this spot
to something like:

        if (page_has_buffers(page)) {
                /*
                 * (big comment deleted)
                 */
                if (walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
                                        ext4_bh_unmapped_or_delay)) {
                        struct buffer_head *bh;

                        bh = (struct buffer_head *)page_private(page);
                        printk("bh state 0x%x\n", bh->b_state);
                        BUG();
                }
        }

so that we'd see the actual buffer head state that was wrong.  (this assumes
you have page-sized blocks; most likely true, if you have 4k blocks, which is
the mkfs default)

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
