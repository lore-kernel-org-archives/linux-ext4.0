From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: fsck illegal bitmap block
Date: Tue, 7 May 2013 00:17:17 -0400
Message-ID: <20130507041717.GC12578@thunk.org>
References: <5187EB06.7030409@heisl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Stone <stone@heisl.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46785 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756946Ab3EGERV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 May 2013 00:17:21 -0400
Content-Disposition: inline
In-Reply-To: <5187EB06.7030409@heisl.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Can you send us the output of "dumpe2fs /dev/mapper/md2_nas"?  See
also the "REPORTING BUGS" section of e2fsck for more discussion of
useful information.

					- Ted
