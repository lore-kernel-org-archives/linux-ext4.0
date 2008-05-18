From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Date: Sun, 18 May 2008 21:59:40 +0200
Message-ID: <87abincrir.fsf@basil.nowhere.org>
References: <482DDA56.6000301@redhat.com> <20080517002030.GA7374@mit.edu>
	<20080516173552.e88183d9.akpm@linux-foundation.org>
	<200805172048.34455.chris.mason@oracle.com>
	<20080518013641.GH16496@mit.edu>
	<4830420D.4080608__28835.4277647615$1211137279$gmane$org@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	linux-ker@firstfloor.org
To: Ric Wheeler <ricwheeler@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:59897 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794AbYERUCo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 18 May 2008 16:02:44 -0400
In-Reply-To: <4830420D.4080608__28835.4277647615$1211137279$gmane$org@gmail.com> (Ric Wheeler's message of "Sun, 18 May 2008 10:49:49 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ric Wheeler <ricwheeler@gmail.com> writes:
>
> The hard thing is to figure out how to test this kind of scenario
> without dropping power. To expose the failure mode, it might be

Why not drop power? (see test scenario in previous mail) 

There are lots of cheap ways available to do that.
I personally keep my test machines on cheap USB power switches and 
can switch them any time. 

It will probably lower the MTBF of your test boxes somewhat 
though, but that's the price for good testing.

> Just a personal note, my last day at EMC was this past Friday. Monday,
> I start working for Red Hat (focused on file systems) so I will have
> to figure out to get this kind of test going without all of my big EMC
> toys ;-)

Congratulations on the new job. I don't think you need any big toys though.

-Andi
