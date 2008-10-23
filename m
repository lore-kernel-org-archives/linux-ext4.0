From: Solofo.Ramangalahy@bull.net
Subject: Re: jbd/jbd2 performance improvements
Date: Thu, 23 Oct 2008 14:22:03 +0200
Message-ID: <18688.27755.969223.822862@frecb006361.adech.frec.bull.fr>
References: <E1KnCO6-0001qG-SV@closure.thunk.org>
	<48F62893.9060606@redhat.com>
	<18678.55651.556822.187508@frecb006361.adech.frec.bull.fr>
	<48F72E5F.2050409@redhat.com>
	<48F735E8.7060803@redhat.com>
	<18688.21800.641991.52484@frecb006361.adech.frec.bull.fr>
	<49006758.9020901@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Arjan De Ven <arjan.van.de.ven@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:46433 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307AbYJWMWU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Oct 2008 08:22:20 -0400
In-Reply-To: <49006758.9020901@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ric Wheeler writes:
 > Do you have any details on the test case that you ran that showed a 
 > clear improvement? What kind of storage & IO pattern did you use?

Is it possible to record latencytop output (like top batch mode) to
capture the highest latency during a test run?

Or how did you collect this:
>my reproducer is sadly very simple (claws-mail is my mail client that uses maildir)
>Process claws-mail (4896)                  Total: 2829.7 msec
>EXT3: Waiting for journal access                  2491.0 msec         88.4 %
>Writing back inodes                                160.9 msec          5.7 %
>synchronous write                                   78.8 msec          3.0 %
>is an example of such a trace (this is with patch, without patch the numbers are about 3x bigger)
>Waiting for journal access is "journal_get_write_access"
>Writing back inodes is "writeback_inodes"
>synchronous write is "do_sync_write"


-- 
solofo


