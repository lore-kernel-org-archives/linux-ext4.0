From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [linux-lvm] do not disable ext4 discards on first discard
	failure? [was: Re: dm snapshot: ignore discards issued to the
	snapshot-origin target]
Date: Thu, 28 Apr 2011 23:59:45 +0100
Message-ID: <20110428225945.GG32370@agk-dp.fab.redhat.com>
References: <20110412234706.GA11244@redhat.com> <20cf301cbef67d323104a0c2ff52@google.com> <20110413224025.GA18589@redhat.com> <20110413234854.GA19793@redhat.com> <20110426173213.GA19604@redhat.com> <20110428001912.GA14659@redhat.com> <20110428075355.GA2190@infradead.org> <20110428205935.GA24979@redhat.com> <4DB9DBF1.9060901@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: LVM general discussion and development <linux-lvm@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>,
	Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com,
	linux-ext4@vger.kernel.or
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14370 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756397Ab1D1XAF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Apr 2011 19:00:05 -0400
Content-Disposition: inline
In-Reply-To: <4DB9DBF1.9060901@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 28, 2011 at 04:28:17PM -0500, Eric Sandeen wrote:
> I still think that concats of floppies, usb disks, and ssds should be rare, so I'm less concerned about that ;)

It's the 'undefined' cases that cause us the trouble though: we do have
to return something and I prefer to work with defined and documented
behaviour, rather than pretending something is 'undefined' or
'unimportant' and later finding people relied on its actual behaviour.

Alasdair

