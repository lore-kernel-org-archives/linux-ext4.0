From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Question on fallocate/ftruncate sequence
Date: Tue, 21 Jul 2009 17:03:44 -0500
Message-ID: <4A663B40.6060009@redhat.com>
References: <6601abe90907200936w61ebda92reae368a2b9efac66@mail.gmail.com> <4A64F37D.7020803@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:59678 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754938AbZGUWDt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Jul 2009 18:03:49 -0400
In-Reply-To: <4A64F37D.7020803@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:

> Yep, I think you've found a bug, I will look into this soon unless
> someone beats me to it :)

FWIW this'd be a great test to add to the xfstests test suite (it would
test ext4 for this too)  I could do it but external contributions are
welcomed and encouraged, hint hint ;)

The xfs_io "falloc -k" command will do fallocate with KEEP_SIZE.

-Eric
