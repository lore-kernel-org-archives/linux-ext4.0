From: bzzz@gerasimov.net
Subject: Re: Fw: Re: ICP, 3ware,  Areca?
Date: Wed, 08 Nov 2006 00:06:22 +0300
Message-ID: <m31wof2chd.fsf@bzzz.home.net>
References: <20061107114724.9c2cc644.akpm@osdl.org>
	<1162933193.8123.36.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@osdl.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [80.71.248.82] ([80.71.248.82]:54743 "EHLO gw.home.net")
	by vger.kernel.org with ESMTP id S1752901AbWKGVHX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Nov 2006 16:07:23 -0500
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
In-Reply-To: <1162933193.8123.36.camel@kleikamp.austin.ibm.com> (Dave Kleikamp's message of "Tue, 07 Nov 2006 14:59:52 -0600")
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>>>>> Dave Kleikamp (DK) writes:

 DK> On Tue, 2006-11-07 at 11:47 -0800, Andrew Morton wrote:
 >> Why is ext3 slow??

 DK> Allocation?  I don't see anything indicating that Bill is overwriting an
 DK> existing file, so there is block allocation and journaling overhead.  If
 DK> that's the case, it would be interesting to see how fast ext3 is when
 DK> overwriting a file.  Extents and delayed allocation should improve on
 DK> this a lot.  

this was my first suspiction as well. though in my testing on opteron
write achieved ~300MB/s consuming 100% cpu. so it would be interesting
to see vmstat output and actual cpu consumption.

thanks, Alex
