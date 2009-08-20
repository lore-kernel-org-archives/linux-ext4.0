From: =?UTF-8?B?7ZmN7IugIHNoaW4gaG9uZw==?= <hongshin@gmail.com>
Subject: jbd: a question on __log_wait_for_space()
Date: Thu, 20 Aug 2009 13:31:06 +0900
Message-ID: <2014bcab0908192131y71e02806u685273732d6a293a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-px0-f196.google.com ([209.85.216.196]:52161 "EHLO
	mail-px0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbZHTEbE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Aug 2009 00:31:04 -0400
Received: by pxi34 with SMTP id 34so2980169pxi.4
        for <linux-ext4@vger.kernel.org>; Wed, 19 Aug 2009 21:31:06 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi. I have a question on __log_wait_for_space() in jbd/checkpoint.c
while I read jbd code of Linux 2.6.30.4

In __log_wait_for_space(), it releases and re-takes journal->j_state_lock
in while loop (at line 139).

After the retaking the lock, it checks 'space_left < nblocks'. It seems that
it considers that the journal might be written during the lock
releasing and re-taking.

Then, is it necessary to check 'journal->j_flags & JFS_ABORT' again too?
I found that journal_t's j_flags is synchronized via j_state_lock. So, is there
any possiblity that j_flags value can be changed during the lock
releasing and re-taking?

Thank you

Sincerely
Shin Hong
