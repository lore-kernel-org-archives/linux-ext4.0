From: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>
Subject: Re: Bug#615998: linux-image-2.6.32-5-xen-amd64: Repeatable "kernel
 BUG at fs/jbd2/commit.c:534" from Postfix on ext4
Date: Thu, 23 Jun 2011 16:19:08 -0500
Message-ID: <404FD5CC-8F27-4336-B7D4-10675C53A588@boeing.com>
References: <20110301165239.3310.43806.reportbug@support.exmeritus.com>
 <15E8241A-37A0-4438-849E-A157A376C7F1@boeing.com>
 <8658F8EE-A52D-4405-A1F3-C0247AB3EA6D@boeing.com>
 <26AE8923-4DEA-43FF-8F79-1D5AA665A344@boeing.com>
 <20110405230538.GH2832@thunk.org>
 <FD93E462-D97B-411B-BF09-9A64670AC5C2@boeing.com>
 <AF621113-8320-4973-A88A-1FC048EA4293@boeing.com>
 <BANLkTi=5BLA07tvbv3PFcZ0cc8FmBtg+UA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "Ted Ts'o" <tytso@mit.edu>,
	"615998@bugs.debian.org" <615998@bugs.debian.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Sachin Sant <sachinp@in.ibm.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Sean Ryle <seanbo@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from stl-smtpout-01.boeing.com ([130.76.96.56]:35776 "EHLO
	stl-smtpout-01.boeing.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760035Ab1FWWno convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Jun 2011 18:43:44 -0400
In-Reply-To: <BANLkTi=5BLA07tvbv3PFcZ0cc8FmBtg+UA@mail.gmail.com>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jun 23, 2011, at 16:55, Sean Ryle wrote:
> Maybe I am wrong here, but shouldn't the cast be to (unsigned long) or to (sector_t)?
> 
> Line 534 of commit.c:
>                         jbd_debug(4, "JBD: got buffer %llu (%p)\n",
>                                 (unsigned long long)bh->b_blocknr, bh->b_data);

No, that printk() is fine, the format string says "%llu" so the cast is
unsigned long long.

Besides which, line 534 in the Debian 2.6.32 kernel I am using is this
one:

  J_ASSERT(commit_transaction->t_nr_buffers <=
           commit_transaction->t_outstanding_credits);

If somebody can tell me what information would help to debug this I'd be
more than happy to throw a whole bunch of debug printks under that error
condition and try to trigger the crash with that.

Alternatively I could remove that J_ASSERT() and instead add some debug
further down around the "commit_transaction->t_outstanding_credits--;"
to try to see exactly what IO it's handling when it runs out of credits.

Any ideas?

Cheers,
Kyle Moffett
