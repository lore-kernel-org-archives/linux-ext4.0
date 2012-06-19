From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] Ext4 and xfs problems in dm-thin on allocation and
	discard
Date: Tue, 19 Jun 2012 17:03:01 +0100
Message-ID: <20120619160300.GF14208@agk-dp.fab.redhat.com>
References: <4FDF9EBE.2030809@shiftmail.org> <alpine.LFD.2.00.1206191601290.21961@dhcp-1-248.brq.redhat.com> <20120619141933.GC10637@thunk.org> <20120619144316.GD14208@agk-dp.fab.redhat.com> <20120619152856.GB7225@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com,
	Spelic <spelic@shiftmail.org>
To: device-mapper development <dm-devel@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36674 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792Ab2FSQDK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Jun 2012 12:03:10 -0400
Content-Disposition: inline
In-Reply-To: <20120619152856.GB7225@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 19, 2012 at 11:28:56AM -0400, Mike Snitzer wrote:
> That is an lvm2 BZ but there is further kernel work needed.
 
In principle, userspace should already be able to handle the replumbing I
think.  (But when we work through the details of an online import, perhaps
we'll want some further kernel change for atomicity/speed reasons?  In 
particular we need to be able to do the last part of the metadata merge
quickly.)

Roughly:
1. rejig the lvm metadata for the new configuration [lvm]
  - appends the "whole LV" data to the pool's data
2. Generate metadata for the appended data and append this to the metadata area [dmpd]
3. suspend all the affected devices [lvm]
4. link the already-prepared metadata into the existing metadata [dmpd]
5. resume all the devices (now using the new extended pool)

Alasdair

