From: "Peter Meier" <meiepeter@gmail.com>
Subject: Re: Trying out 2.6.26-ext4-3
Date: Sun, 27 Jul 2008 11:52:51 +0000
Message-ID: <c354edc90807270452w4039bb29i778548aceee6f049@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:10722 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbYG0Lww (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 27 Jul 2008 07:52:52 -0400
Received: by wf-out-1314.google.com with SMTP id 27so5132451wfd.4
        for <linux-ext4@vger.kernel.org>; Sun, 27 Jul 2008 04:52:51 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi once more,

looking around further, I spotted this patch in the patch queue:

ext4_journal_credits_fix_for_writepages.patch

Again, I'm not a file system hacker, but if I understand the situa-
tion correctly, this patch aims to correct the number of credits
that write activity will try to reserve for a transaction in certain
situations and when using delayed allocation. I think this patch
gets it wrong in some way, and as a result tries to reserve an
amount of credits that far exceeds the maximum transaction
size for an ordinarz 128 MB journal, or maybe this hints at a
larger problem with delayed allocation of some kind.

So, it seems my options for continuing today's installation
activities are to try 2.6.26-ext4-3 but with the above patch re-
verted, or use 2.6.26-ext4-3 as is but disable delayed alloca-
tion via the mount option.

I'm very unsure about the ramifications of either. If I revert the
patch, will I get data corruption from having no solution to the
problem it attempts to fix? If I disable delayed allocation, will
my FS lose some magic I can't get back at a later date when
I renable it again? Or is delayed allocation purely a "runtime
feature" with no effects on the on-disk format?


Greetings,
Peter
