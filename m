From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: add max_dir_size_kb mount option
Date: Fri, 10 Aug 2012 14:38:10 -0500
Message-ID: <50256322.9040409@redhat.com>
References: <1344626638-31548-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8391 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755661Ab2HJTiO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 10 Aug 2012 15:38:14 -0400
In-Reply-To: <1344626638-31548-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 8/10/12 2:23 PM, Theodore Ts'o wrote:
> 
> So it is useful, in cloud server/data center environments, to be able
> to set a filesystem-wide cap on the maximum size of a directory, to
> ensure that directories never get larger than a sane size.  We do this
> via a new mount option, max_dir_size_kb.  If there is an attempt to
> grow the directory larger than max_dir_size_kb, the system call will
> return ENOSPC instead.

Can the commit message also describe more about the problem: how bad
it is, the root cause, and why it's so hard to fix properly?

Please also update Documentation/filesystems/ext4.txt so people
know for sure what the use & intent of this new knob is.

I guess it's self explanatory in the name but docs are easy & good.

-Eric
