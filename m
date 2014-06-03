From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: introduce new i_write_mutex to protect
 fallocate
Date: Tue, 3 Jun 2014 11:19:58 -0400
Message-ID: <20140603151958.GD12890@thunk.org>
References: <001701cf6e40$fab98be0$f02ca3a0$@samsung.com>
 <alpine.LFD.2.00.1405291439340.18491@localhost.localdomain>
 <20140529162810.GG25041@thunk.org>
 <000c01cf7c9b$edaf2f90$c90d8eb0$@samsung.com>
 <20140602143807.GB30598@thunk.org>
 <001801cf7ef1$b01a85a0$104f90e0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: =?utf-8?B?J0x1a8OhxaE=?= Czerner' <lczerner@redhat.com>,
	'linux-ext4' <linux-ext4@vger.kernel.org>,
	'Ashish Sangwan' <a.sangwan@samsung.com>
To: Namjae Jeon <namjae.jeon@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48079 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754313AbaFCPUD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Jun 2014 11:20:03 -0400
Content-Disposition: inline
In-Reply-To: <001801cf7ef1$b01a85a0$104f90e0$@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 03, 2014 at 03:04:32PM +0900, Namjae Jeon wrote:
> IMHO, If our goal is to solve the problem of xfstests, we can use only
> "ext4: fix ZERO_RANGE test failure in data journalling" patch without
> i_write_mutex patch. And we can add lock for fallocate on next kernel
> after checking with sufficient time.

I thought this patch required i_write_mutex to avoid a race where
another thread modifies an inode while filemap_write_and_wait_range()
is running?

I agree that we could drop the i_write_mutex and add a call to
ext4_force_commit() which should make the xfstest failure rarer, but
the race would still be there, yes?

						- Ted
