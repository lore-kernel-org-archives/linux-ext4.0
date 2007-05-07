From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH] - Make mke2fs.c defaults match mke2fs.conf defaults
Date: Mon, 7 May 2007 14:27:00 -0700
Message-ID: <20070507212700.GF8181@schatzie.adilger.int>
References: <463F545A.10903@redhat.com> <20070507194749.GG17180@thunk.org> <463F838D.9030508@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:45228 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966337AbXEGV1F (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 May 2007 17:27:05 -0400
Content-Disposition: inline
In-Reply-To: <463F838D.9030508@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On May 07, 2007  14:52 -0500, Eric Sandeen wrote:
> Theodore Tso wrote:
> > How likely do you think the case will be that mke2fs.conf would be
> > missing?  I'm trying to figure out how high priority of an item this
> > really is.
> 
> Well, not too likely, although for some reason I guess it happened in
> the installer root in FC6 or so.  That's what raised the issue.

Ah, good point - there are probably lots of installers and rescue disks
that grab mke2fs but don't know anything about /etc/mke2fs.conf.

> > We could enhance the profile code so that it could read in the profile
> > from a memory buffer, and simply compile /etc/mke2fs.conf into mke2fs,
> > but that adds bloat --- the question is how necessary do we think that
> > really is?
> 
> I guess it doesn't really sound *necessary* - it's just that if we have
> 2 different "defaults" and they drift, it can be confusing...

Since the shipped mke2fs.conf is only on the order of a few hundred bytes
I don't think it is a huge issue to include it.  I like the idea of it
being compiled into the code and yet consistent with the default install.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
