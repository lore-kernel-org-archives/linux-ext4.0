From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] filesystems: use has_capability_noaudit interface for
	reserved blocks checks
Date: Thu, 13 Nov 2008 18:07:17 -0500
Message-ID: <20081113230717.GA25117@mit.edu>
References: <1226430769.3353.5.camel@localhost.localdomain> <20081113145316.e53858bd.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
	sct@redhat.com, adilger@sun.com, linux-ext4@vger.kernel.org,
	dedekind@infradead.org, ext-adrian.hunter@nokia.com,
	linux-mtd@lists.infradead.org, dushistov@mail.ru, jmorris@namei.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:33028 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752054AbYKMXHe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Nov 2008 18:07:34 -0500
Content-Disposition: inline
In-Reply-To: <20081113145316.e53858bd.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 13, 2008 at 02:53:16PM -0800, Andrew Morton wrote:
> On Tue, 11 Nov 2008 14:12:49 -0500
> Eric Paris <eparis@redhat.com> wrote:
> 
> > ext[2,3,4], ufs, and ubifs all check for  CAP_SYS_RESOURCE to determine
> > if they should allow reserved blocks to be used.  A process not having
> > this capability is not failing some security decision and should not be
> > audited.  Thus move to using has_capability_noaudit.
> > 
> > Signed-off-by: Eric Paris <eparis@redhat.com>
> > ---
> > 
> > I would like to push this patch through the security tree (since that's
> > the only place the new cap_noaudit interface exists), but I'd like to
> > get an ACK from each subsystem maintainer.

For ext4:

Acked-by: "Theodore Ts'o" <tytso@mit.edu>

						- Ted
