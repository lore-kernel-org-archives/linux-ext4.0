From: Jan Kara <jack@suse.cz>
Subject: Re: Ext3 behavior on power failure
Date: Wed, 28 Mar 2007 17:00:03 +0200
Message-ID: <20070328150003.GE29587@duck.suse.cz>
References: <A74E8B4A356D8143B79BBEB839421F3004023496@CORPUSMX20B.corp.emc.com> <4603B03E.7080302@emc.com> <20070328124015.GG14935@atrey.karlin.mff.cuni.cz> <alpine.DEB.0.83.0703280915400.30460@sigma.j-a-k-j.com> <A74E8B4A356D8143B79BBEB839421F300415A86B@CORPUSMX20B.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jakj@j-a-k-j.com, jack@suse.cz, ric@popimap.lss.emc.com,
	ext3-users@redhat.com, linux-ext4@vger.kernel.org,
	csar@stanford.edu
To: armangau_philippe@emc.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:56577 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932183AbXC1OxM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 Mar 2007 10:53:12 -0400
Content-Disposition: inline
In-Reply-To: <A74E8B4A356D8143B79BBEB839421F300415A86B@CORPUSMX20B.corp.emc.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 28-03-07 10:17:33, armangau_philippe@emc.com wrote:
> In my case the disk cache is not a  problem - We use an emc disk array
> the write cache is protected - 
> Once the data has made over the disk array we can assume it is safe - 
  Then if you are able to reproduce the situation that not all data
is written after fsync(); poweroff; that is a bug worth reporting..

								Honza
> 
> -----Original Message-----
> From: John Anthony Kazos Jr. [mailto:jakj@j-a-k-j.com] 
> Sent: Wednesday, March 28, 2007 9:17 AM
> To: Jan Kara
> Cc: wheeler, richard; armangau, philippe; ext3-users@redhat.com;
> linux-ext4@vger.kernel.org; csar@stanford.edu
> Subject: Re: Ext3 behavior on power failure
> 
> >  If you fsync() your data, you are guaranteed that also your data are
> > safely on disk when fsync returns. So what is the question here?
> 
> Pardon a newbie's intrusion, but I do know this isn't true. There is a 
> window of possible loss because of the multitude of layers of caching, 
> especially within the drive itself. Unless there is a
> super_duper_fsync() 
> that is able to actually poll the hardware and get a confirmation that
> the 
> internal buffers are purged?
> 
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
