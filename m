From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: [Bug 17361] Watchdog detected hard LOCKUP in jbd2_journal_get_write_access
Date: Mon, 11 Oct 2010 14:43:58 -0600
Message-ID: <CBEC43EB-8CCC-40A4-85A7-4F130BAE7670@dilger.ca>
References: <bug-17361-13602@https.bugzilla.kernel.org/> <201010021642.o92Ggp1A007965@demeter1.kernel.org>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4 development <linux-ext4@vger.kernel.org>
To: Christian Casteyde <casteyde.christian@free.fr>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:49689 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755126Ab0JKUrn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Oct 2010 16:47:43 -0400
In-Reply-To: <201010021642.o92Ggp1A007965@demeter1.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On 2010-10-02, at 09:42, Theodore Tso <tytso@mit.edu> wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=17361
> 
> Except for the initial bug report, none of the other stack traces have anything to do with ext4/jbd2.    And in the initial ext4 trace, we see the complaint that we're calling might_sleep() in ext4_mark_inode_dirty(), in a code path where we are manifestly not taking any spinlocks.    And in fact we don't see any spinlocks being taken at the point where the complaint is mode in ext4_mark_inode_dirty().   Yet preempt_count > 1.

In my experience, this is typically caused by stack overflow smashing the task struct and randomly setting preempt_count to a non-zero value.

Cheers, Andreas





