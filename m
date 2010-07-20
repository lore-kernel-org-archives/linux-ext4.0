From: Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [PATCH -V2 00/16]  New ACL format for better NFSv4 acl interoperability
Date: Tue, 20 Jul 2010 12:11:53 +0200
Message-ID: <201007201211.53289.agruen@suse.de>
References: <1278096227-16784-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <201007192119.50868.agruen@suse.de> <m34ofucxes.fsf@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: sfrench@us.ibm.com, ffilz@us.ibm.com, adilger@sun.com,
	sandeen@redhat.com, tytso@mit.edu, staubach@redhat.com,
	bfields@citi.umich.edu, jlayton@redhat.com,
	linux-fsdevel@vger.kernel.org, nfsv4@linux-nfs.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57317 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932069Ab0GTKL4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 Jul 2010 06:11:56 -0400
In-Reply-To: <m34ofucxes.fsf@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tuesday 20 July 2010 11:31:07 Aneesh Kumar K. V wrote:
> We need to update ACL4_VALID_FLAGS to now consider ACL4_MASKED as a
> valid flag.  This is also needed for userspace.

Good point, I missed that.

> On a related note, should we move ACL4_MASKED and ACL4_POSIX_MAPPED to
> be the higher bits ? That would make sure we will be able to accomodate
> new flag value NFSv4 define.

That makes sense, except that ACL4_POSIX_MAPPED hasn't entered the scene in 
the patches posted here, and I'm still not convinced that we'll actually need 
it.

Thanks,
Andreas
