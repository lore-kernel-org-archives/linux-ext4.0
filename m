From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: Group meta-data blocks together.
Date: Mon, 19 May 2008 10:45:28 -0500
Message-ID: <4831A098.1070604@redhat.com>
References: <1210866839-7195-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1210866839-7195-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080515160626.GB23507@skywalker> <482C617B.8090909@redhat.com> <20080519095752.GA2762@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, tytso@mit.edu, adilger@sun.com,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:53761 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960AbYESPpg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 May 2008 11:45:36 -0400
In-Reply-To: <20080519095752.GA2762@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> On Thu, May 15, 2008 at 11:14:51AM -0500, Eric Sandeen wrote:
>> Aneesh Kumar K.V wrote:
>>> On Thu, May 15, 2008 at 09:23:59PM +0530, Aneesh Kumar K.V wrote:
>>>> This adds a per inode meta-block prealloc space from which
>>>> meta-data block requests are served. This help in making
>>>> sure meta-data block are closer. This is needed to speedup
>>>> unlink of the file. Any new prealloc space is allocated near
>>>> the goal block specified. The goal block is the last block
>>>> allocated for the file. So we don't keep the data-block and
>>>> meta-data block far apart.
>>>>
>>> The result can be found at
>>>
>>> http://www.radian.org/~kvaneesh/ext4/meta-group/
>> Out of curiosity, do you have graphs similar to
>> http://www.radian.org/~kvaneesh/ext4/meta-group/ext4-noextents-metagroup.png
>>
>> before and after your change?
> 
> http://www.radian.org/~kvaneesh/ext4/meta-group/exp1/

Thanks!

On:
http://www.radian.org/~kvaneesh/ext4/meta-group/exp1/ext4-noextents-withoutpatch-rm.png

it seems interesting; do you know what's going on between ~40s and 100s?

Also:

between:
http://www.radian.org/~kvaneesh/ext4/meta-group/exp1/ext4-noextents-read.png
and
http://www.radian.org/~kvaneesh/ext4/meta-group/exp1/ext4-noextents-withoutpatch-read.png

it looks like about a 10% slowdown on the read....

-Eric
