From: Ray Morris <support@bettercgi.com>
Subject: Re: [linux-lvm] [dm-devel] do not disable ext4 discards on first
 discard failure? [was: Re: dm snapshot: ignore discards issued to the
 snapshot-origin target]
Date: Fri, 29 Apr 2011 10:13:25 -0500
Message-ID: <20110429101325.1e0f57ec@bettercgi.com>
References: <20110412234706.GA11244@redhat.com>
	<20cf301cbef67d323104a0c2ff52@google.com>
	<20110413224025.GA18589@redhat.com>
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
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: sandeen@redhat.com, Christoph Hellwig <hch@infradead.org>,
	Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
	DarkNovaNick@gmail.com, Lukas Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org
To: LVM general discussion and development <linux-lvm@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ps536.phatservers.com ([216.17.105.202]:44814 "EHLO
	ps536.phatservers.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759891Ab1D2QRJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Apr 2011 12:17:09 -0400
In-Reply-To: <4DBACB23.80607@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On 4/29/11 7:29 AM, Christoph Hellwig wrote:
> > no one else picked up that stupid idea.  If ext4 wants to
> > misbehave for that just let them..
> 
> It was my "stupid idea," and I'm ok with reverting it ;)
> 
> -Eric

http://www.google.com/search?q=how+to+remove+foot+from+mouth
-- 
Ray Morris
support@bettercgi.com

Strongbox - The next generation in site security:
http://www.bettercgi.com/strongbox/

Throttlebox - Intelligent Bandwidth Control
http://www.bettercgi.com/throttlebox/

Strongbox / Throttlebox affiliate program:
http://www.bettercgi.com/affiliates/user/register.php




On Fri, 29 Apr 2011 09:28:51 -0500
Eric Sandeen <sandeen@redhat.com> wrote:

> On 4/29/11 7:29 AM, Christoph Hellwig wrote:
> > FYI, that disable discard on failure seems to be an ext4 special
> > and no one else picked up that stupid idea.  If ext4 wants to
> > misbehave for that just let them..
> 
> It was my "stupid idea," and I'm ok with reverting it ;)
> 
> -Eric
> _______________________________________________
> linux-lvm mailing list
> linux-lvm@redhat.com
> https://www.redhat.com/mailman/listinfo/linux-lvm
> read the LVM HOW-TO at http://tldp.org/HOWTO/LVM-HOWTO/
> 

