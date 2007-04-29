From: Mark Lord <lkml@rtr.ca>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when
 FS is under heavy write load (massive starvation)
Date: Sun, 29 Apr 2007 16:49:27 -0400
Message-ID: <463504D7.7040002@rtr.ca>
References: <1177660767.6567.41.camel@Homer.simpson.net>	 <20070427013350.d0d7ac38.akpm@linux-foundation.org>	 <Pine.LNX.4.64.0704282242280.16099@artax.karlin.mff.cuni.cz> <75b66ecd0704281412x33352e97kc9c646ea594ef9ee@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Galbraith <efault@gmx.de>,
	LKML <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jens Axboe <jens.axboe@oracle.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Lee Revell <rlrevell@joe-job.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rtr.ca ([64.26.128.89]:1587 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031393AbXD2Ut3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 29 Apr 2007 16:49:29 -0400
In-Reply-To: <75b66ecd0704281412x33352e97kc9c646ea594ef9ee@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Lee Revell wrote:
> On 4/28/07, Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz> wrote:
>> I most wonder, why vim fsyncs its swapfile regularly (blocking typing
>> during that) and doesn't fsync the resulting file on :w  :-/
> 
> Never seen this.  Why would fsync block typing unless vim was doing
> disk IO for every keystroke?

It does do that, for the crash-recovery files it maintains.
