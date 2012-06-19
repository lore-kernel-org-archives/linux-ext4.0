From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: Ext4 and xfs problems in dm-thin on allocation and discard
Date: Tue, 19 Jun 2012 14:20:29 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1206191413460.21961@dhcp-1-248.brq.redhat.com>
References: <4FDF9EBE.2030809@shiftmail.org> <20120619015745.GJ25389@dastard> <20120619031241.GA3884@redhat.com> <alpine.LFD.2.00.1206190816440.2241@dhcp-1-248.brq.redhat.com> <4FE062B3.7080702@shiftmail.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="571144193-1915489382-1340108483=:21961"
Cc: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>,
	Dave Chinner <david@fromorbit.com>,
	device-mapper development <dm-devel@redhat.com>,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com
To: Spelic <spelic@shiftmail.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11588 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753163Ab2FSMVg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Jun 2012 08:21:36 -0400
In-Reply-To: <4FE062B3.7080702@shiftmail.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--571144193-1915489382-1340108483=:21961
Content-Type: TEXT/PLAIN; charset=windows-1252
Content-Transfer-Encoding: 8BIT

On Tue, 19 Jun 2012, Spelic wrote:

> Date: Tue, 19 Jun 2012 13:29:55 +0200
> From: Spelic <spelic@shiftmail.org>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: Mike Snitzer <snitzer@redhat.com>, Dave Chinner <david@fromorbit.com>,
>     Spelic <spelic@shiftmail.org>,
>     device-mapper development <dm-devel@redhat.com>,
>     linux-ext4@vger.kernel.org, xfs@oss.sgi.com
> Subject: Re: Ext4 and xfs problems in dm-thin on allocation and discard
> 
> On 06/19/12 08:32, Lukáš Czerner wrote:
> > 
> > So do I understand correctly that even though the discard came
> > through and thinp took advantage of it it still returns EOPNOTSUPP ?
> > This seems rather suboptimal. IIRC there was a discussion to add an
> > option to enable/disable sending discard in thinp target down
> > to the device.
> 
> I'll ask this too...
> do I understand correctly that dm-thin returns EOPNOTSUPP to the filesystem
> layer even though it is using the discard to unmap blocks, and at that point
> XFS stops sending discards down there (while ext4 keeps sending them)?
> 
> This looks like a bug of dm-thin to me. Discards are "supported" in such a
> scenario.
> 
> Do you have a patch for dm-thin so to prevent it sending EOPTNOTSUPP ?

Yes, definitely this behaviour need to change in dm-thin. I do not
have a path, it was merely a proposal how thing could be done. Not
sure what Mike and rest of the dm folks think about this.

-Lukas

> 
> Thank you
> S.
> 
--571144193-1915489382-1340108483=:21961--
