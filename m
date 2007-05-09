From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: 2.6.21-ext4-1
Date: Wed, 09 May 2007 09:52:10 -0500
Message-ID: <4641E01A.50307@redhat.com>
References: <E1HiXab-0001QX-Sk@candygram.thunk.org> <1178571383.3933.8.camel@dyn9047017103.beaverton.ibm.com> <20070508025048.GC32602149@melbourne.sgi.com> <1178661957.4135.66.camel@dyn9047017103.beaverton.ibm.com> <20070508232449.GG85884050@sgi.com> <20070509143613.GA13375@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: David Chinner <dgc@sgi.com>, Mingming Cao <cmm@us.ibm.com>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Johann Lombardi <johann.lombardi@bull.net>,
	linux-kernel@vger.kernel.org
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:40496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753981AbXEIOz4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 May 2007 10:55:56 -0400
In-Reply-To: <20070509143613.GA13375@amitarora.in.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Amit K. Arora wrote:

> And, how does XFS behave now if we write to mmapped preallocated blocks,
> since XFS also doesn't have ->page_mkwrite() implemented as of date ?

unwritten extents remain unwritten after mmap() modifies them

http://oss.sgi.com/bugzilla/show_bug.cgi?id=418

:)

-Eric
