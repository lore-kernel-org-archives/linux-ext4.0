From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH 3/3] ext4: optimize locking for end_io extent conversion
Date: Tue, 1 Nov 2011 06:30:45 -0400
Message-ID: <0EF9455C-A950-43A6-8B01-9A5396AA575B@mit.edu>
References: <20111031150206.GC16825@thunk.org> <1320073367-28916-1-git-send-email-tytso@mit.edu> <1320073367-28916-3-git-send-email-tytso@mit.edu> <CAFcGZ=K5hLLkyGSzpxUCyaAuBjHu16Q_GCUpB0pP956gs8i1mQ@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Theodore Tso <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Tao Ma <taoma.tm@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-3.MIT.EDU ([18.9.25.14]:50176 "EHLO
	dmz-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752986Ab1KAKar convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Nov 2011 06:30:47 -0400
In-Reply-To: <CAFcGZ=K5hLLkyGSzpxUCyaAuBjHu16Q_GCUpB0pP956gs8i1mQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Oct 31, 2011, at 10:51 PM, Tao Ma wrote:

>>        if (!mutex_trylock(&inode->i_mutex)) {
> So here, we spin_lock first and then mutex_lock.
> But in  ext4_flush_completed_IO, we mutex_lock first and
> then spin_lock. Will lockdep complain about it?
> Other than that, the patch looks good to me.

It won't complain because it's a mutex_trylock(); so by definition it can't cause a deadlock.

-- Ted


