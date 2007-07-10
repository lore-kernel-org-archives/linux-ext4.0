From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATHC] Fix for ext2 reservation (Re: -mm merge plans for
 2.6.23)
Date: Tue, 10 Jul 2007 16:55:07 -0700
Message-ID: <20070710165507.f8e61bb2.akpm@linux-foundation.org>
References: <20070710113704.8b20f3c3.akpm@linux-foundation.org>
	<4693E07E.4010300@mbligh.org>
	<1184105757.8390.6.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Martin Bligh <mbligh@mbligh.org>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Greg KH <greg@kroah.com>, Hugh Dickins <hugh@veritas.com>,
	Jeremy Orlow <jorlow@google.com>,
	Nick Piggin <piggin@cyberone.com.au>,
	Mingming Cao <cmm@us.ibm.com>,
	ext4 <linux-ext4@vger.kernel.org>,
	ltc-kernel <ltc-kernel@linux.ibm.com>, stable@kernel.org
To: Badari Pulavarty <pbadari@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39785 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754714AbXGJXzi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Jul 2007 19:55:38 -0400
In-Reply-To: <1184105757.8390.6.camel@dyn9047017100.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 10 Jul 2007 15:15:57 -0700
Badari Pulavarty <pbadari@us.ibm.com> wrote:

> Well, I looked at the problem now and here is the fix :)

whee, thanks.

> Greg, Please consider this for stable release also.

No, it is only relevant to -mm's ext2-reservations.patch.
