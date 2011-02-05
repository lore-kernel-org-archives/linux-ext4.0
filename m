From: Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] Drop ext2/ext3 codebase? When?
Date: Sat, 05 Feb 2011 13:43:17 -0500
Message-ID: <1296931397.6481.0.camel@heimdal.trondhjem.org>
References: <20110203144011.GA28409@quack.suse.cz> <4D4AC4E2.701@redhat.com>
	 <AANLkTi=YxSpgm9vYHBKdASpLOaY_U3=ggsE8yTg_G0Bc@mail.gmail.com>
	 <20110204131739.GC4104@quack.suse.cz>  <4D4C3154.3020502@gmail.com>
	 <1296839873.3025.39.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: Ric Wheeler <ricwheeler@gmail.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Michael Rubin <mrubin@google.com>, Jan Kara <jack@suse.cz>,
	lsf-pc@lists.linuxfoundation.org, linux-fsdevel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.netapp.com ([216.240.18.37]:51331 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753268Ab1BESnU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Feb 2011 13:43:20 -0500
In-Reply-To: <1296839873.3025.39.camel@mulgrave.site>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 2011-02-04 at 11:17 -0600, James Bottomley wrote: 
> On Fri, 2011-02-04 at 12:03 -0500, Ric Wheeler wrote:
> > On 02/04/2011 08:17 AM, Jan Kara wrote:
> ext2 yes ... I think there's no way we can drop ext3: it's still a
> current default filesystem for most distributions.  Now, if we discuss
> dropping ext2 and working out an end of life plan for ext3 (for the
> feature removals schedule) so we don't eventually get into the same
> position with it as we are with ext2, then this sounds like a plan.
> 
> > Great topic, might require beer though to be done right :)
> 
> I'm invoking the anti-discrimination statutes here on behalf of those of
> us who don't like beer.

OK. I'm putting this as filesystems track only proposal, then...

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

