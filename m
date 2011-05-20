From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH v2 1/2] e2fsprogs: Fix how we treat user-spcified filesystem
 size
Date: Fri, 20 May 2011 14:22:44 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1105201421060.5226@dhcp-27-109.brq.redhat.com>
References: <1297256607-4654-1-git-send-email-lczerner@redhat.com> <4DD57E69.5040601@redhat.com> <alpine.LFD.2.00.1105201021230.5226@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	tytso@MIT.EDU, adilger@dilger.ca
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56400 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935420Ab1ETMWu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 May 2011 08:22:50 -0400
In-Reply-To: <alpine.LFD.2.00.1105201021230.5226@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 20 May 2011, Lukas Czerner wrote:

> > > diff --git a/resize/resize2fs.8.in b/resize/resize2fs.8.in
> > > index e02345d..769fd14 100644
> > > --- a/resize/resize2fs.8.in
> > > +++ b/resize/resize2fs.8.in
> > > @@ -38,27 +38,20 @@ The
> > >  parameter specifies the requested new size of the filesystem.
> > >  If no units are specified, the units of the
> > >  .I size
> > > -parameter shall be the filesystem blocksize of the filesystem.
> > > +parameter shall be the blocks count of the filesystem.
> > 
> > shall be equal to the filesystem blocksize ...
> > 

I actually shall be the blocks count, not blocksize. Resizefs knows what
the blocksize is already, it just needs to know what the new size should
be.

Thanks!
-Lukas
