From: Andrew Perepechko <anserper@ya.ru>
Subject: page eviction from the buddy cache
Date: Mon, 25 Mar 2013 16:59:44 +0400
Message-ID: <51504A40.6020604@ya.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: alexey.lyashkov@gmail.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from forward14.mail.yandex.net ([95.108.130.92]:38313 "EHLO
	forward14.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755409Ab3CYNF5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Mar 2013 09:05:57 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello!

Our recent investigation has found that pages from
the buddy cache are evicted too often as compared
to the expectation from their usage pattern. This
introduces additional reads during large writes under
our workload and really hurts overall performance.

ext4 uses find_get_page() and find_or_create_page()
to look for buddy cache pages, but these pages don't
get a chance to become activated until the following
lru_add_drain() call, because mark_page_accessed()
does not activate pages which are not PageLRU().

As can be found from a kprobe-based test, these pages
are often moved on the inactive LRU as a result of
shrink_inactive_list()->lru_add_drain() and immediately
evicted.

 From a quick look into linux-2.6.git, the issue seems
to exist in the current code as well.

A possible and, perhaps, non-optimal solution would be
to call lru_add_drain() each time a buddy cache page
is used.

Any other suggestions?

Thank you,
Andrew
