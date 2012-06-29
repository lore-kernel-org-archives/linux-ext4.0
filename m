From: Andrew Perepechko <anserper@ya.ru>
Subject: dead/wrong code in ext3/4_releasepage()
Date: Fri, 29 Jun 2012 20:52:51 +0400
Message-ID: <4FEDDD63.4000800@ya.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from forward1h.mail.yandex.net ([84.201.187.146]:50807 "EHLO
	forward1h.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755855Ab2F2Q7Q (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Jun 2012 12:59:16 -0400
Received: from smtp4h.mail.yandex.net (smtp4h.mail.yandex.net [84.201.186.21])
	by forward1h.mail.yandex.net (Yandex) with ESMTP id 64A6C9E321E
	for <linux-ext4@vger.kernel.org>; Fri, 29 Jun 2012 20:52:52 +0400 (MSK)
Received: from smtp4h.mail.yandex.net (localhost [127.0.0.1])
	by smtp4h.mail.yandex.net (Yandex) with ESMTP id 454132C0191
	for <linux-ext4@vger.kernel.org>; Fri, 29 Jun 2012 20:52:52 +0400 (MSK)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello!

The implementation of ext4_releasepage() for many kernel versions
(as well as current git) is the following:

static int ext4_releasepage(struct page *page, gfp_t wait)
{
         journal_t *journal = EXT4_JOURNAL(page->mapping->host);

         trace_ext4_releasepage(page);

         WARN_ON(PageChecked(page));
         if (!page_has_buffers(page))
                 return 0;
         if (journal)
                 return jbd2_journal_try_to_free_buffers(journal, page, 
wait);
         else
                 return try_to_free_buffers(page);
}

The "if (!page_has_buffers(page))" check seems to be attempting to
handle the "nobh" case. However, the correct return value for this case
seems to be 1 (success), not 0 (failure).

This does not lead to oom or any similar issue since calls to 
try_to_release_page()
are accompanied by page_has_private() checks.

If ->release_page() can be called without a prior check, then
the return code is wrong. Otherwise, the check is dead code.

What do you think?

Thank you,
Andrew
