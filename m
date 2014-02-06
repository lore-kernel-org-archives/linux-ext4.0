From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Filesystem testing
Date: Wed, 05 Feb 2014 20:00:57 -0600
Message-ID: <52F2ECD9.90909@redhat.com>
References: <1391642427.40742.YahooMailNeo@web141002.mail.bf1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Mark Brown <ntdeveloper2002@yahoo.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753635AbaBFCA7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 5 Feb 2014 21:00:59 -0500
In-Reply-To: <1391642427.40742.YahooMailNeo@web141002.mail.bf1.yahoo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2/5/14, 5:20 PM, Mark Brown wrote:
> As an aside, I looked at xfstests, from what I could gather, it was
> started only for xfs, but there is ongoing work to make it work with
> ext4(and thus other posix FS?). If someone can point me to the
> documentation for xfstests and what it does, that would help. I could
> not find much.

xfstests has gone pretty far beyond just xfs at this point - it's seen
heavy use on ext2/3/4 as well as btrfs in the past several years.

There is a README in the git repo; did you have specific questions?

We have a lot of tests in there; some are general stress tests, some
are specific regression tests, and the body of tests is always growing.

Some test IO failures, as well.  File system consistency is checked after
each test.  Etc...

-Eric
