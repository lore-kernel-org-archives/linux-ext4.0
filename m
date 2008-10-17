From: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
Subject: undelete still opened file
Date: Fri, 17 Oct 2008 12:08:52 +0200
Message-ID: <20081017120852.1f04dc36.taeuber@bbaw.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.bbaw.de ([194.95.188.6]:58907 "EHLO mail.bbaw.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753493AbYJQK0D (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Oct 2008 06:26:03 -0400
Received: from mailhub.bbaw.de (unknown [192.168.4.1])
	by mail.bbaw.de (Postfix) with ESMTP id BE8B04A8059
	for <linux-ext4@vger.kernel.org>; Fri, 17 Oct 2008 12:07:37 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by mailhub.bbaw.de (Postfix) with ESMTP id 0A36593794
	for <linux-ext4@vger.kernel.org>; Fri, 17 Oct 2008 12:07:38 +0200 (CEST)
Received: from taeuber.bbaw.de (taeuber.bbaw.de [192.168.1.148])
	by mailhub.bbaw.de (Postfix) with SMTP id EBC2D9378F
	for <linux-ext4@vger.kernel.org>; Fri, 17 Oct 2008 12:07:37 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi there!

If this should be the wrong mailing list please excuse me but I didn't find any better suiting.
I just subscribed after unsuccessfully searching on the net for an answer to my question.

Is it possible to undelete an accidentally deleted file that is still opened by a process?
As far as I know the file is not really deleted as long there is a file descriptor connected to the file.
I thought about something in connection with /proc/####/fd/# .
Is there any chance to get the file back to normal?

- Linux 2.6.[12]x
- ext3 or nfs (should be independent of fs, wouldn't it?)


Thanks and best regards.
Lars


PS: Sorry for my english.
