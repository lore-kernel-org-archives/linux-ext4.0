From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] [RFC] remove ext3 inode from orphan list when link and
 unlink race
Date: Thu, 18 Jan 2007 09:28:58 -0600
Message-ID: <45AF923A.5000809@redhat.com>
References: <45A7F384.3050303@redhat.com> <20070117224304.GM5236@schatzie.adilger.int> <45AEA789.20407@redhat.com> <20070118104338.GZ5236@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:34963 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932460AbXARP33 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Jan 2007 10:29:29 -0500
To: Andreas Dilger <adilger@clusterfs.com>
In-Reply-To: <20070118104338.GZ5236@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andreas Dilger wrote:
>> Ah, ok.  Sorry I'd missed that.  Can we at least rename them to
>> something that makes sense? :)
> 
> I have no objection to renaming them, but had previously left them as-is
> because it meant a smaller patch.

*shrug* not a big deal; I can wait.  Was just one of those things I came
across while looking in this area.

Thanks,

-Eric
