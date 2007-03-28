From: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
Subject: Re: Ext3 behavior on power failure
Date: Wed, 28 Mar 2007 09:17:27 -0400 (EDT)
Message-ID: <alpine.DEB.0.83.0703280915400.30460@sigma.j-a-k-j.com>
References: <A74E8B4A356D8143B79BBEB839421F3004023496@CORPUSMX20B.corp.emc.com>
 <4603B03E.7080302@emc.com>
 <20070328124015.GG14935@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=us-ascii
Cc: Ric Wheeler <ric@emc.com>, armangau_philippe@emc.com,
	ext3-users@redhat.com, linux-ext4@vger.kernel.org,
	csar@stanford.edu
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from hammerhead.shentel.net ([204.111.1.228]:34108 "EHLO
	hammerhead.shentel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbXC1NRq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Mar 2007 09:17:46 -0400
In-Reply-To: <20070328124015.GG14935@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>  If you fsync() your data, you are guaranteed that also your data are
> safely on disk when fsync returns. So what is the question here?

Pardon a newbie's intrusion, but I do know this isn't true. There is a 
window of possible loss because of the multitude of layers of caching, 
especially within the drive itself. Unless there is a super_duper_fsync() 
that is able to actually poll the hardware and get a confirmation that the 
internal buffers are purged?
