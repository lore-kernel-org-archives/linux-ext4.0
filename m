From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: introduce new i_write_mutex to protect
 fallocate
Date: Sat, 7 Jun 2014 22:48:23 -0400
Message-ID: <20140608024823.GA3984@thunk.org>
References: <001701cf6e40$fab98be0$f02ca3a0$@samsung.com>
 <alpine.LFD.2.00.1405291439340.18491@localhost.localdomain>
 <20140529162810.GG25041@thunk.org>
 <000c01cf7c9b$edaf2f90$c90d8eb0$@samsung.com>
 <20140602143807.GB30598@thunk.org>
 <001801cf7ef1$b01a85a0$104f90e0$@samsung.com>
 <20140603151958.GD12890@thunk.org>
 <000f01cf7fb9$f4c4cfd0$de4e6f70$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: =?utf-8?B?J0x1a8OhxaE=?= Czerner' <lczerner@redhat.com>,
	'linux-ext4' <linux-ext4@vger.kernel.org>,
	'Ashish Sangwan' <a.sangwan@samsung.com>
To: Namjae Jeon <namjae.jeon@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:55976 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753256AbaFHCs3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 7 Jun 2014 22:48:29 -0400
Content-Disposition: inline
In-Reply-To: <000f01cf7fb9$f4c4cfd0$de4e6f70$@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 04, 2014 at 02:58:06PM +0900, Namjae Jeon wrote:
> Yes, It is there but as Lukas said it is not critical than a possible
> locking overhead. So, IMHO this is not something which needs urgent
> attention and can be tackled properly after checking unclear
> performance measurement on high-end server.

Fair enough, I've done my own testing and with the following modified
version of that patch it does seem to mostly avoid the xfstest failure
(even if there still is the possibility of a race).  So I'll drop the
i_write_mutex patch for now and make the necessary changes to the "fix
ZERO_RANGE test failure in data journalling" to avoid taking the
now-removed i_write_mutex.

Cheers,

						- Ted


