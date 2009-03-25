From: Don Porter <porterde@cs.utexas.edu>
Subject: Re: ext3 leaking buffer_heads
Date: Wed, 25 Mar 2009 02:04:25 -0500
Message-ID: <49C9D779.4030805@cs.utexas.edu>
References: <49C7E959.4010000@cs.utexas.edu> <49C80685.9060800@redhat.com> <49C961FE.1030704@cs.utexas.edu> <20090325004609.GF32307@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.cs.utexas.edu ([128.83.139.10]:53853 "EHLO
	mail.cs.utexas.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754951AbZCYHFo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Mar 2009 03:05:44 -0400
In-Reply-To: <20090325004609.GF32307@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> The journal is a fixed sized, circular log, so the buffer_head will be
> reused eventually.  In the case of memory pressure the unreferenced
> buffer_head will be freed, but since we never reference the contents
> of the journal, we could be more aggressive about freeing the
> buffer_head just to avoid pushing out more valuable memory contents
> when we start getting put under memory pressure.
>
> 					- Ted
>   

Thanks Ted.  This makes sense.

I am working on a research project that may require more aggressive 
reclaiming of these buffer_heads.  If I were to implement something, 
would this be an optimization the maintainers would be interested in?

Thanks again for the help,

Don
