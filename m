From: Milan Broz <mbroz@redhat.com>
Subject: Re: ext4: Fix data corruption with multi-block writepages support
Date: Mon, 07 Feb 2011 21:51:38 +0100
Message-ID: <4D505B5A.1000203@redhat.com>
References: <AANLkTi=gcf=A_6Kp6h7s2+OkxR4YUb6gqzc43asn-wfK@mail.gmail.com> <20110207174552.GC3457@thunk.org> <4D503A06.3010403@redhat.com> <20110207204419.GE3457@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "Ted Ts'o" <tytso@mit.edu>, Matt <jackdachef@gmail.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41067 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754091Ab1BGUvm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Feb 2011 15:51:42 -0500
In-Reply-To: <20110207204419.GE3457@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 02/07/2011 09:44 PM, Ted Ts'o wrote:
> So the fact that we found and fixed an ext4 bug that was triggered by
> dm_crypt should not be taken as a statement (one way or the other)
> that dm_crypt is Bug-Free(tm).  :-)

Really? Sigh. ;-)

(There is a rule that if dm-crypt+XFS bug appears, the problem
is always in dm-crypt. So I am quite surprised that this time there
was NO bug in dm-crypt... yet :-)

Anyway, I would like to know if still some problem remains...

Thanks,
Milan
