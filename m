From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: RE: [PATCH 1/2] ext4: introduce new i_write_mutex to protect fallocate
Date: Wed, 04 Jun 2014 14:58:06 +0900
Message-ID: <000f01cf7fb9$f4c4cfd0$de4e6f70$@samsung.com>
References: <001701cf6e40$fab98be0$f02ca3a0$@samsung.com>
 <alpine.LFD.2.00.1405291439340.18491@localhost.localdomain>
 <20140529162810.GG25041@thunk.org>
 <000c01cf7c9b$edaf2f90$c90d8eb0$@samsung.com>
 <20140602143807.GB30598@thunk.org>
 <001801cf7ef1$b01a85a0$104f90e0$@samsung.com>
 <20140603151958.GD12890@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Cc: =?iso-8859-2?Q?'Luk=E1=B9_Czerner'?= <lczerner@redhat.com>,
	'linux-ext4' <linux-ext4@vger.kernel.org>,
	'Ashish Sangwan' <a.sangwan@samsung.com>
To: 'Theodore Ts'o' <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:42725 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963AbaFDF6J (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Jun 2014 01:58:09 -0400
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0N6M004YPR8VDK20@mailout1.samsung.com> for
 linux-ext4@vger.kernel.org; Wed, 04 Jun 2014 14:58:07 +0900 (KST)
In-reply-to: <20140603151958.GD12890@thunk.org>
Content-language: ko
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> 
> On Tue, Jun 03, 2014 at 03:04:32PM +0900, Namjae Jeon wrote:
> > IMHO, If our goal is to solve the problem of xfstests, we can use only
> > "ext4: fix ZERO_RANGE test failure in data journalling" patch without
> > i_write_mutex patch. And we can add lock for fallocate on next kernel
> > after checking with sufficient time.
> 
> I thought this patch required i_write_mutex to avoid a race where
> another thread modifies an inode while filemap_write_and_wait_range()
> is running?
Yes, Right.
> 
> I agree that we could drop the i_write_mutex and add a call to
> ext4_force_commit() which should make the xfstest failure rarer, but
> the race would still be there, yes?
Yes, It is there but as Lukas said it is not critical than a possible
locking overhead. So, IMHO this is not something which needs urgent
attention and can be tackled properly after checking unclear
performance measurement on high-end server.

Thanks.
> 
> 						- Ted

