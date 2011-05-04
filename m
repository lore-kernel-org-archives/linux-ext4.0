From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [dm-devel] do not disable ext4 discards on first discard
 failure? [was: Re: dm snapshot: ignore discards issued to the
 snapshot-origin target]
Date: Wed, 4 May 2011 12:33:17 -0400
Message-ID: <20110504163317.GA17529@thunk.org>
References: <20110413224025.GA18589@redhat.com>
 <20110413234854.GA19793@redhat.com>
 <20110426173213.GA19604@redhat.com>
 <20110428001912.GA14659@redhat.com>
 <20110428075355.GA2190@infradead.org>
 <20110428205935.GA24979@redhat.com>
 <alpine.LFD.2.00.1104291117510.5496@dhcp-27-109.brq.redhat.com>
 <20110429122454.GL32370@agk-dp.fab.redhat.com>
 <20110429122906.GA7381@infradead.org>
 <4DBACB23.80607@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Lukas Czerner <lczerner@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
	DarkNovaNick@gmail.com, linux-lvm@redhat.com,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49251 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528Ab1EDQd0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 May 2011 12:33:26 -0400
Content-Disposition: inline
In-Reply-To: <4DBACB23.80607@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 29, 2011 at 09:28:51AM -0500, Eric Sandeen wrote:
> On 4/29/11 7:29 AM, Christoph Hellwig wrote:
> > FYI, that disable discard on failure seems to be an ext4 special and no
> > one else picked up that stupid idea.  If ext4 wants to misbehave for
> > that just let them..
> 
> It was my "stupid idea," and I'm ok with reverting it ;)

I think I forgot to send the patch out, but it's been reverted in the
ext4 master branch, commit id: d9f34504e695.  It's more than a revert,
actually, since I also dropped error checking for FITRIM.  Otherwise
an attempt to use FITRIM would stop after hitting the first dm region
that didn't support discards.

						- Ted
