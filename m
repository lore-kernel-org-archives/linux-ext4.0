From: Alex Tomas <alex@clusterfs.com>
Subject: Re: delayed allocatiou result in Oops
Date: Wed, 20 Jun 2007 12:15:09 +0400
Message-ID: <4678E20D.6060108@clusterfs.com>
References: <20070614072352.GA6517@localhost.sw.ru>	 <4672202C.4080304@clusterfs.com>	 <1181949368.3808.7.camel@dyn9047017103.beaverton.ibm.com>	 <20070616081426.GB14349@localhost.sw.ru>	 <1182214878.3711.21.camel@dyn9047017103.beaverton.ibm.com>	 <46778186.9030306@clusterfs.com> <1182270229.4113.8.camel@dyn9047017103.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Dmitriy Monakhov <dmonakhov@sw.ru>, linux-ext4@vger.kernel.org
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.chehov.net ([80.71.245.247]:61152 "EHLO mail.rialcom.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753021AbXFTIPa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Jun 2007 04:15:30 -0400
In-Reply-To: <1182270229.4113.8.camel@dyn9047017103.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Mingming Cao wrote:
> Hmm, PageMappedToDisk is probably not sufficient enough for pagesize!
> =blocksize. Is that the reason we need page->private to pass the
> request?

PageMappedToDisk isn't enough in that case, definitely. bh is the way
to track state of each block (this is what i'm implementing now), but
I think current nobh version (per-page flags are used) is valuable.

> That's good to know, thanks for the update. So probably above error case
> handling will be addressed in the new version? 

well, you actually can move that SetPagePrivate() few lines above
(Dmitriy already tested this).

> BTW, can you point me your latest and greatest mballoc patch? I am
> trying to forward port and merge that patch to ext4 patch queue....

I don't have version for mainline yet. will prepare soon. thanks for
your interest.

thanks, Alex
