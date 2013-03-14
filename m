From: Lenky Gao <lenky.gao@gmail.com>
Subject: Re: Inactive memory keep growing and how to release it?
Date: Thu, 14 Mar 2013 16:00:28 +0800
Message-ID: <CAAO_Xo4FW9L=1F2+wAC7qX54foO0u6mr_sECD2sed=pkVk038g@mail.gmail.com>
References: <CAAO_Xo5g2LR54ry=SU7UhGbv-chdkdd6foq+-LjnuE8yAj8ikg@mail.gmail.com>
	<20130312083711.GA1943@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:33399 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989Ab3CNIA3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Mar 2013 04:00:29 -0400
Received: by mail-we0-f172.google.com with SMTP id d46so1807448wer.31
        for <linux-ext4@vger.kernel.org>; Thu, 14 Mar 2013 01:00:28 -0700 (PDT)
In-Reply-To: <20130312083711.GA1943@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Everyone,

Maybe i have found the answer for this question. The author of the JBD
have explained in the comments:

/*
 * When an ext3-ordered file is truncated, it is possible that many pages are
 * not successfully freed, because they are attached to a committing
transaction.
 * After the transaction commits, these pages are left on the LRU, with no
 * ->mapping, and with attached buffers.  These pages are trivially reclaimable
 * by the VM, but their apparent absence upsets the VM accounting, and it makes
 * the numbers in /proc/meminfo look odd.
...
 */
static void release_buffer_page(struct buffer_head *bh)
{
	struct page *page;
...

But my new question is why not free those pages after the transaction commits?



-- 
Regards,

Lenky
