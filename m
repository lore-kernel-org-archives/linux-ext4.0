From: Jan Kara <jack@suse.cz>
Subject: Re: Tuxera test suite failure for setfacl
Date: Wed, 5 Feb 2014 21:08:01 +0100
Message-ID: <20140205200801.GA31318@quack.suse.cz>
References: <87mwi69jas.fsf@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	ext4 development <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58688 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755333AbaBEUIE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 5 Feb 2014 15:08:04 -0500
Content-Disposition: inline
In-Reply-To: <87mwi69jas.fsf@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

On Wed 05-02-14 11:45:39, Aneesh Kumar K.V wrote:
> With commit c6ac12a6159c802ae8b757dd13563564e64333df we are modifying
> the ctime of the file when changing file's permission by setfacl. The
> commit says that is correct as per spec. But we do have a test in tuxera
> http://tuxera.com/sw/qa/pjd-fstest-20090130-RC.tgz test/xacl/00.t 45
> which expect the ctime to be not changed across setfacl.
> 
> I haven't looked at the spec myself. Can you double check and make sure
> it is ok to change the ctime across setfacl ?
  Well, it would be really strange if changing permissions via chmod(1)
changed ctime but via setfacl(1) did not, don't you think?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
