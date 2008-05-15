From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: Group meta-data blocks together.
Date: Thu, 15 May 2008 11:14:51 -0500
Message-ID: <482C617B.8090909@redhat.com>
References: <1210866839-7195-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1210866839-7195-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080515160626.GB23507@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, tytso@mit.edu, adilger@sun.com,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:44696 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757636AbYEOQP3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 May 2008 12:15:29 -0400
In-Reply-To: <20080515160626.GB23507@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> On Thu, May 15, 2008 at 09:23:59PM +0530, Aneesh Kumar K.V wrote:
>> This adds a per inode meta-block prealloc space from which
>> meta-data block requests are served. This help in making
>> sure meta-data block are closer. This is needed to speedup
>> unlink of the file. Any new prealloc space is allocated near
>> the goal block specified. The goal block is the last block
>> allocated for the file. So we don't keep the data-block and
>> meta-data block far apart.
>>
> 
> The result can be found at
> 
> http://www.radian.org/~kvaneesh/ext4/meta-group/

Out of curiosity, do you have graphs similar to
http://www.radian.org/~kvaneesh/ext4/meta-group/ext4-noextents-metagroup.png

before and after your change?

Thanks,
-Eric

