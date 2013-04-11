From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 1/2 v2] ext4: move ext4_ind_migrate() into migrate.c
Date: Thu, 11 Apr 2013 10:18:16 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1304111013191.10609@dhcp-1-230.brq.redhat.com>
References: <1365506687-9216-1-git-send-email-lczerner@redhat.com> <20130411035826.GA18878@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	gnehzuil.liu@gmail.com
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49893 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753237Ab3DKISX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Apr 2013 04:18:23 -0400
In-Reply-To: <20130411035826.GA18878@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 10 Apr 2013, Theodore Ts'o wrote:

> Date: Wed, 10 Apr 2013 23:58:26 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: linux-ext4@vger.kernel.org, gnehzuil.liu@gmail.com
> Subject: Re: [PATCH 1/2 v2] ext4: move ext4_ind_migrate() into migrate.c
> 
> On Tue, Apr 09, 2013 at 01:24:46PM +0200, Lukas Czerner wrote:
> > Move ext4_ind_migrate() into migrate.c file since it makes much more
> > sense and ext4_ext_migrate() is there as well.
> > 
> > Also fix tiny style problem - add spaces around "=" in "i=0".
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> 
> I had to regenerate this patch since ext4_ind_migrate has been changed
> by other patches in the ext4 patch queue, but it's applied now.

Thanks, but Dmitry is right, the check should be before the
journal_start() call.

I am not sure how much work will it be for you, but would it be
possible to resend patch to the list when you change it ? Just to
make sure we do not get unnecessary problems.

Thanks!
-Lukas

> 
>    	 	    	     	   - Ted
> 
