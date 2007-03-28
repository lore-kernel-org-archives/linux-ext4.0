From: Jan Kara <jack@suse.cz>
Subject: Re: Ext3 behavior on power failure
Date: Wed, 28 Mar 2007 15:29:04 +0200
Message-ID: <20070328132903.GI14935@atrey.karlin.mff.cuni.cz>
References: <A74E8B4A356D8143B79BBEB839421F3004023496@CORPUSMX20B.corp.emc.com> <4603B03E.7080302@emc.com> <20070328124015.GG14935@atrey.karlin.mff.cuni.cz> <alpine.DEB.0.83.0703280915400.30460@sigma.j-a-k-j.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ric Wheeler <ric@emc.com>, armangau_philippe@emc.com,
	ext3-users@redhat.com, linux-ext4@vger.kernel.org,
	csar@stanford.edu
To: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:40059 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbXC1N3E (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Mar 2007 09:29:04 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.0.83.0703280915400.30460@sigma.j-a-k-j.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> > If you fsync() your data, you are guaranteed that also your data are
> >safely on disk when fsync returns. So what is the question here?
> Pardon a newbie's intrusion, but I do know this isn't true. There is a 
> window of possible loss because of the multitude of layers of caching, 
> especially within the drive itself. Unless there is a super_duper_fsync() 
> that is able to actually poll the hardware and get a confirmation that the 
> internal buffers are purged?
  OK :), to correct myself: After fsync() returns, all the data is acked from
the disk (or at least it should be like that unless there's a bug
somewhere). So if there are some caches in the hardware which the hardware
is not able to flush on power failure, that's a bad luck... That's why
you should turn off write caching on cheaper disks if you really care
about data integrity.

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
