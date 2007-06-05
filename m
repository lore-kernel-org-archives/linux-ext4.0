From: Carsten Otte <cotte@de.ibm.com>
Subject: Re: [PATCH] [RESEND] ext[34] orphan list check on destroy_inode
Date: Tue, 05 Jun 2007 12:34:31 +0200
Message-ID: <46653C37.7040303@de.ibm.com>
References: <466538C9.8080104@sw.ru>
Reply-To: carsteno@de.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, devel@openvz.org,
	linux-ext4@vger.kernel.org, Stephen Tweedie <sct@redhat.com>,
	adilger@clusterfs.com
To: Vasily Averin <vvs@sw.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.29.156]:35400 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763457AbXFEKef (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Jun 2007 06:34:35 -0400
In-Reply-To: <466538C9.8080104@sw.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Vasily Averin wrote:
> Customers claims to ext3-related errors, investigation showed that ext3 orphan
> list has been corrupted and have the reference to non-ext3 inode. The following
> debug helps to understand the reasons of this issue.
This looks like it might be related to the -as far as I recall- 
unfixed issue we've noticed some time ago: 
http://osdir.com/ml/file-systems/2004-02/msg00033.html

I have'nt heard any reports  of a reproduction on modern kernels on 
390 lately, our issue seems to have disappeared.

so long,
Carsten
