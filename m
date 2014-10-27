From: Chris Friesen <chris.friesen@windriver.com>
Subject: Re: RT/ext4/jbd2 circular dependency
Date: Mon, 27 Oct 2014 13:57:14 -0600
Message-ID: <544EA39A.1080005@windriver.com>
References: <544156FE.7070905@windriver.com> <54415991.1070907@pavlinux.ru> <CANGgnMbQmsdMDJUx7Bop9Xs=jQMmAJgWRjhXVFUGx-DwF=inYw@mail.gmail.com> <544940EF.7090907@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
	<linux-ext4@vger.kernel.org>, <tytso@mit.edu>,
	<adilger.kernel@dilger.ca>,
	rt-users <linux-rt-users@vger.kernel.org>
To: Austin Schuh <austin@peloton-tech.com>, <pavel@pavlinux.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail1.windriver.com ([147.11.146.13]:57759 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbaJ0T65 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Oct 2014 15:58:57 -0400
In-Reply-To: <544940EF.7090907@windriver.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/23/2014 11:54 AM, Chris Friesen wrote:

> Basically it looks like we have a circular dependency involving the
> inode->i_data_sem rt_mutex, the PG_writeback bit, and the BJ_Shadow list.  It
> goes something like this:
>
> jbd2_journal_commit_transaction:
> 1) set page for writeback (set PG_writeback bit)
> 2) put jbd2 journal head on BJ_Shadow list
> 3) sleep on PG_writeback bit waiting for page writeback complete
>
> ext4_da_writepages:
> 1) ext4_map_blocks() acquires inode->i_data_sem for writing
> 2) do_get_write_access() sleeps waiting for jbd2 journal head to come off
> the BJ_Shadow list
>
> At this point the flush code can't run because it can't acquire
> inode->i_data_sem for reading, so the page will never get written out.
> Deadlock.

Just curious...would we expect lockdep to detect this sort of thing?  I 
wasn't sure if the introduction of the two wait queues would cause 
complications.

Chris
