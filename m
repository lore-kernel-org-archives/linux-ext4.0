From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 23/25] libext2fs: support modifying arbitrary extended
 attributes
Date: Fri, 29 Nov 2013 13:30:13 +0800
Message-ID: <20131129053013.GA25516@gmail.com>
References: <20131018044854.7339.48457.stgit@birch.djwong.org>
 <20131018045134.7339.30673.stgit@birch.djwong.org>
 <20131126072115.GA22136@gmail.com>
 <20131127015617.GC3068@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:51233 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab3K2F1V (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Nov 2013 00:27:21 -0500
Received: by mail-pb0-f52.google.com with SMTP id uo5so13791588pbc.11
        for <linux-ext4@vger.kernel.org>; Thu, 28 Nov 2013 21:27:21 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20131127015617.GC3068@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 26, 2013 at 05:56:17PM -0800, Darrick J. Wong wrote:
[...]
> > > +static struct ea_name_index ea_names[] = {
> > > +	{1, "user."},
> > > +	{2, "system.posix_acl_access"},
> > > +	{3, "system.posix_acl_default"},
> > > +	{4, "trusted."},
> > > +	{6, "security."},
> > > +	{7, "system."},
> > 
> > It seems that we also have a _RICHACL name here.
> 
> Yes.  Do you know what it's used for?  EXT4_XATTR_INDEX_RICHACL isn't used as
> of 3.13-rc1.

Sorry, I just look at this mail.  If I remember correctly, this flag is
added by Jan Kara because he want to reserve this flag for rich acl
which has been implemented out of upstream kernel tree.

Thanks,
                                                - Zheng
