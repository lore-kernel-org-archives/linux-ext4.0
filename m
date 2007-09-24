From: Karel Zak <kzak@redhat.com>
Subject: Re: Patch format in ext4 patch queue.
Date: Mon, 24 Sep 2007 23:34:06 +0200
Message-ID: <20070924213406.GF4568@petra.dvoda.cz>
References: <46F39DF6.30402@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:35354 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753597AbXIXVeJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Sep 2007 17:34:09 -0400
Content-Disposition: inline
In-Reply-To: <46F39DF6.30402@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Sep 21, 2007 at 04:03:26PM +0530, Aneesh Kumar K.V wrote:
> First line should be
> <subsystem_name>: A single line description of the patch.
> This appear in the subject line of the mail that results from different
> commit list.

 BTW, we use this subject format for util-linux-ng and I have a simple
 python script that generates nice changelogs (for release notes) from
 git log.

 IMHO a changelog [1] that is sorted and grouped by <subsystem_name>
 is better for end-users that output from git-shortlog.

    Karel


 [1] see Changelog section:
    ftp://ftp.kernel.org/pub/linux/utils/util-linux-ng/v2.13/v2.13-ReleaseNotes

-- 
 Karel Zak  <kzak@redhat.com>
