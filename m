From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [linux-lvm] do not disable ext4 discards on first discard
	failure? [was: Re: dm snapshot: ignore discards issued to the
	snapshot-origin target]
Date: Fri, 29 Apr 2011 00:11:08 +0100
Message-ID: <20110428231108.GK32370@agk-dp.fab.redhat.com>
References: <20cf301cbef67d323104a0c2ff52@google.com> <20110413224025.GA18589@redhat.com> <20110413234854.GA19793@redhat.com> <20110426173213.GA19604@redhat.com> <20110428001912.GA14659@redhat.com> <20110428075355.GA2190@infradead.org> <20110428205935.GA24979@redhat.com> <4DB9DBF1.9060901@redhat.com> <20110428225945.GG32370@agk-dp.fab.redhat.com> <4DB9F1BE.7090208@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LVM general discussion and development <linux-lvm@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>,
	Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com,
	linux-ext4@vger.kernel.org, DarkNovaNick@gmail.com
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40294 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753388Ab1D1XLW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Apr 2011 19:11:22 -0400
Content-Disposition: inline
In-Reply-To: <4DB9F1BE.7090208@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 28, 2011 at 06:01:18PM -0500, Eric Sandeen wrote:
> If you are saying that a target should return EOPNOTSUPP when it does not support the operation, then we are in violent agreement.   :)
 
Naturally, with the definition you used in the first post.
(I.e. if the target does *anything* with it, you do not get that error, even
if it did not process it completely.)

Alasdair

