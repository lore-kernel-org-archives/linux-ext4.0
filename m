From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] Ext4 and xfs problems in dm-thin on allocation and
	discard
Date: Tue, 19 Jun 2012 15:43:16 +0100
Message-ID: <20120619144316.GD14208@agk-dp.fab.redhat.com>
References: <4FDF9EBE.2030809@shiftmail.org> <alpine.LFD.2.00.1206191601290.21961@dhcp-1-248.brq.redhat.com> <20120619141933.GC10637@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com,
	Spelic <spelic@shiftmail.org>
To: device-mapper development <dm-devel@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754409Ab2FSOnZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Jun 2012 10:43:25 -0400
Content-Disposition: inline
In-Reply-To: <20120619141933.GC10637@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 19, 2012 at 10:19:33AM -0400, Ted Ts'o wrote:
> One of the things which would be nice to be able to easily set up is a
> configuration where we get the benefits of thin provisioning with
> respect to snapshost, but where the underlying block device used by
> the file system is contiguous.  

We're tracking this requirement (for lvm2) here:
  https://bugzilla.redhat.com/show_bug.cgi?id=814737

Alasdair

