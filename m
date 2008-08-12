From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: tracepoints in ext4 (and/or ext3?)
Date: Mon, 11 Aug 2008 22:30:26 -0500
Message-ID: <48A103D2.3000901@redhat.com>
References: <48A09E7F.7060605@redhat.com> <20080812032335.GC21194@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45468 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163AbYHLDbD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Aug 2008 23:31:03 -0400
In-Reply-To: <20080812032335.GC21194@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Mon, Aug 11, 2008 at 03:18:07PM -0500, Eric Sandeen wrote:
>> As just an initial inquiry, I'm wondering how people would feel about
>> putting some tracepoints (trace_mark()) into ext[34] for monitoring the
>> fs behavior.
> 
> I think it's a great idea!  Do you have some specific tracepoints in
> mind?

I'll start thinking of some ;)

tracepoints were a hot topic upstream it seemed, so I figured I'd make
sure people were amenable to instrumenting ext$X before I started in.

Thanks,
-Eric
